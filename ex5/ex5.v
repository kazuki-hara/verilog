`timescale 1ps/1ps
module led(input clk, st, input [4:0] mem [0:31], output [4:0] dot);
    logic [4:0] dot= 0;
    logic [4:0] cnt= 0;
    logic en = 0;
    always@(posedge clk) begin 
        if(en) begin
            dot <= mem[cnt];
            cnt <= cnt+1;
            if(cnt==31) begin
                en<=0;
            end
        end else dot<=0;
        if(st) en<=1;
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
        $dumpfile("led.vcd");
        $dumpvars(0, test);
        #30;
        st=1;
        #10;
        st=0;
        #340;
        st=1;
        #10;
        st=0;
        #360;
        $finish;
    end
endmodule