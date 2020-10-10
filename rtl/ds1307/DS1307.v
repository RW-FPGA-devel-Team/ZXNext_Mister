//////////////////////////////////////////////////////////////////////
////                                                              ////
//// DS1307.v                                                     ////
////                                                              ////
//// This file is based on the i2cSlave opencores effort.         ////
//// <http://www.opencores.org/cores//>                           ////
////                                                              ////
//// Module Description:                                          ////
//// Emules DS1307 RTC using Mister Framework HPS_IO RTC signals  ////
//// Input : RTC signal from Mister Framework                     ////
////                                                              ////
//// To Do:                                                       ////
//// 
////                                                              ////
//// Original Author(s):                                          ////
//// - Steve Fielding, sfielding@base2designs.com                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 Steve Fielding and OPENCORES.ORG          ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE. See the GNU Lesser General Public License for more  ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from <http://www.opencores.org/lgpl.shtml>                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
`include "i2cSlave_define.v"


module DS1307 (
  clk,
  rst,
  sda_i,
  sda_o,
  scl,
  rtc
);
input clk;
input rst;
input sda_i;
output sda_o;
input scl;
input [64:0] rtc;

//0x0 -> rtc[ 7: 0] - Sec
//0x1 -> rtc[15: 8] - Min
//0x2 -> {2'b0,rtc[21:16]} - Hour Format 24H
//0x3 -> rtc[55:48] - WDay
//0x4 -> rtc[31:24] - Day
//0x5 -> rtc[39:32] - Mon
//0x6 -> rtc[47:40] - Year
//0x7 -> 8'b0


reg [7:0] Sec	= 0;
reg [7:0] Min	= 0;
reg [7:0] Hour	= 0;
reg [7:0] wDay	= 1;
reg [7:0] Day	= 1;
reg [7:0] Mon	= 1;
reg [7:0] Year	= 0;
reg [7:0] Reg7	= 0;


reg  [7:0] seconds_reg =0;			
reg  [7:0] minutes_reg =0;			
reg  [7:0] hours_reg =0;			
reg  [7:0] weeks_reg = 1;			
reg  [7:0] days_reg = 1;			
reg  [7:0] month_reg = 1;			
reg  [7:0] year_reg = 0;			

reg H24 = 1; 	//1= 24H format - 0= 12H Format(AM/PM)
reg AMPM = 0;	//0= AM - 1=PM
reg  [1:0] leap_reg = 0;

reg a_reg = 0;
reg [25:0] pre_scaler = 0;


always @(posedge clk) begin
	reg flg;

	flg <= rtc[64];
	if (flg != rtc[64]) begin
		seconds_reg <= rtc[7:0];
		minutes_reg <= rtc[15:8];
		hours_reg   <= {2'b0,rtc[21:16]};
		days_reg    <= rtc[31:24];
		month_reg   <= rtc[39:32];
		year_reg    <= rtc[47:40];
		weeks_reg   <= rtc[55:48] + 1'b1; //wDay
		Reg7			<= 0;
//		b_reg       <= 8'b00000010;
	end 

//	if (rst) b_reg <= 8'b00000010;

	if (rst) begin
		a_reg <= 0;
	end
//	else if (~b_reg[7] & ENA) begin
	else if (1) begin	
		if (pre_scaler) begin
			pre_scaler <= pre_scaler - 1'd1;
			a_reg <= 0;
		end
		else begin
			pre_scaler <= 28000000; //50000000;	//(0.4375MHz)
			a_reg<= 1;
			
			if (1) begin
				// DM binary-coded-decimal (BCD) data mode
				if (seconds_reg[3:0] != 9) seconds_reg[3:0] <= seconds_reg[3:0] + 1'd1;
				else begin
					seconds_reg[3:0] <= 0;
					if (seconds_reg[6:4] != 5) seconds_reg[6:4] <= seconds_reg[6:4] + 1'd1;
					else begin
						seconds_reg[6:4] <= 0;
						if (minutes_reg[3:0] != 9) minutes_reg[3:0] <= minutes_reg[3:0] + 1'd1;
						else begin
							minutes_reg[3:0] <= 0;
							if (minutes_reg[6:4] != 5) minutes_reg[6:4] <= minutes_reg[6:4] + 1'd1;
							else begin
								minutes_reg[6:4] <= 0;
								if (hours_reg[3:0] == 9) begin
									hours_reg[3:0] <= 0;
									hours_reg[5:4] <= hours_reg[5:4] + 1'd1;
								end
								else if ({H24, hours_reg[5], hours_reg[4:0]} == 7'b0010010) begin
									hours_reg[4:0] <= 1;
									hours_reg[5] <= ~hours_reg[5];
								end
								else if (({H24, hours_reg[5], hours_reg[4:0]} != 7'b0110010) &&
										({H24, hours_reg[5:0]} != 7'b1100011)) hours_reg[3:0] <= hours_reg[3:0] + 1'd1;
								else begin
									if (~H24) hours_reg[7:0] <= 1;
									else hours_reg[5:0] <= 0;

									if (weeks_reg[2:0] != 7) weeks_reg[2:0] <= weeks_reg[2:0] + 1'd1;
									else weeks_reg[2:0] <= 1;

									if (({month_reg, days_reg, leap_reg} == {16'h0228, 2'b01}) ||
										({month_reg, days_reg, leap_reg} == {16'h0228, 2'b10}) ||
										({month_reg, days_reg, leap_reg} == {16'h0228, 2'b11}) ||
										({month_reg, days_reg, leap_reg} == {16'h0229, 2'b00}) ||
										({month_reg, days_reg} == 16'h0430) ||
										({month_reg, days_reg} == 16'h0630) ||
										({month_reg, days_reg} == 16'h0930) ||
										({month_reg, days_reg} == 16'h1130) ||
										(days_reg == 8'h31)) begin
										
										days_reg[5:0] <= 1;
										if (month_reg[3:0] == 9) month_reg[4:0] <= 'h10;
										else if (month_reg[4:0] != 'h12) month_reg[3:0] <= month_reg[3:0] + 1'd1;
										else begin 
											month_reg[4:0] <= 1;
											leap_reg[1:0] <= leap_reg[1:0] + 1'd1;
											if (year_reg[3:0] != 9) year_reg[3:0] <= year_reg[3:0] + 1'd1;
											else begin
												year_reg[3:0] <= 0;
												if (year_reg[7:4] != 9) year_reg[7:4] <= year_reg[7:4] + 1'd1;
												else year_reg[7:4] <= 0;
											end
										end
									end
									else if (days_reg[3:0] != 9) days_reg[3:0] <= days_reg[3:0] + 1'd1;
									else begin
										days_reg[3:0] <= 0;
										days_reg[5:4] <= days_reg[5:4] + 1'd1;
									end
								end
							end
						end
					end
				end
			end
		end 
	end 
end


i2cSlave u_i2cSlave(
  .clk(clk),
  .rst(rst),
  .sda_i(sda_i),
  .sda_o(sda_o),
  .scl(scl),
  .Reg0(seconds_reg),
  .Reg1(minutes_reg),
  .Reg2(hours_reg),
  .Reg3(weeks_reg),
  .Reg4(days_reg),
  .Reg5(month_reg),
  .Reg6(year_reg),
  .Reg7(Reg7)
);


endmodule


 
