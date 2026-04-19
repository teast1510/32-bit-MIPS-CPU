module ALU_32BIT(
  input [31:0] A,B,
  input [1:0] ALUCONTROL,
  output [31:0] RESULT
);
  wire [31:0] sum;
  wire [31:0] sub;
  wire [31:0] slt;
  
  assign sum = A+B;
  assign sub = A-B;
  assign slt = {31'b0, sub[31]};
  
  assign RESULT = (ALUCONTROL[0] == 0) ?  sum : slt;
endmodule
