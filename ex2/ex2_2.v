module ex2_2(input [3:0] a,b, output out);
    logic out;
    always_comb begin
        if(a>=b) out =1;
        else out =0;
    end
endmodule

module test;
    logic [3:0] a,b;
    logic out;
    ex2_2 ab(a,b,out);
    initial begin
        $dumpfile("ex2_2.vcd");
        $dumpvars(0, test);
        a = 5;
        b = 3;
        #10
        a = 3;
        b = 8;
        #10
        a = 1;
        b = 0;
        #10
        $finish;
    end
endmodule
