set clk_sys {*|pll|pll_inst|altera_pll_i|*[0].*|divclk}
set CLK_28_n {*|pll|pll_inst|altera_pll_i|*[1].*|divclk}
set CLK_56 {*|pll|pll_inst|altera_pll_i|*[2].*|divclk}
set CLK_14 {*|pll|pll_inst|altera_pll_i|*[3].*|divclk}
set CLK_7 {*|pll|pll_inst|altera_pll_i|*[4].*|divclk}


set_multicycle_path -from [get_clocks $CLK_56] -to [get_clocks $clk_sys] -setup 2
set_multicycle_path -from [get_clocks $CLK_56] -to [get_clocks $clk_sys] -hold 1


set_multicycle_path -to {emu|ZXNEXT_Mister|*} -setup 2
set_multicycle_path -to {emu|ZXNEXT_Mister|*} -hold 1


set_multicycle_path -to {emu|ZXNEXT_Mister|zxnext|cpu_mod|*} -setup 2
set_multicycle_path -to {emu|ZXNEXT_Mister|zxnext|cpu_mod|*} -hold 1


set_multicycle_path -to {spi_sck} -setup 2
set_multicycle_path -to {spi_sck} -hold 1

derive_pll_clocks
derive_clock_uncertainty