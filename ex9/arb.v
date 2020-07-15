`include "sw.vh"

module arb(input req0, req1, req2, req3, output logic ack0, ack1, ack2, ack3, input clk, rst);
    logic [1:0] pc, next_pc;
    always@(posedge clk)begin
        if(rst) begin
            pc <= 2'b00;
        end else begin
            pc <= next_pc;
        end
    end
    always@* begin
        if(rst)next_pc = 2'b01;
        else begin
            ack0 = `NEGATE;
            ack1 = `NEGATE;
            ack2 = `NEGATE;
            ack3 = `NEGATE;
            case(pc)
            // synopsys full_case parallel_case
            2'b00: begin
                if(req0) ack0 = `ASSERT;
                else if(req1) ack1 = `ASSERT;
                else if(req2) ack2 = `ASSERT;
                else if(req3) ack3 = `ASSERT;
                else next_pc = 2'b01;
            end
            2'b01: begin
                if(req1) ack1 = `ASSERT;
                else if(req2) ack2 = `ASSERT;
                else if(req3) ack3 = `ASSERT;
                else if(req0) ack0 = `ASSERT;
                else next_pc = 2'b10;
            end
            2'b10: begin
                if(req2) ack2 = `ASSERT;
                else if(req3) ack3 = `ASSERT;
                else if(req0) ack0 = `ASSERT;
                else if(req1) ack1 = `ASSERT;
                else next_pc = 2'b10;
            end
            2'b11: begin
                if(req3) ack3 = `ASSERT;
                else if(req0) ack0 = `ASSERT;
                else if(req1) ack1 = `ASSERT;
                else if(req2) ack2 = `ASSERT;
                else next_pc = 2'b00;
            end
            endcase
        end
    end
endmodule

/*
module arb(input req0, req1, req2, req3, output logic ack0, ack1, ack2, ack3, input clk, rst);
    logic [1:0] pc, next_pc, na_pc;
    logic [`PORT:0] req, ack;
    always@(posedge clk)begin
        if(rst) begin
            pc <= 2'b00;
            next_pc <= 2'b00;
        end else begin
            pc <= next_pc;
        end
    end

    always@* begin
        if(rst)begin
            na_pc = 2'b01;
        end else begin
            ack = 4'b0000;
            if(req[pc]) ack[pc] = `ASSERT;
            else if(req[pc+1]) ack[pc+1] = `ASSERT;
            else if(req[pc+2]) ack[pc+2] = `ASSERT;
            else if(req[pc+3]) ack[pc+3] = `ASSERT;
            else na_pc = pc+1;
        end
    end

    always@* begin
        req = {req3, req2, req1, req0};
        {ack3, ack2, ack1, ack0} = ack;
    end

    always@(negedge req0 or negedge req1 or negedge req2 or negedge req3)begin
        next_pc <= na_pc;
    end
endmodule
*/
/*
module test;
    logic req0, req1, req2, req3, ack0, ack1, ack2, ack3;
    logic clk, rst;
	arb arb(req0, req1, req2, req3, ack0, ack1, ack2, ack3, clk, rst);
    always #5 clk = ~clk;
	initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
    rst = 1;
    clk = 1;
    #10
    req0 = `NEGATE;
    req1 = `NEGATE;
    req2 = `NEGATE;
    req3 = `NEGATE;
    #10
    rst = 0;
    #10
    req2 = `ASSERT;
    #30
    req0 = `ASSERT;
    #30
    req2 = `NEGATE;
    #30
    req1 = `ASSERT;
    #30
    req0 = `NEGATE;
    #30
    req1 = `NEGATE;
    #30
	$finish;
	end
endmodule
*/