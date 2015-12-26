
module IF2ID(rst, clk,
			 flush, writeEn,
			 PCIn, instructionIn,
			 PCOut, instructionOut
			 );
			 
input	writeEn, flush, rst, clk;
input	[31:0]	PCIn;
input	[31:0]	instructionIn;

output	reg	[31:0]	PCOut;
output	reg	[31:0]	instructionOut;

parameter init= 32'h0000_0000;

always @(negedge rst or posedge clk) begin
	if(!rst) begin
		PCOut<=init;
		instructionOut<=init;
	end
	else if (flush) begin
			PCOut<=init;
			instructionOut<=init;
		 end
		 else begin
				if(writeEn) begin
					PCOut<=PCIn;
					instructionOut<=instructionIn;
				end
				else begin
					PCOut<=PCOut;
					instructionOut<=instructionOut;
				end
		 end
end

endmodule