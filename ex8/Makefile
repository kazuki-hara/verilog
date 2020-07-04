all:
	iverilog -g2012 test.v pu.v alu.v pc.v imem.v rega.v lidx.v dec.v dmem.v sel.v
	vvp a.out
pu:
	iverilog -g2012 pu.v alu.v pc.v imem.v rega.v
alu:
	iverilog -g2012 alu.v
pc:
	iverilog -g2012 pc.v
imem:
	iverilog -g2012 imem.v
rega:
	iverilog -g2012 rega.v
lidx:
	iverilog -g2012 lidx.v
dec:
	iverilog -g2012 dec.v
dmem:
	iverilog -g2012 dmem.v
sel:
	iverilog -g2012 sel.v
yosys:
	yosys pu.ys
