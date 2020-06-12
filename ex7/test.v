module test;
	logic clk, rst;
	top top(clk, rst);
	always #5 clk =~ clk;
	initial begin
	$dumpfile("fibo.vcd");
	$dumpvars(0, top);
	rst = 1;
	clk = 0;
	#20
	rst = 0;
	#500
	$finish;
	end
endmodule
