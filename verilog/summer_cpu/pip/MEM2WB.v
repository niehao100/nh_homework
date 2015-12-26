
`timescale 1ns/1ps
module MEM2WB(rst, clk,
			  RegWrIn, MemToRegIn, ALUoutin, MEMDatain, WB_rdIn, 
			  RegWrOut, MemToRegOut, ALUoutOut, MEMDataOut, WB_rdOut,
			  PCAdd4In, PCAdd4Out
			  );
			  
input	RegWrIn,rst, clk;		  
input	[1:0]	MemToRegIn; 
input	[4:0]	WB_rdIn;
input	[31:0]	ALUoutin,MEMDatain,PCAdd4In; 
     
output	reg	 RegWrOut;
output	reg	[1:0]	MemToRegOut;
output	reg	[4:0]	WB_rdOut;
output	reg	[31:0]	ALUoutOut,MEMDataOut,PCAdd4Out;


always @(posedge clk or negedge rst) begin
	if(~rst) begin
		WB_rdOut<=5'b00000;
		ALUoutOut<=32'h00000000;
		MEMDataOut<=32'h00000000;
		PCAdd4Out<=32'h00000000;
		MemToRegOut<=2'b00;
		RegWrOut<=1'b0;
	end
	else begin
		WB_rdOut<=WB_rdIn;
		MemToRegOut<=MemToRegIn;
		RegWrOut<=RegWrIn;
		ALUoutOut<=ALUoutin;
		MEMDataOut<=MEMDatain;
		PCAdd4Out<=PCAdd4In;
	end
end

endmodule




