module vending(input clk, rst, coin_10, coin_50, output item, output [6:0] change);
    logic [6:0] state=7'b0, nextstate=7'b0;
    logic item=0;
    logic [6:0] change=7'b0;

    always @(posedge clk)begin
        state <= nextstate;
    end

    always_comb begin
        nextstate = state;
        case(state)
        // synopsys full_case parallel_case
            0:begin
                case({coin_10,coin_50})
                // synopsys full_case parallel_case
                    2'b01: nextstate = 50;
                    2'b10: nextstate = 10;
                    2'b11: nextstate = 60;
                endcase
            end
            10:begin
                case({coin_10,coin_50})
                // synopsys full_case parallel_case
                    2'b01: nextstate = 60;
                    2'b10: nextstate = 20;
                    2'b11: nextstate = 70;
                endcase
            end
            20:begin
                case({coin_10,coin_50})
                // synopsys full_case parallel_case
                    2'b01: nextstate = 70;
                    2'b10: nextstate = 30;
                    2'b11: nextstate = 80;
                endcase
            end
            30:begin
                case({coin_10,coin_50})
                // synopsys full_case parallel_case
                    2'b01: nextstate = 80;
                    2'b10: nextstate = 40;
                    2'b11: nextstate = 90;
                endcase
            end
            40:begin
                case({coin_10,coin_50})
                // synopsys full_case parallel_case
                    2'b01: nextstate = 90;
                    2'b10: nextstate = 50;
                    2'b11: nextstate = 100;
                endcase
            end
        endcase
        if(state>=50) begin
            change = state-50;
            item = 1;
            nextstate = 0;
        end
    end
endmodule

module test;
    logic clk, rst, buy, coin_10, coin_50;
    logic item;
    logic [6:0] change;
    vending x(clk, rst, coin_10, coin_50, item, change);
    initial begin
        rst = 0;
        coin_10=0;
        coin_50=0;
        $dumpfile("vending.vcd");
        $dumpvars(0, test);
        rst = 1;
        #1;
        rst = 0;
        coin_10 = 1;
        #2;
        coin_10=0;
        coin_50=1;
        #1;
        coin_50=0;
        #1;
        $finish;
    end
    always begin
        clk = 0;
        clk = 1;
        #1;
    end
endmodule

