module top(input clk, rst);
	logic [15:0] a, b, wd;
	logic [1:0] arad, brad, wad;
	logic [2:0] op;
	logic [5:0] pca;
	logic [9:0] o;
	rega rega(arad, brad, a, b, we, wad, wd, clk, rst);
	alu alu(a, b, op, wd);
	pc pc(h, pca, clk, rst);
	imem imem(pca, o);
	assign {h, wad, op, brad, arad} = o;
	assign we = ~h;
endmodule

