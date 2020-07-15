`include "sw.vh"
module mkwe(input [`PKTW:0] pkti, output logic we);
    always@*
		if(pkti[9:8] == `EMPT) we = 0;
		else we = 1;
endmodule

/*
module test;
	logic [9:0] pkti;
	logic we, clk, rst;
	always #5 clk = ~clk;
	mkwe mkwe(pkti, we);
	initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
	rst = 1'b1;
	clk = 1'b1;
    pkti = 10'b0000000000;
    #10
    pkti = 10'b1111111111;
    #20
	$finish;
	end
endmodule
*/