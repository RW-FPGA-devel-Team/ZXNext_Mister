//////////////////////////////////////////////////////////////////////
////                                                              ////
//// registerInterface.v                                          ////
////                                                              ////
//// This file is part of the i2cSlave opencores effort.
//// <http://www.opencores.org/cores//>                           ////
////                                                              ////
//// Module Description:                                          ////
//// You will need to modify this file to implement your 
//// interface.
//// Add your control and status bytes/bits to module inputs and outputs,
//// and also to the I2C read and write process blocks  
////                                                              ////
//// To Do:                                                       ////
//// 
////                                                              ////
//// Author(s):                                                   ////
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


module registerInterface (
  clk,
  addr,
  dataIn,
  writeEn,
  dataOut,
  Reg0,
  Reg1,
  Reg2,
  Reg3,
  Reg4,
  Reg5,
  Reg6,
  Reg7

);
input clk;
input [5:0] addr;
input [7:0] dataIn;
input writeEn;
output [7:0] dataOut;

input [7:0] Reg0;
input [7:0] Reg1;
input [7:0] Reg2;
input [7:0] Reg3;
input [7:0] Reg4;
input [7:0] Reg5;
input [7:0] Reg6;
input [7:0] Reg7;



reg [7:0] dataOut;
reg [7:0] mem [64];

	
// --- I2C Read
always @(posedge clk) begin
  case (addr)
    6'h00: dataOut <= Reg0;  
    6'h01: dataOut <= Reg1;  
    6'h02: dataOut <= Reg2;  
    6'h03: dataOut <= Reg3;  
    6'h04: dataOut <= Reg4;  
    6'h05: dataOut <= Reg5;  
    6'h06: dataOut <= Reg6;  
    6'h07: dataOut <= Reg7; 
    6'h3E: dataOut <= 8'h5A;
    6'h3F: dataOut <= 8'h58;
    default: dataOut <= mem[addr];
  endcase
end

// --- I2C Write
always @(posedge clk) begin
  if (writeEn == 1'b1 && addr>6'h07) begin
	 	mem[addr] <= dataIn;
 end
end

endmodule


 
