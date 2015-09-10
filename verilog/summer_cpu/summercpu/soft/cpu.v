//by Neil 2015/9/2
//CPU  闂備焦鐪归崝宀€鈧矮鍗虫俊瀛樼節閸曨亝鍕冮梺绋挎湰娑撹绗熼埀顒€鐣风粩濡昳mescale 1ns/1ps
module cpu(sysclk,reset,switch,digi_out1,digi_out2,digi_out3,digi_out4,led,UART_RXD,UART_TXD);
input sysclk,reset;
input [7:0]switch;
output [6:0]digi_out1,digi_out2,digi_out3,digi_out4; 
output [7:0]led;
wire clk;
wire debug;
wire [11:0]digi;
wire [25:0]JT;
wire [31:0]ConBA,Pc;
wire [31:0]instruct;
wire irq;
wire [15:0]Imm16;
wire [4:0]Shamt;
wire [4:0]Rd,Rt,Rs;
wire [5:0]Opcode;
wire [5:0]Funct;

wire [2:0] PCSrc;
wire [1:0] RegDst;
wire RegWrite;
wire ALUSrc1,ALUSrc2;
wire [5:0] ALUFun;
wire Sign;
wire MemWrite,MemRead;
wire [1:0] MemtoReg;
wire ExtOp;
wire LuOp;


wire [4:0]Addrc;
wire [31:0]write_Data_C;
wire [31:0]AluA,AluB;
wire [31:0]DataBusA,DataBusB,DataBusC;
wire [31:0]ALUOut;
wire [31:0]pout,dmout;
wire [31:0]lu,Ext_out,readdataout;

input UART_RXD;
output UART_TXD;
wire [31:0]uout;
wire sig,sig16;
//assign led[0]=UART_TXD;
assign  JT=instruct [25:0];
cloc ck(sysclk,clk,sig,sig16);
PC pc(clk,reset,ALUOut[0],ConBA,DataBusA,JT,PCSrc,Pc);

ROM rom(Pc,instruct);
assign  Opcode  =instruct[31:26];
assign  Imm16   =instruct[15:0];
assign  Shamt   =instruct[10:6];
assign  Rd      =instruct[15:11];
assign  Rt      =instruct[20:16];
assign  Rs      =instruct[25:21];
assign  Funct   =instruct[5:0];
Control control(Opcode,  Funct, irq , reset,
                PCSrc,
                RegDst,  RegWrite,
                ALUSrc1, ALUSrc2,    ALUFun,
                Sign,
                MemRead, MemWrite,   MemtoReg, 
                ExtOp, LuOp);

assign Addrc=(RegDst==2'b0)?Rd:
                (RegDst==2'b01)?Rt:
                (RegDst==2'b10)?5'd31:
                5'd26;

RegFile rf(reset,clk,Rs,DataBusA,Rt,DataBusB,RegWrite,Addrc,DataBusC);

assign Ext_out=(Imm16[15]==1&&ExtOp==1)?{16'b1111_1111_1111_1111,Imm16}:{16'b0000_0000_0000_0000,Imm16};
assign ConBA=(Ext_out<<2)+Pc+4;



assign lu=(LuOp==1'b1)?{Imm16,16'b0}:Ext_out;

assign AluA=(ALUSrc1==1'b1)?Shamt:DataBusA;
assign AluB=(ALUSrc2==1'b1)?lu:DataBusB;

ALU alu(AluA,AluB,Sign,ALUFun,ALUOut);

Peripheral per(reset,clk,MemRead,MemWrite,ALUOut,DataBusB,pout,led,switch,digi,irq);
digitube_scan ds(digi,digi_out1,digi_out2,digi_out3,digi_out4);

DataMem dm(reset,clk,MemRead,MemWrite,ALUOut,DataBusB,dmout);

UART ua(clk,reset,ALUOut,uout,MemRead,DataBusB,MemWrite,UART_RXD,UART_TXD,sig,sig16);

assign readdataout=(ALUOut<32'h40000000)?dmout:(ALUOut>=32'h40000018)?uout:pout;

assign DataBusC=(irq==1&&(Opcode==6'h02||Opcode==6'h03))?{4'h0,JT,2'b00}:(MemtoReg==2'b0)?ALUOut[31:0]:
                 (MemtoReg==2'b1)?readdataout:
                 Pc+4;
endmodule
