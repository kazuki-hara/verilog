`include "sw.vh"
module arb(input req0, req1, req2, req3, output ack0, ack1, ack2, ack3, input clk, rst);
    logic [1:0] state;
    logic ack0, ack1, ack2, ack3;
    always@(posedge clk)begin
        if(rst) begin
            start <= 2'b00;
            ack0 <= `NEGATE;
            ack1 <= `NEGATE;
            ack2 <= `NEGATE;
            ack3 <= `NEGATE;
        end else begin
            ack0 <= `NEGATE;
            ack1 <= `NEGATE;
            ack2 <= `NEGATE;
            ack3 <= `NEGATE;
            case(state)
            // synopsys full_case parallel_case
            2'b00: begin
                if(req0) ack0 <= `ASSERT;
                else if(req1) ack1 <= `ASSERT;
                else if(req2) ack2 <= `ASSERT;
                else if(req3) ack3 <= `ASSERT;
            end
            2'b01: begin
                if(req1) ack1 <= `ASSERT;
                else if(req2) ack2 <= `ASSERT;
                else if(req3) ack3 <= `ASSERT;
                else if(req0) ack0 <= `ASSERT;
            end
            2'b10: begin
                if(req2) ack2 <= `ASSERT;
                else if(req3) ack3 <= `ASSERT;
                else if(req0) ack0 <= `ASSERT;
                else if(req1) ack1 <= `ASSERT;
            end
            2'b11: begin
                if(req3) ack3 <= `ASSERT;
                else if(req0) ack0 <= `ASSERT;
                else if(req1) ack1 <= `ASSERT;
                else if(req2) ack2 <= `ASSERT;
            end
            endcase
        end
    end
    
    always@* begin
        case(state)
        // synopsys full_case parallel_case
        2'b00: if(negedge req0) state <= state+1;
        2'b01: if(negedge req1) state <= state+1;
        2'b10: if(negedge req2) state <= state+1;
        2'b11: if(negedge req3) state <= state+1;
        endcase
    end
    
endmodule

module test;
    logic req0, req1, req2, req3, ack0, ack1, ack2, ack3;
    logic clk, rst;
	arb arb(req0, req1, req2, req3, ack0, ack1, ack2, ack3, clk, rst);
    always #5 clk = ~clk;
	initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
    clk = 0;
    rst = 1;
    req0 = `NEGATE;
    req1 = `NEGATE;
    req2 = `NEGATE;
    req3 = `NEGATE;
    #10
    rst = 0;
    #10
    req1 = `ASSERT;
    #10
    req2 = `ASSERT;
    #10
    req1 = `NEGATE;
    #10
	$finish;
	end
endmodule