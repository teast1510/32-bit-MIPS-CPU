module DATA_MEMORY(
  input rst_n,clk,
  input [31:0] ADDR,       
  input [31:0] WRITEDATA,   
  input MEMWRITE,          
  input MEMREAD,            
  output [31:0] READDATA   
);
  reg [31:0] WORD [31:0];   
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (i = 0; i < 32; i = i + 1) begin
        WORD[i] = 32'h0;
      end
    end 
    else if (MEMWRITE) begin
      WORD[ADDR[4:0]] = WRITEDATA; 
    end
  end

  assign READDATA = (MEMREAD && !MEMWRITE) ? WORD[ADDR[4:0]] : 32'b0;

endmodule
