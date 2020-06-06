module test2(
  input a,
  output b, c,
  input clk);
  logic b, c;
  always @(posedge clk) begin
    b <= a;
    c <= b;
  end
endmodule
