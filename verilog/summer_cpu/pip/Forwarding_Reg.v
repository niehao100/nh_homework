`timescale 1ns/1ps
module Forwarding_Reg(ID_rs, ID_rt, EX_rd,
					  EX_RegWrite, 
					  MEM_rd, MEM_RegWrite, MEM_MemToReg,
					  MEM2WB_rd, MEM2WB_RegWrite, 
					  ForwardA, ForwardB
					  );
					  
input	EX_RegWrite, MEM_RegWrite, MEM2WB_RegWrite;
input   [1:0]  MEM_MemToReg;
input   [4:0]  ID_rs, ID_rt, EX_rd, MEM_rd, MEM2WB_rd;

output reg   [2:0]  ForwardA, ForwardB;
  
always @(*) begin
  //DatabusA
	if(EX_RegWrite && (EX_rd != 5'd0) && (EX_rd == ID_rt)) begin
		ForwardB = 3'b001;
	end
	else 
		if(MEM_RegWrite && (MEM_rd != 5'd0) && (MEM_rd == ID_rt)) begin
			if(MEM_MemToReg == 2'b01) begin
				ForwardB = 3'b011;
			end
			else begin
				ForwardB = 3'b010;
			end
		end
		else begin
			if(ID_rt == MEM2WB_rd && MEM2WB_RegWrite) begin
				ForwardB = 3'b100;
			end
			else begin
				ForwardB = 3'b000;
			end
		end

  //DatabusB //the same as databusA
  if(EX_RegWrite && (EX_rd == ID_rs) && (EX_rd != 5'd0)) begin
		ForwardA = 3'b001;
	end
	else 
		if(MEM_RegWrite && (MEM_rd != 5'd0) && (MEM_rd == ID_rs)) begin
			if(MEM_MemToReg == 2'b01) begin
				ForwardA = 3'b011;
			end
			else begin
				ForwardA = 3'b010;
			end
		end
		else begin
		  if(ID_rs == MEM2WB_rd && MEM2WB_RegWrite) begin
			  ForwardA = 3'b100;
		  end
		  else begin
			  ForwardA = 3'b000;
		  end
		end

end
endmodule
