`timescale 1ns/1ps
module test();
reg [5:0] OpCode;
reg [5:0] Funct;
reg irq;
wire [2:0] PCSrc;
wire [1:0] RegDst;
wire RegWrite;
wire ALUSrc1;
wire ALUSrc2;
wire [5:0] ALUFun;
wire Sign;
wire MemWrite;
wire MemRead;
wire [1:0] MemtoReg;
wire ExtOp;
wire LuOp;

Control con(OpCode,  Funct, irq ,
                PCSrc,
                RegDst,  RegWrite,
                ALUSrc1, ALUSrc2,    ALUFun,
                Sign,
                MemRead, MemWrite,   MemtoReg, 
                ExtOp, LuOp);
initial begin
  OpCode<=6'h00;
  Funct<=6'h09;
  irq<=0;

end

endmodule
