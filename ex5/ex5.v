`timescale 1ps/1ps
module led(input clk, st, input [4:0]mem[0:31], output [4:0] dot);
    logic [4:0] dot=5'b0;
    logic [4:0] cnt=0;
    logic en = 0;
    always@(posedge clk) begin 
        if(st)if(en ==0) en <=1;
        if(en) begin
            dot <= mem[cnt];
            $display("%b", mem[cnt]);
            $display("%b", dot);
            cnt <= cnt+1;
            if(cnt==31) begin
                cnt<=0;
                dot <= 5'b0;
                en<=0;
            end
        end
    end
endmodule



module test;
    logic [4:0]mem[0:31];
    logic [4:0] dot;
    logic st=1'b0;
    bit clk;

    integer i;
    always #5 clk = ~clk;
    led x(clk, st, mem, dot);
    initial begin
        $readmemb("pattern.txt", mem);
        for(i=0;i<32;i++)$display("%b", mem[i]);
        $dumpfile("led.vcd");
        $dumpvars(0, test);
        #100;
        st=1;
        #10;
        st=0;
        #500;
        $finish;
    end
endmodule





