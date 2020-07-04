`include "pu.vh"
module dmem(input [`DMSB:0] c, input [`WIDTH:0] wd, input we, output [`WIDTH:0] rd, input clk, rst, cwe);
	logic [`WIDTH:0] dm[`DMS:0];
	logic [`DMSB:0] c_state;
	assign rd = dm[c_state];
	always @(posedge clk) begin
		if(rst) begin
			dm[16] <= 0;
			c_state <= 0;
		end else begin
			if(we) begin
				c_state <= c;
				dm[c] <= wd;
			end
			if(cwe) dm[16] <= dm[c_state]+dm[16];
		end
	end
endmodule
