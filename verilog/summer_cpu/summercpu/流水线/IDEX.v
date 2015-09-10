module IDEX(clk,reset,Rs,Rt,ID2EX,Stall,LUout,ALUSrc2,ConBA,PCSrc,ALUFun,Sign,MemWr,MemRd,RegWr,MemToReg,AddrC,ALUA,DataBusB);
	input clk,reset,Stall,ALUSrc2,Sign,MemWr,MemRd,RegWr,MemToReg;
	input[2:0] PCSrc;
	input[4:0] Rs,Rt,AddrC;
	input[5:0] ALUFun;
	input[31:0] LUout,ConBA,ALUA,DataBusB;
	output reg[157:0] ID2EX;
	always @(posedge clk or negedge reset)
		begin
			if((!reset)||Stall)
				ID2EX<=158'b0;
			else
				ID2EX<={Rs,Rt,LUout,ALUSrc2,ConBA,PCSrc,ALUFun,Sign,MemWr,MemRd,RegWr,MemToReg,AddrC,ALUA,DataBusB};
		end
endmodule