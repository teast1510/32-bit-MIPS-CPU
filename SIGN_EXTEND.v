module SIGN_EXTEND(
  input [15:0] INSTR,
  output [31:0] SIGN_EXTENDED
);
  assign SIGN_EXTENDED = {{16{INSTR[15]}},INSTR};
endmodule
