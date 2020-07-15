`include "sw.vh"
module ackor(input ack0n, ack1n, ack2n, ack3n, output ack);
    logic ack;
    always@*
        ack = ack0n | ack1n | ack2n | ack3n;
endmodule

/*
module test;
    logic ack0n, ack1n, ack2n, ack3n;
    logic ack;
	ackor ackor(ack0n, ack1n, ack2n, ack3n, ack);
	initial begin
	$dumpfile("test.vcd");
	$dumpvars(0, test);
    ack0n = `NEGATE;
    ack1n = `NEGATE;
    ack2n = `NEGATE;
    ack3n = `NEGATE;
    #10
    ack1n = `ASSERT;
    #10
    ack2n = `ASSERT;
    #10;
	$finish;
	end
endmodule
*/