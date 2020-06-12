module rega(input logic [1:0] arad, brad, output logic [15:0] a, b,
	input we, input logic [1:0] wad, input [15:0] wd,
	input clk, rst);
	logic [15:0] regar [3:0];
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			regar[0] <= 0;
			regar[1] <= 1;
		end else if(we) regar[wad] <= wd;
	end
	assign a = regar[arad];
	assign b = regar[brad];
endmodule
