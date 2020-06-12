module alu(input [15:0] a, b, input [2:0] op, output logic [15:0] r);
	enum {ADD, TRU, MIN, SE0, SE1} OPTYPE;
	always_comb
		case(op)
		// synopsys full_case parallel_case
		ADD: r = a+b;	
		TRU: r = a;
		MIN: r = b-a;
		SE0: r = 0;
		SE1: r = 1;
		endcase
endmodule
