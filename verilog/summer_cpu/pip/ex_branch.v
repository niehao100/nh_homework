`timescale 1ns/1ps
module ex_branch(databusA,databusB,BranchType,compareAB);

input  [2:0] BranchType;//BranchType
input  [31:0] databusA,databusB;
output reg compareAB;

//from the single cpu by Neil
always @ (*) begin
  case(BranchType)
    3'b001: compareAB = (databusA == databusB) ? 1'b1:1'b0;
	3'b010: compareAB = (databusA < databusB)  ? 1'b1:1'b0;
    3'b100: compareAB = (databusA > 0 || databusA == 0) ? 1'b1:1'b0;
	3'b101: compareAB = (databusA != databusB) ? 1'b1:1'b0;
    3'b110: compareAB = (databusA[31] == 1 || databusA == 0) ? 1'b1:1'b0;
    3'b111: compareAB = (databusA > 0)  ? 1'b1:1'b0;
    default: compareAB = 1'b0 ;
  endcase
end

endmodule



