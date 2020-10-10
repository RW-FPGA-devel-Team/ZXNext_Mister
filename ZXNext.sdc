set_multicycle_path -to {emu|ZXNEXT_Mister|*} -setup 2
set_multicycle_path -to {emu|ZXNEXT_Mister|*} -hold 1


set_multicycle_path -to {emu|ZXNEXT_Mister|zxnext|cpu_mod|*} -setup 2
set_multicycle_path -to {emu|ZXNEXT_Mister|zxnext|cpu_mod|*} -hold 1


set_multicycle_path -to {spi_sck} -setup 2
set_multicycle_path -to {spi_sck} -hold 1

derive_pll_clocks
derive_clock_uncertainty