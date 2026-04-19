module PC(
  input clk, rst_n,
  input [7:0] S,
  output reg [7:0] Y
);
  always @ (posedge clk or negedge rst_n) begin
    if(!rst_n)
      Y <=0;
    else Y <= S;
  end
endmodule
