`include "sw.vh"
module mkreq(input [`PKTW:0] pkto, output logic [`PORT:0] reqi/*, input clk, rst*/);
    /*always@(posedge clk) begin
        if(rst) reqi <= 4'b0000;
        else begin
            if(pkto[9:8] == `HEAD) begin
                case(pkto[1:0])
                // synopsys full_case parallel_case
                2'b00: req <= 4'b0001;
                2'b01: req <= 4'b0010;
                2'b10: req <= 4'b0100;
                2'b11: req <= 4'b1000;
                endcase
            end
        end
    end*/
    always@* begin
        case(pkto[1:0])
            // synopsys full_case parallel_case
            2'b00: reqi <= 4'b0001;
            2'b01: reqi <= 4'b0010;
            2'b10: reqi <= 4'b0100;
            2'b11: reqi <= 4'b1000;
        endcase
    end
endmodule

/*
module test;
	logic [`PKTW:0] pkto;
    logic [3:0] reqi;
	logic clk, rst;
	always #5 clk = ~clk;
	mkreq mkreq(pkto, reqi);
	initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
	rst = 1'b1;
	clk = 1'b1;
    #10
    rst = 1'b0;
    #10
    pkto = 10'b10_00000001;
    #10
    pkto = 10'b10_00000011;
    #20
	$finish;
	end
endmodule
*/