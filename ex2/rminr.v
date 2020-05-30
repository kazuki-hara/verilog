module rminr(input [3:0] a, b, output [3:0] s, output co);
    logic [3:0] c;
    assign c[0] = 0;
    logic [3:0] d;
    assign d = ~b;
    logic [3:0] e;
    assign e[3] = 0;
    assign e[2] = 0;
    assign e[1] = 0;
    assign e[0] = 1;
    logic [3:0] f;
    raddr ra(d, e, f, co1);
    raddr rb(a, f, s, co);
endmodule

