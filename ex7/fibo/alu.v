module alu(input [15:0] a, b, input [2:0] op, output logic [15:0] r);
	enum {ADD, TRU} OPTYPE;
	always_comb
		case(op[0])
		// synopsys full_case parallel_case
		ADD: r = a+b;	
		TRU: r = a;
		endcase
endmodule
