`include "pu.vh"
module imem(input [`PCS:0] pc, output logic [`CMDS:0] o);
	always@*
		case(pc)
		// synopsys full_case parallel_case
		5'd00: o = 16'b0000_0000_0000_0000; // NOP check
		5'd01: o = 16'b1000_0001_0000_0011; // P(0) = 3
		5'd02: o = 16'b0100_1000_0000_0000; // SM[0] = P(0)
		5'd03: o = 16'b1100_1000_0000_0000; // c++ SM[16] = SM[0]+SM[16]
		5'd04: o = 16'b1000_0101_0000_0000; // P(1) = 0
		5'd05: o = 16'b0100_1001_0000_0000; // SM[1] = P(1)
		5'd06: o = 16'b1100_1000_0000_0000; // c++ SM[16] = SM[1]+SM[16]
		5'd07: o = 16'b1000_1001_0000_0010; // P(2) = 2
		5'd08: o = 16'b0100_1010_0000_0000; // SM[2] = P(2)
		5'd09: o = 16'b1100_1000_0000_0000; // c++ SM[16] = SM[2]+SM[16]
// loop
		5'd10: o = 16'b0000_1011_0000_0001; // P(c) = P(c-2) + P(c-3)
		5'd11: o = 16'b0100_1011_0000_0000; // SM[c] = P(c)
		5'd12: o = 16'b0000_1000_0010_0001; // rega[0] = raga[1]
		5'd13: o = 16'b0000_1001_0010_0010; // rega[1] = raga[2]
		5'd14: o = 16'b0000_1010_0010_0011; // rega[2] = raga[3]
		5'd15: o = 16'b1100_1000_0000_0000; // c++ SM[16] = SM[c]+SM[16]
		5'd16: o = 16'b0100_0011_0000_1010; // JP/BR SG [10]
// finish
		5'd17: o = 16'b0000_0000_0000_0001; // HALT
		5'd18: o = 16'b0000_0000_0000_0000; // NOP
		endcase
endmodule

/*
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 0 0 0 * * * * * * * * * 0 ; NOP (0) DSTB
// 0 0 0 0 0 0 * * * * * * * * * 1 ; HALT (1)
// 0 0 0 0 0 1 * * * * * * * * * * ; future reserved (PUSH, POP, SET(reg))
// 0 0 0 0 1 0 rw> F op--> a-> b-> ; CAL rw=ra,rb (F=0:NORM/1:DSTB) MV
// 0 0 0 0 1 1 * * * op--> a-> b-> ; EVA CAL ra,rb (F=0)/CMP ra,rb
// 0 0 0 1 0 0 f f p op--> a-> b-> ; JP/BR pf [ra op rb] (ff:NC,Z,C,S)
// 0 0 0 1 0 1 * * * * * * * * * * ; future reserved
// 0 0 0 1 1 0 F * * op--> a-> b-> ; SM [ra]=rb / SM [ra] = [ra op rb] *MM
// 0 0 0 1 1 1 rw> F op--> a-> b-> ; LM rw=[ra op rb] / LM rw=[rb] *MM
// 0 0 1 # rw> a-> im------------> ; CAL rw=ra,im (#=0:ADD/1:SUB only)
// 0 1 0 p 0 * f f im------------> ; JP/BR pf [(s)im]
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
// 1 1 0 * * * * * * * * * * * * * ; future reserved *MM
// 1 1 1 * * * * * * * * * * * * * ; future reserved *MM (debug)
//
// ALU  000:ADD, 001:SUB, 010:THB, 011:ASR,
//      100:RSL, 101:RSL, 110:NAD, 111:XOR
//
// COND(ff) 00:UC 01:ZE 10:CA 11:SG
// P/N (p)  0:N(!=) 1:P(==)
//
// EX: Positive Zero => PZ
//
// SPECIALS
// F E D C B A 9 8 7 6 5 4 3 2 1 0
// 0 0 0 0 1 0 rw> 0 0 1 0 0 0 b-> ; MV rw=rb
// 1 0 0 0 rw> 0 1 0 0 0 0 0 0 0 0 ; RESET rw (LI rw=0)
// 0 0 1 0 rw> rw> 0 0 0 0 0 0 0 1 ; INC rw
// 0 0 1 1 rw> rw> 0 0 0 0 0 0 0 1 ; DEC rw
// 0 0 1 0 rw> ra> 0 0 0 0 0 0 0 1 ; INC rw=ra (rw = ra+1)
// 0 0 1 1 rw> ra> 0 0 0 0 0 0 0 1 ; DEC rw=ra (rw = ra-1)
// 0 0 0 0 1 1 * * * 0 0 1 a-> b-> ; CMP ra,rb (EVA SUB ra,rb)
*/
