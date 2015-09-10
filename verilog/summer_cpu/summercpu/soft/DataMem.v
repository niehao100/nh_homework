//`timescale 1ns/1ps

module DataMem (reset,clk,rd,wr,addr,wdata,rdata);
input reset,clk;
input rd,wr;
input [31:0] addr;	//Address Must be Word Aligned
output [31:0] rdata;
input [31:0] wdata;

parameter RAM_SIZE = 256;
reg [31:0] RAMDATA [RAM_SIZE-1:0];

assign rdata=(rd &&(addr[31:28]!=4'h4)/*&&(addr < RAM_SIZE)*/)?RAMDATA[addr[9:2]]:32'b0;

always@(posedge clk) begin
	if(wr &&(addr[31:28]!=4'h4)/*&& (addr < RAM_SIZE)*/) RAMDATA[addr[9:2]]<=wdata;
end

/*always@(posedge clk)begin
    if()
end*/
endmodule
