module cpu_IFID(clk,PCSrc,ALUOut,JT,ConBA,DatabusA,reset,PCWrite,IFIDWrite,Stall,IFID);
input clk,reset,PCWrite,ALUOut,IFIDWrite,Stall;
input[2:0] PCSrc;
input[25:0] JT;
input[31:0] DatabusA,ConBA;
output[63:0] IFID;
wire[31:0] PC,Instruct;
PC pipepc(clk,reset,ALUOut,ConBA,DatabusA,JT,PCSrc,PC,PCWrite);
ROM piperom(PC,Instruct,enable);
IFID pipeIFID(clk,reset,PC,Instruct,Stall,IFIDWrite,IFID);
endmodule