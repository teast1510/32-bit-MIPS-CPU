module REG_FILE(
  input wire clk, rst_n,
  input wire [4:0] RR1,RR2,WR,
  input wire [31:0] WD,
  input wire REGWRITE,
  output reg [31:0] RD1, RD2,
  reg [31:0] ram [31:0]
);
  
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      for (i = 0; i < 32; i = i + 1) begin
        ram[i] <= 32'h0;
      end
    end
    else begin
      if(REGWRITE) begin
        ram[WR] <= WD;
      end
    end
  end
  
  always @(*) begin
    RD1= ram[RR1];
    RD2= ram[RR2];
  end
endmodule

  
