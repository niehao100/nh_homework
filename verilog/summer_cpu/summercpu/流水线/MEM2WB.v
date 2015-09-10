module MEM2WB(clk,reset,data,EX2MEM,MEM2WB);
input clk,reset;
input [31:0]data;
input [72:0]EX2MEM;
output reg [31:0] dataout;
output reg [70:0] MEM2WB;

always @(posedge clk,negedge reset) begin 
if(~reset) begin
MEM2WB<=71'b0;
end
else
MEM2WB<={EX2MEM[70:64],data,EXMEM[31:0]};
end
endmodule

