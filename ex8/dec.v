`include "pu.vh"
`define DEBUG
//`define DEBUG2

module dec(input [`CMDS:0] o, output logic h, we, output logic [`RASB:0] wad,
	output logic [`OPS:0] op, output logic [`RASB:0] rb, ra,
	output logic [`LICMDS:0] liop, output logic [`HALFWIDTH:0] iv,
	output logic pcwe, dmwe, dms, pcs, dstb,
	input ze, ca, sg, output logic cwe);
/*
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 0 0 0 * * * * * * * * * 0 ; NOP (0) DSTB
// 0 0 0 0 0 0 * * * * * * * * * 1 ; HALT (1)
// 0 0 0 0 0 1 * * * * * * * * * * ; future reserved (PUSH, POP, SET(reg))
// 0 0 0 0 1 0 rw> F op--> a-> b-> ; CAL rw=ra,rb (F=0:NORM/1:DSTB) MV
// 0 0 0 0 1 1 * * * op--> a-> b-> ; EVA CAL ra,rb (F=0)/CMP ra,rb
// 0 0 0 1 0 0 f f p op--> a-> b-> ; JP/BR fp [ra op rb] (ff:NC,Z,C,S)
// 0 0 0 1 0 1 * * * * * * * * * * ; future reserved
// 0 0 0 1 1 0 F * * op--> a-> b-> ; SM [ra]=rb / SM [ra] = [ra op rb] *MM
// 0 0 0 1 1 1 rw> F op--> a-> b-> ; LM rw=[ra op rb] / LM rw=[rb] *MM
// 0 0 1 # rw> a-> im------------> ; CAL rw=ra,im (#=0:ADD/1:SUB only)
// 0 1 0 p 0 * f f im------------> ; JP/BR fp [(s)im]
// 0 1 0 * 1 0 b-> im------------> ; SM [(s)im]=rb *MM
// 0 1 0 p 1 1 f f im------------> ; JP/BR fp [PC + (s)im]
// 0 1 1 p a-> f f im------------> ; JP/BR fp [ra + (s)im]
// 1 0 0 0 rw> 0 0 0 0 0 0 0 S C Z ; LI rw,SM S:sign C:carry Z:zero
// 1 0 0 0 rw> 0 1 im------------> ; LI rw,(s)im (rw=rb) lidx=o[9:8]
// 1 0 0 0 rw> 1 0 im------------> ; LIL rw,im (rw=rb)
// 1 0 0 0 rw> 1 1 im------------> ; LIH rw,im (rw=rb)
// 1 0 0 1 rw> * * im------------> ; LM rw=[im] *MM
// 1 0 1 0 rw> a-> im------------> ; LM rw=[ra + (s)im]
// 1 0 1 1 a-> b-> im------------> ; SM [ra + (s)im]=rb
// 1 1 0 * * * * * * * * * * * * * ; C++
*/

	`LIDXENUM
	enum {UC, ZE, CA, SG} FLAGTYP;
	logic f1, f2;
	always @* begin
		f1 = `NEGATE;
		f2 = `NEGATE;
		case(o[9:8])
		// synopsys full_case parallel_case
		UC: begin
			f1 = `ASSERT;
			f2 = `ASSERT;
		end
		ZE: begin
			f1 = ~ze^o[7];
			f2 = ~ze^o[12];
		end
		CA: begin
			f1 = ~ca^o[7];
			f2 = ~ca^o[12];
		end
		SG: begin
			f1 = ~sg^o[7];
			f2 = ~sg^o[12];
		end
		endcase
	end
	always @* begin
		h = `NEGATE;
		ra = 0;
		rb = 0;
		op = `THB;
		we = `NEGATE;
		wad = 0;
		liop = THU;
		iv = 0;
		dstb = `NEGATE;
		pcwe = `NEGATE;
		dmwe = `NEGATE;
		dms = `NEGATE;
		pcs = `NEGATE;
		cwe = `NEGATE;
