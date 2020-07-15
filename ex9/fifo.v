module fifo(input [`PKTW:0] in, input we, output logic full,
	output [`PKTW:0] out, input re, output logic empty, input clk, rst);
	logic [3:0] head, tail, headi;
	logic [9:0] mem [15:0];
	fsel fsel(mem[tail], empty, out);
	assign headi = head+1;
	always @(posedge clk) begin
		if(rst) begin
			head <= 0;
			tail <= 0;
		end else begin
			if(we) begin
				mem[head] <= in;
				head <= headi;
			end else begin
			end
			if(re) begin
				if(head != tail) tail <= tail + 1;
			end else begin
			end
		end
	end
	always@* begin
		if(head == tail) empty = 1'b1;
		else empty = 1'b0;
		if(headi == tail) full = 1'b1;
		else full = 1'b0;
	end
endmodule

module fsel(input [`PKTW:0] in, input empty, output logic [`PKTW:0] out);
	always@*
		if(empty) out = 0;
		else out = in;
endmodule



/*
module fifotest;
	logic [9:0] in, out;
	logic we, re, clk, rst;
	always #5 clk = ~clk;
	fifo fifo(in, we, full, out, re, empty, clk, rst);
	initial begin
	$dumpfile("fifo.vcd");
	$dumpvars(0, fifotest);
	rst = 1'b1;
	clk = 1'b1;
	re = 1'b0;
	we = 1'b0;
	#20
	rst = 1'b0;
	#20
	we = 1'b1;
	in = 10;
	#10
	in = 20;
	#10
	in = 30;
	#10
	in = 40;
	#10
	in = 50;
	#10
	in = 60;
	#10
	in = 70;
	#10
	we = 1'b0;
	#30
	re = 1'b1;
	#100
	$finish;
	end
endmodule
*/