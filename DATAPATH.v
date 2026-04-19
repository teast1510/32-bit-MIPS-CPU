module DATAPATH(
  input rst_n, clk,
  input REGDST, REGWRITE,ALUSRC, MEMWRITE,MEMREAD,MEMTOREG,
  input [1:0] ALUCONTROL,
  output [5:0] OP,
  output [31:0] READDATA
);
  //PC + ISTR_MEM;
  wire [31:0] LOAD, COUNT;
  wire [31:0] INSTR;
  //MUX21BIT + SIGN_EXTEND +REG_FILE
  wire [31:0] SIGN_EXTENDED;
  wire [4:0] WR;
  wire [31:0] WD;
  wire [31:0] RD1,RD2;
  wire [31:0] S;
  wire [31:0] RESULT;
  
  PC            dut0 (.rst_n(rst_n), .clk(clk), .S(LOAD), .Y(COUNT));
  ADD4          dut1 (.S(COUNT), .Y(LOAD));
  ISTR_MEM      dut2 (.ADDR(COUNT), .INSTR(INSTR));
  SIGN_EXTEND   dut3 (.INSTR(INSTR[15:0]), .SIGN_EXTENDED(SIGN_EXTENDED));
  MUX_21_5BIT   dut4 (.S0(INSTR[20:16]), .S1(INSTR[15:11]), .C(REGDST), .Y(WR));
  REG_FILE      dut5 (.rst_n(rst_n), .clk(clk), .RR1(INSTR[25:21]), .RR2(INSTR[20:16]), .WR(WR), .WD(WD), .RD1(RD1), .RD2(RD2), .REGWRITE(REGWRITE));
  MUX_21_32BIT  dut6 (.S0(RD2), .S1(SIGN_EXTENDED), .Y(S), .C(ALUSRC));
  ALU_32BIT     dut7 (.A(RD1), .B(S), .RESULT(RESULT), .ALUCONTROL(ALUCONTROL));
  DATA_MEMORY dut8 (.rst_n(rst_n), .clk(clk), .ADDR(RESULT), .WRITEDATA(RD2), .MEMWRITE(MEMWRITE), .MEMREAD(MEMREAD), .READDATA(READDATA));
  MUX_21_32BIT dut9 (.S1(READDATA), .S0(RESULT), .Y(WD), .C(MEMTOREG));
  
  assign OP = INSTR[31:26];
endmodule
