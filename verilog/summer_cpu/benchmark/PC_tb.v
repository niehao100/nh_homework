//by Pray Wolf 2015/9/2
module CPU_PCtb;
  reg ALUOut0,clk,reset;
  reg[2:0] PCSrc;
	reg[25:0] JT;
	reg[31:0] DatabusA,ConBA;
	wire[31:0] PC;
	PC update(clk,reset,ALUOut0,ConBA,DatabusA,JT,PCSrc,PC);
	always #5 clk=~clk;
	initial begin
	  clk=1;
	  reset=1;
	  ALUOut0=1;
	  ConBA=32'b1000_0000_0000_0000_0000_0000_1000_0000;
	  DatabusA=32'b1000_0000_0000_0000_0000_0100_0000_0000;
	  JT=26'b00_0000_0000_0000_0000_0010_0000;
	  PCSrc=3'b000;
	  #10 PCSrc=3'b001;
	  #10 ALUOut0=0;
	  #10 PCSrc=3'b010;
	  #10 PCSrc=3'b011;
	  #10 PCSrc=3'b100;
	  #10 PCSrc=3'b101;
	  end
	endmodule
