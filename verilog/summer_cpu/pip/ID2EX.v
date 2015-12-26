`timescale 1ns/1ps
module EX(rst, clk, flush,
			 RegDstIn, ALUFunIn, ALUSrc1In, ALUSrc2In, SignIn, MemRdIn, MemWrIn, RegWrIn, MemToRegIn, 
			 EX_rsContentIn, EX_rtContentIin, EX_rtIn, EX_rdIn, imm32_in, 
			 RegDstOut, ALUFunOut, ALUSrc1Out, ALUSrc2Out, SignOut, MemRdOut, MemWrOut, RegWrOut, MemToRegOut,
			 EX_rsContentOut, EX_rtContentOut, EX_rtOut, EX_rdOut, imm32_out,
			 PCAdd4in,PCAdd4out
			 );


input	flush, rst, clk;
input	ALUSrc1In, ALUSrc2In, SignIn, MemRdIn, MemWrIn, RegWrIn;
input	[1:0]	MemToRegIn,RegDstIn;
input	[4:0]	 EX_rtIn, EX_rdIn;
input	[5:0]	ALUFunIn;
input	[31:0]	EX_rsContentIn,EX_rtContentIin;
input	[31:0]	imm32_in,PCAdd4in;

output	reg	 ALUSrc1Out, ALUSrc2Out, SignOut, MemRdOut, MemWrOut, RegWrOut;
output	reg	[1:0]	MemToRegOut,RegDstOut;
output	reg	[4:0]	 EX_rtOut, EX_rdOut;
output	reg	[5:0]	ALUFunOut;
output	reg	[31:0]	imm32_out;
output	reg	[31:0]	EX_rsContentOut,EX_rtContentOut,PCAdd4out;
//the flush and enable is important
always @(negedge rst or posedge clk) begin
  if(~rst) begin
  RegWrOut<=1'b0;
    SignOut<=1'b0;
    MemRdOut<=1'b0;
    MemWrOut<=1'b0;
    ALUSrc2Out<=1'b0;
    ALUSrc1Out<=1'b0;
    RegDstOut<=2'b0;
    MemToRegOut<=2'b00;
    EX_rdOut<=5'b00000;
    EX_rtOut<=5'b00000;
    ALUFunOut<=6'b000000;
    imm32_out<=32'h00000000;
    PCAdd4out<=32'h00000000;
    EX_rtContentOut<=32'h00000000;
    EX_rsContentOut<=32'h00000000;

  end
  else if (flush) begin
			MemToRegOut<=2'b00;
			RegDstOut<=2'b0;
			ALUSrc1Out<=1'b0;
			EX_rtOut<=5'b00000;
			EX_rdOut<=5'b00000;
			SignOut<=1'b0;
			ALUSrc2Out<=1'b0;
			PCAdd4out<=32'h00000000;
			MemRdOut<=1'b0;
			MemWrOut<=1'b0;
			imm32_out<=32'h00000000;
			ALUFunOut<=6'b000000;
			RegWrOut<=1'b0;
			EX_rsContentOut<=32'h00000000;
			EX_rtContentOut<=32'h00000000;
		end
     else begin
	        MemRdOut<=MemRdIn;
			MemWrOut<=MemWrIn;
			EX_rtOut<=EX_rtIn;
			EX_rdOut<=EX_rdIn;
			EX_rsContentOut<=EX_rsContentIn;
			EX_rtContentOut<=EX_rtContentIin;
			MemToRegOut<=MemToRegIn;
			PCAdd4out<=PCAdd4in;
			imm32_out<=imm32_in;
			ALUFunOut<=ALUFunIn;
			RegDstOut<=RegDstIn;
			ALUSrc1Out<=ALUSrc1In;
			ALUSrc2Out<=ALUSrc2In;
			SignOut<=SignIn;
			RegWrOut<=RegWrIn;
     end
end

endmodule

