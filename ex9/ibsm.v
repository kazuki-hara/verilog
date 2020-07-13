`include "sw.vh"
module ibsm(input [1:0]flowb, output re, input empty,
input [`PORT:0] reqi, output [`PORT:0] req, input ack, input clk, rst);
    logic [`PORT:0] req;
    logic re;
    always@(posedge clk) begin
        if(rst) begin
            re <= `NEGATE;
            req <= 4'b0000;
        end else begin
            if(ack) re <= `ASSERT;
            else re <= `NEGATE;
        end
    end

    always@* begin
        if(flowb == `HEAD) req <= reqi;
        else if(flowb == `EMPT) req <= 4'b0000;
    end
endmodule

/*
module test;
	logic [1:0] flowb;
    logic re, empty, ack;
    logic [`PORT:0] reqi, req;
	logic clk, rst;
	always #5 clk = ~clk;
	ibsm isbm(flowb, re, empty, reqi, req, ack, clk, rst);
	initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
	rst = 1'b1;
	clk = 1'b1;
    #10
    rst = 1'b0;
    #10
    ack = `ASSERT;
    flowb = 2'b10;
    reqi = 4'b0100;
    #10
    ack = `NEGATE;
    reqi = 4'b0001;
    #10
    flowb = 2'b11;
    reqi = 4'b0100;
    #10
	$finish;
	end
endmodule
*/