`ifdef DEBUG
$display("*****PC[%h]we[%h]CODE:%h", test.pu.pc.pc, pcwe, o);
$display("r0[%h]1[%h]2[%h]3[%h]", test.pu.rega.regar[0], test.pu.rega.regar[1],
`endif
	test.pu.rega.regar[2], test.pu.rega.regar[3]);
		case(o[15:13])
		// synopsys full_case parallel_case
		3'b000: begin
			case(o[12:10])
			// synopsys full_case parallel_case
			3'b000: begin
				if(o[0] == `NEGATE) begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 0 0 0 * * * * * * * * * 0 ; NOP (0) DSTB
				end else begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 0 0 0 * * * * * * * * * 1 ; HALT (1)
					h = `ASSERT;
				end
			end
			3'b010: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 0 1 0 rw> F op--> a-> b-> ; CAL rw=ra,rb (F=0:NORM/1:DSTB) MV
				wad = o[9:8];
				op = o[6:4];
				ra = o[3:2];
				rb = o[1:0];
				we = `ASSERT;
			end
			3'b011: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 0 1 1 * * * op--> a-> b-> ; EVA CAL ra,rb (F=0)/CMP ra,rb
				op = o[6:4];
				ra = o[3:2];
				rb = o[1:0];
			end
			3'b100: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 1 0 0 f f p op--> a-> b-> ; JP/BR fp [ra op rb] (ff:NC,Z,C,S)
				op = o[6:4];
				ra = o[3:2];
				rb = o[1:0];
				if(f1 == `ASSERT) begin
					pcwe = `ASSERT;
				end else begin
				end
 			end
			3'b110: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 1 1 0 F * * op--> a-> b-> ; SM [ra]=rb / SM [ra] = [ra op rb] *MM
				op = o[6:4];
				ra = o[3:2];
				rb = o[1:0];
				dmwe = `ASSERT;
			end
			3'b111: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 1 1 1 rw> F op--> a-> b-> ; LM rw=[ra op rb] / LM rw=[rb] *MM
				wad = o[9:8];
				op = o[6:4];
				ra = o[3:2];
				rb = o[1:0];
				we = `ASSERT;
				dms = `ASSERT;
			end
			endcase
		end
		3'b001: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 1 # rw> a-> im------------> ; CAL rw=ra,im (#=0:ADD/1:SUB only)
			wad = o[11:10];
			ra = o[9:8];
			iv = o[7:0];
			we = `ASSERT;
			liop = 3'b001;
			op = {2'b00, o[12]};
		end
		3'b010: begin
			if(o[11] == `NEGATE) begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 1 0 p 0 * f f im------------> ; JP/BR fp [(s)im]
				iv = o[7:0];
				liop = IMM;
				if(f2 == `ASSERT) begin
					pcwe = `ASSERT;
				end
			end else begin
				if(o[10] == `NEGATE) begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 1 0 * 1 0 b-> im------------> ; SM [(s)im]=rb *MM
					rb = o[9:8];
					iv = o[7:0];
					liop = 3'b001;
					dmwe = `ASSERT;
				end else begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0					
// 0 1 0 p 1 1 f f im------------> ; JP/BR fp [PC + (s)im]
					iv = o[7:0];
					pcs = `ASSERT;
					op = 3'b000;
					liop = 3'b001;
					if(f2 == `ASSERT) begin
						pcwe = `ASSERT;
					end
				end
			end
		end
		3'b011: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 1 1 p a-> f f im------------> ; JP/BR fp [ra + (s)im]
			ra = o[11:10];
			iv = o[7:0];
			op = 3'b000;
			liop = 3'b001;
			if(f2 == `ASSERT) begin
				pcwe = `ASSERT;
			end
		end
		3'b100: begin
			if(o[12] == `NEGATE) begin
				case(o[9:8])
				// synopsys full_case parallel_case
				2'b00: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 1 0 0 0 rw> 0 0 0 0 0 0 0 S C Z ; LI rw,SM S:sign C:carry Z:zero

				end
				2'b01: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 1 0 0 0 rw> 0 1 im------------> ; LI rw,(s)im (rw=rb) lidx=o[9:8]
					wad = o[11:10];
					wad = o[11:10];
					rb = o[11:10];
					iv = o[7:0];
					we = `ASSERT;
					liop = 3'b001;
				end
				2'b10: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 1 0 0 0 rw> 1 0 im------------> ; LIL rw,im (rw=rb)
					wad = o[11:10];
					rb = o[11:10];
					iv = o[7:0];
					we = `ASSERT;
					liop = 3'b010;			
				end
				2'b11: begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 1 0 0 0 rw> 1 1 im------------> ; LIH rw,im (rw=rb)
					wad = o[11:10];
					rb = o[11:10];
					iv = o[7:0];
					we = `ASSERT;
					liop = 3'b011;			
				end
				endcase
			end else begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 1 0 0 1 rw> * * im------------> ; LM rw=[im] *MM
				wad = o[11:10];
				iv = o[7:0];
				we = `ASSERT;
				liop = 3'b001;
				dms = `ASSERT;
			end
		end
		3'b101: begin
			if(o[12] == `NEGATE) begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 1 0 1 0 rw> a-> im------------> ; LM rw=[ra + (s)im]
				wad = o[11:10];
				ra = o[9:8];
				iv = o[7:0];
				liop = 3'b001;
				op = 3'b000;
				we = `ASSERT;
				dms = `ASSERT;
			end else begin
// F E D C B A 9 8 7 6 5 4 3 2 1 0				
// 1 0 1 1 a-> b-> im------------> ; SM [ra + (s)im]=rb
				ra = o[11:10];
				rb = o[9:8];
				iv = o[7:0];
				dmwe = `ASSERT;
				liop = 3'b001;
				op = 3'b000;
			end
		end
		3'b110: begin
			// 1 1 0 * * * * * * * * * * * * * ;
			cwe = `ASSERT;
			op = 3'b001;
			liop = 3'b001;
			iv = 15;
		end
//
// HERE, WRITE YOUR OWN CODE!!!
//
		endcase
`ifdef DEBUG2
$display("----DEBUG----(%f)", $realtime);
$display("PC[%h]we[%h]CODE:%h", test.pu.pc.pc, pcwe, o);
$display("REGA a[%h], b[%h], w[%h](%h)", ra, rb, wad, we);
$display("ALU op[%h], dstb[%h], status Z[%h] C[%h] S[%h]", op, dstb, ze, ca, sg);
$display("SEL LIDX[%h] IM[%h] PCS[%h]", liop, iv, pcs);
$display("DMEM we[%h] sel[%h]", dmwe, dms);
$display("r0[%h]1[%h]2[%h]3[%h]", test.pu.rega.regar[0], test.pu.rega.regar[1],
	test.pu.rega.regar[2], test.pu.rega.regar[3]);
$display("-------------");
`endif
	end
endmodule
