module timer(input [7:0]val, input clk, rst, en, output b);
    logic [1:0] count;
    logic b;
    logic [1:0]b_count;
    always @(posedge clk) begin
        if(rst) begin
            count <=0;
            b<=0;
            b_count <= 0;
        end
        else begin
            if(en) begin
                if(count!=0) count <= count-1;
                else begin 
                    if(b_count<=3)begin
                        if(b) b<=0;
                        else begin
                            b<=1;
                            b_count <= b_count+1;                       
                        end
                    end
                end
            end else count <= val;
        end   
    end
endmodule

module test;
    logic [7:0] val;
    logic clk, rst, en, b;
    timer tm(val, clk, rst, en, b);
    initial begin
        en = 0;
        val = 0;
        rst = 0;
        $dumpfile("timer.vcd");
        $dumpvars(0, test);
        rst = 1;
        #1;
        rst = 0;
        val = 4;
        #1;
        en = 1;
        #10;
        rst = 1;
        #2;
        $finish;
    end
    always begin
        clk = 0;
        clk = 1;
        #1;
    end
endmodule