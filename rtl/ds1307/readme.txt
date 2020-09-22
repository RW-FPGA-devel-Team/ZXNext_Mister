How to 
======

Añadir a files.qip

set_global_assignment -name VERILOG_FILE rtl/ds1307/DS1307.v
set_global_assignment -name VERILOG_FILE rtl/ds1307/i2cSlave.v
set_global_assignment -name VERILOG_FILE rtl/ds1307/registerInterface.v
set_global_assignment -name VERILOG_FILE rtl/ds1307/serialInterface.v


Instanciar en zxnext_sv con 

module DS1307 (
  .clk(CLK_48MHZ),
  .rst(reset),
  .sda(i2c_sda_o),
  .scl(i2c_scl_o),
  .rtc(RTC_HPSIO)
);

CLK_48MHZ es un clk a 48Mhz, para cambiarlo, hay que recalcular.
i2c_sda_o y i2c_scl_o señales de zxnext_mister : en su interface son IO, hay que sacar solo las o.
RTC_HPSIO es la señal RTC del HPS_IO


Doc
===

Mister Firmware
RTC[64:0] 
rtc[64] : alterna al recibir un comando

Desde el firmware se envia esto a RTC : 
		uint8_t rtc[8];
		rtc[0] = (tm.tm_sec % 10) | ((tm.tm_sec / 10) << 4);
		rtc[1] = (tm.tm_min % 10) | ((tm.tm_min / 10) << 4);
		rtc[2] = (tm.tm_hour % 10) | ((tm.tm_hour / 10) << 4);
		rtc[3] = (tm.tm_mday % 10) | ((tm.tm_mday / 10) << 4);

		rtc[4] = ((tm.tm_mon + 1) % 10) | (((tm.tm_mon + 1) / 10) << 4);
		rtc[5] = (tm.tm_year % 10) | (((tm.tm_year / 10) % 10) << 4);
		rtc[6] = tm.tm_wday;
		rtc[7] = 0x40; // -> 24Hour Mode
        

DS1307 Addres
0x0 -> rtc[ 7: 0] - Sec
0x1 -> rtc[15: 8] - Min
0x2 -> {2'b0,rtc[21:16]} - Hour Format 24H
0x3 -> rtc[55:48] - WDay
0x4 -> rtc[31:24] - Day
0x5 -> rtc[39:32] - Mon
0x6 -> rtc[47:40] - Year
0x7 -> 8'b0