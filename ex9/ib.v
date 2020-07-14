`include "sw.vh"
module ib(input [`PKTW:0] pkti, output [`PKTW:0] out, output [`PORT:0] req, input ack,
	output full, input clk, rst);
	logic [`PORT:0] reqi;
    logic [`PKTW:0] pkto;
	mkwe mkwe(pkti, we);
	fifo fifo(pkti, we, full, pkto, re, empty, clk, rst);
	ibsm ibsm(pkto[`FLOWBH:`FLOWBL], re, empty, reqi, req, ack, clk, rst);
	//mkreq mkreq(pkto, reqi, clk, rst);
    mkreq mkreq(pkto, reqi);
    ibout ibout(pkto, out, re);
endmodule



/*
module test;
	logic [`PKTW:0] pkti, pkto;
    logic [`PORT:0] req;
    logic ack, full;
	logic clk, rst;
	always #5 clk = ~clk;
	ib is(pkti, pkto, req, ack, full, clk, rst);
	initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
	rst = 1'b1;
	clk = 1'b1;
    #10
    rst = 1'b0;
    #10
    ack = `ASSERT;
    pkti = 10'b10_00000010;
    #10
    pkti = 10'b01_00000000;
    #10
    pkti = 10'b01_00000001;
    #10
    pkti = 11'b01_00000000;
    #10
    pkti = 10'b00_00000000;
    #10
    ack = `NEGATE;
    pkti = 10'b10_00000010;
    #10
    pkti = 10'b01_00000000;
    #10
    pkti = 10'b01_00000001;
    #10
    pkti = 11'b01_00000000;
    #10
    pkti = 10'b00_00000000;
    #10
	$finish;
	end
endmodule
*/