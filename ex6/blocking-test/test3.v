module test3(
  input a,
  output b, c,
  input clk);
  logic b, c;
  always @(posedge clk) begin
    c <= b;
    b <= a;
  end
endmodule
