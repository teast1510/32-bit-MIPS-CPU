module CONTROL_UNIT(
  input [5:0] OP,
  output REGDST,REGWRITE,ALUSRC,MEMWRITE,MEMREAD,MEMTOREG,
  output [1:0] ALUCONTROL
);
  assign REGDST = OP[0] | OP[4];
  assign MEMREAD = OP[2];
  assign MEMWRITE = OP[1];
  assign MEMTOREG = OP[2];
  assign ALUSRC = OP[1] | OP[2] | OP[3];
  assign REGWRITE = ~OP[1];
  assign ALUCONTROL[0]  = OP[4];
  assign ALUCONTROL[1] = 1;
endmodule
