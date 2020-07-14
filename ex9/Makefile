all:
	iverilog -g2012 *.v
	vvp a.out
	gtkwave sw.vcd
show:
	gtkwave sw.vcd

syn:
	yosys sw.ys

test:
	iverilog -g2012 arb.v
	vvp a.out
	gtkwave test.vcd