module ISTR_MEM(
  input [7:0] ADDR,
  output reg [31:0] INSTR
);
  
  reg [31:0] rom [31:0];
  initial begin 
    $readmemb("binary.txt", rom);
  end
  always @(ADDR) begin
    INSTR <= rom[ADDR[5:2]];
  end
endmodule

  
