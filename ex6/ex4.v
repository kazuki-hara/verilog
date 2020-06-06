module vending(input clk, rst, coin_10, coin_50, output item, output [6:0] change);
    logic [6:0] state;
    logic [6:0] nextstate;
    logic item;
    logic [6:0] change;

    always @(posedge clk)begin
        if(rst) state <= 0;
        else state <= nextstate;
    end

    always@* begin
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
        end else begin
            item = 0;
            change = 0;
        end
    end
endmodule


