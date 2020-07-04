`include "pu.vh"
module sel(input [`WIDTH:0] a, b, input s, output logic [`WIDTH:0] o);
	always@*
		if(s) o = b;
		else o = a;
endmodule
