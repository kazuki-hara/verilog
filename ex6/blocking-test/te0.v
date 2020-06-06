`timescale 1ns/1ps
module test;
	logic a, clk;
	test0 test(a, b, c, clk);
	always #5 clk = ~clk;
initial begin
$dumpfile("test0.vcd");
$dumpvars(0, test);
clk = 0;
a = 0;
#20
a = 1;
#20
a = 0;
$finish;
end
endmodule
