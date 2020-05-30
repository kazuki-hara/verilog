module test;
    logic [3:0] a, b, s;
    rminr rm(a, b, s, co);
    initial begin
        $dumpfile("raddr.vcd");
        $dumpvars(0, test);
        
        a = 5;
        b = 3;
        #10
        a = 11;
        b = 8;
        #10
        a = 1;
        b = 0;
        #10
        $finish;
    end
endmodule

