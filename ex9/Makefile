all:
	iverilog -g2012 ackor.v arb.v cb.v cbsel.v fifo.v ib.v ibout.v ibsm.v mkreq.v mkwe.v sw.v swtest.v
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
