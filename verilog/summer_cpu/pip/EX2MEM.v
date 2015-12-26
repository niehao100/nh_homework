module EX2MEM(rst, clk, 
			  MemRdIn, MemWrIn, RegWrIn, RegIn, ALUoutIn, MEM_BIn, MEM_rdIn,
			  MemRdOut, MemWrOut, RegWrOut, RegOut, ALUoutOut, MEM_BOut, MEM_rdOut, 
			  PCAdd4in, PCAdd4out
			  );
            
input	rst, clk;    
input	MemRdIn, MemWrIn, RegWrIn;

input	[1:0]	RegIn;
input	[4:0]	MEM_rdIn;
input	[31:0]	ALUoutIn,MEM_BIn,PCAdd4in;

output  reg	 MemRdOut, MemWrOut, RegWrOut;
output	reg	[1:0] RegOut;
output	reg	[4:0] MEM_rdOut;
output	reg	[31:0] ALUoutOut,MEM_BOut,PCAdd4out;

always @(posedge clk or negedge rst) begin
	if(~rst) begin
		MemRdOut <= 1'b0;
		RegWrOut <= 1'b0;
		MemWrOut <= 1'b0;
		RegOut <= 2'b00;
		MEM_rdOut <= 5'b00000;
		PCAdd4out <= 32'h00000000;
		ALUoutOut <= 32'h00000000;
		MEM_BOut <= 32'h00000000;
	end
	else begin
		MemRdOut <= MemRdIn;
		MemWrOut <= MemWrIn;
		PCAdd4out <= PCAdd4in;
		MEM_rdOut <= MEM_rdIn;
		RegOut <= RegIn;
		MEM_BOut <= MEM_BIn;
		ALUoutOut <= ALUoutIn;
		RegWrOut <= RegWrIn;
	end
end

endmodule
