`include "sw.vh"
module cb(input [`PKTW:0] co0, co1, co2, co3, output logic [`PKTW:0] o0, o1, o2, o3, 
input [`PORT:0] ack0, ack1, ack2, ack3);
    cbsel cbsel0(co0, co1, co2, co3, o0, ack0);
    cbsel cbsel1(co0, co1, co2, co3, o1, ack1);
    cbsel cbsel2(co0, co1, co2, co3, o2, ack2);
    cbsel cbsel3(co0, co1, co2, co3, o3, ack3);
endmodule