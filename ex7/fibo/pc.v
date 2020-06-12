module pc(input halt, output logic [5:0] pc, input clk, rst);
	always @(posedge clk or posedge rst)
		if(rst) pc <= 0;
		else if(!halt) pc <= pc + 1;
endmodule
