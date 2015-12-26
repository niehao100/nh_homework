//By Neil 2015/8/21
module ALUshift(A,B,ALUFun,shift);
input [4:0]A;
input [31:0]B;
input [1:0]ALUFun;
output [31:0]shift;
wire [31:0] l1,l2,l4,l8,l16,r1,r2,r4,r8,r16;
assign l1   =   (A[0])?{B [30:0],1'b0 }:B ;
assign l2   =   (A[1])?{l1[29:0],2'b0 }:l1;
assign l4   =   (A[2])?{l2[27:0],4'b0 }:l2;
assign l8   =   (A[3])?{l4[23:0],8'b0 }:l4;
assign l16  =   (A[4])?{l8[15:0],16'b0}:l8;

assign r1   =   (A[0])?{((ALUFun[1]==1'b1)&&(B[31]==1))?1'b1 :1'b0 ,B [31:1] }:B ;
assign r2   =   (A[1])?{((ALUFun[1]==1'b1)&&(B[31]==1))?2'b1 :2'b0 ,r1[31:2] }:r1;
assign r4   =   (A[2])?{((ALUFun[1]==1'b1)&&(B[31]==1))?4'b1 :4'b0 ,r2[31:4] }:r2;
assign r8   =   (A[3])?{((ALUFun[1]==1'b1)&&(B[31]==1))?8'b1 :8'b0 ,r4[31:8] }:r4;
assign r16  =   (A[4])?{((ALUFun[1]==1'b1)&&(B[31]==1))?16'b1:16'b0,r8[31:16]}:r8;

assign shift = (ALUFun[0])?r16:l16;

endmodule
