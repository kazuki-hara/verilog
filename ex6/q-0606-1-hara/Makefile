all:
	iverilog -g2012 vending.v test.v
	vvp a.out
vending:
	iverilog -g2012 vending.v
yosys:
	yosys vending.ys
sim:
	iverilog -gspecify -T typ gate.v test.v ../../osu018_stdcells.v
	vvp a.out
