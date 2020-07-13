all:
	iverilog -g2012 2012 *.v
	vvp a.out

show:
	gtkwave sw.vcd

syn:
	yosys sw.ys

test:
	iverilog -g2012 arb.v
	vvp a.out
	gtkwave test.vcd