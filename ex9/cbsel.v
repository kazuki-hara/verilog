`include "sw.vh"
module cbsel(input [`PKTW:0] i0, i1, i2, i3, output logic [`PKTW:0] o ,input [`PORT:0] ack);
    always@* begin
        o = 0;
        case(ack)
        // synopsys full_case parallel_case
        4'b0001: o = i0;
        4'b0010: o = i1;
        4'b0100: o = i2;
        4'b1000: o = i3;
        endcase
    end
endmodule