module Hazard(ID_rs, ID_rt, 
			  ID_Flush, ID_Write,
			  EX_MemRead, EX_rt, EX_Flush,
			  BranchType, J, jHazard, IFWrite
			  );
			  

input	EX_MemRead;
input	J, jHazard;

input [4:0] ID_rs, ID_rt, EX_rt;
input [2:0] BranchType;

output	reg	IFWrite, ID_Write,ID_Flush,EX_Flush;

always @(*) begin
	if(EX_MemRead && ((EX_rt == ID_rs && ID_rs != 5'd0) || (EX_rt == ID_rt && ID_rt != 5'd0 ))) begin
		EX_Flush = 1'b1;//flush,generate a bubble
		ID_Flush = 1'b0;//hold
		IFWrite = 1'b0;//hold
		ID_Write = 1'b0;//hold
	end
	else begin
		if(J || ((BranchType[0] || BranchType[1] || BranchType[2]) && jHazard)) begin
			EX_Flush = 1'b0;
			ID_Flush = 1'b1;
			IFWrite = 1'b1;
			ID_Write = 1'b0;
		end
		else begin
			IFWrite = 1'b1;
			ID_Write = 1'b1;
			EX_Flush = 1'b0;
			ID_Flush = 1'b0;
		end	
	end
end
endmodule

