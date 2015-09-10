//`timescale 1ns/1ps

module RegFile (reset,clk,addr1,data1,addr2,data2,wr,addr3,data3);
input reset,clk;
input wr;
input [4:0] addr1,addr2,addr3;
output [31:0] data1,data2;
input [31:0] data3;

reg [31:0] RF_DATA[31:1];
integer i;
initial begin
    for(i=1;i<32;i=i+1) RF_DATA[i]<=32'b0;
    RF_DATA[29]<={21'b0,1'b1,8'b0,2'b00};
end
assign data1=(addr1==5'b0)?32'b0:RF_DATA[addr1];	//$0 MUST be all zeros
assign data2=(addr2==5'b0)?32'b0:RF_DATA[addr2];

always@(negedge reset or posedge clk) begin
	if(~reset) begin
		for(i=1;i<32;i=i+1) RF_DATA[i]<=32'b0;
	end
	else begin
		if(wr && addr3) RF_DATA[addr3] <= data3;
	end
end
endmodule
