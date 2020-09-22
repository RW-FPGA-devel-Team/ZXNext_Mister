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
  sda,
  scl,
  rtc
);
input clk;
input rst;
inout sda;
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

i2cSlave u_i2cSlave(
  .clk(clk),
  .rst(rst),
  .sda(sda),
  .scl(scl),
  .myReg0(rtc[ 7: 0]),
  .myReg1(rtc[15: 8]),
  .myReg2({2'b0,rtc[21:16]}),
  .myReg3(rtc[55:48]),
  .myReg4(rtc[31:24]),
  .myReg5(rtc[39:32]),
  .myReg6(rtc[47:40]),
  .myReg7(8'h0)

);


endmodule


 
