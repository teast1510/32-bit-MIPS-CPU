module MUX_21_32BIT(
  input [31:0] S0,S1,
  input C,
  output [31:0] Y
);
assign Y = C ? S1 : S0;
endmodule
