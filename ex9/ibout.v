module ibout(input [`PKTW:0] in, output logic [`PKTW:0] out, input re);
    always@* begin
        if(re) out = in;
        else out = 0;
    end
endmodule