//by Neil 2015/9/6
//CPU  
module cpu(sysclk,reset,switch,digi_out1,digi_out2,digi_out3,digi_out4,led,UART_RXD,UART_TXD);
input sysclk,reset;
input [7:0]switch;
input UART_RXD;
output [6:0]digi_out1,digi_out2,digi_out3,digi_out4; 
output [7:0]led;
output UART_TXD;


wire clk;
wire sig,sig16;
wire [11:0]digi;
wire [31:0]PC_add4;
wire	[31:0]	IFInst;
wire [31:0]Pc;
reg [31:0]ConBA;
//IF
wire [25:0]JT;
wire [31:0]Pc_in;
//ID
wire	[31:0]	IDInst;
wire	[31:0]	ID_PCAdd4;
wire irq;
wire [31:0]instruct;
wire [15:0]Imm16;
wire [4:0]Shamt;
wire [4:0]Rd,Rt,Rs;
wire [5:0]Opcode;
wire [5:0]Funct;
wire [2:0] PCSrc;
wire	[1:0]	RegDstIn;
wire	RegWrIn, ALUSrc1In, ALUSrc2In;
wire	[5:0]	ALUFunIn;
wire	SignIn, MemWrIn, MemRdIn;
wire	[1:0]	MemtoRegIn;
wire	[2:0]	BranchType;
wire ExtOp;
wire LuOp;
wire [4:0]RegAddrWr;
wire [31:0]DataBusA,DataBusB;
wire	[31:0]	RegFileA;
wire	[31:0]	RegFileB;
wire [31:0]lu,Ext_out;
wire	[4:0]	ID2EX_rt,ID2EX_rd;
//EX
wire [31:0]AluA,AluB,EX2MEM_ALUoutOut;
wire	[31:0]	imm32_out;
wire	[5:0]	ALUFunOut;
wire	ALUSrc1Out, ALUSrc2Out, SignOut;
wire	[1:0]	ID2EX_RegDstOut;
wire	ID2EX_MemRdOut, ID2EX_MemWrOut, ID2EX_RegWrOut;
wire	[1:0]	ID2EX_MemToRegOut;
wire	[31:0]	EX2PCAdd4_out;
wire	[31:0]	EX_ALUout;
wire	[4:0]	EX2MEM_rt,EX2MEM_rd;
wire	[4:0]	EX2MEM_RegAddrWr;
//MEM
wire	[31:0]	DataBusB_out;
wire	[31:0]	EX2MEM_rsData, EX2MEM_rtData;
wire	[1:0]	EX2MEM_MemToRegOut;
wire	EX2MEM_MemRdOut, EX2MEM_MemWrOut, EX2MEM_RegWrOut;
wire	[31:0]	MemReadData;
wire 	[31:0] 	MEM_PCAdd4Out;
wire [31:0]pout,dmout,uout;
wire	[4:0]	MEM2WB_RegAddrWr;

//WB
wire [1:0]MEM2WB_MemToRegOut;
wire	[31:0]	MEM2WB_ALUoutOut;
wire	[31:0]	MEM2WB_MEMDataOut;
wire	[31:0]	RegWriteData,WB2PCAdd4Out;
wire	MEM2WB_RegWrOut;
//forward||haz
wire	[2:0]	ForwardA;
wire	[2:0]	ForwardB;
wire	PcNextEnable;
wire	IF2ID_Flush;
wire	IF2ID_Write;
wire	ID2EX_Flush;
wire JHazardCom;
wire J;//J指令的具体值

assign  JT=IDInst [25:0];
always@(posedge clk) ConBA=(Ext_out<<2)+Pc;

cloc ck(sysclk,clk,sig,sig16);

PC pc(clk,reset,ConBA,DataBusA,JT,PCSrc,Pc_in,PC_add4,JHazardCom);


ROM rom(Pc,IFInst);
assign  Opcode  =IDInst[31:26];
assign  Imm16   =IDInst[15:0];
assign  Shamt   =IDInst[10:6];
assign  Rd      =IDInst[15:11];
assign  Rt      =IDInst[20:16];
assign  Rs      =IDInst[25:21];
assign  Funct   =IDInst[5:0];

IF PCIF(PcNextEnable,reset,clk,Pc_in,Pc);
IF2ID IFID(reset,clk,
			IF2ID_Flush,//if beq, flush all
			IF2ID_Write,PC_add4,
			IFInst,
			ID_PCAdd4,
			IDInst
        );



Control control(Opcode,  Funct, irq , reset,
                PCSrc,
                RegDstIn,  RegWrIn,
                ALUSrc1In, ALUSrc2In,    ALUFunIn,
                SignIn,
                MemRdIn, MemWrIn,   MemtoRegIn, 
                ExtOp, LuOp,J,BranchType);

assign RegAddrWr=(ID2EX_RegDstOut==2'b0)?EX2MEM_rd:
                (ID2EX_RegDstOut==2'b01)?EX2MEM_rt:
                (ID2EX_RegDstOut==2'b10)?5'd31:
                5'd26;

RegFile rf(reset,clk,Rs,RegFileA,Rt,RegFileB,MEM2WB_RegWrOut,MEM2WB_RegAddrWr,RegWriteData);
assign Ext_out=(Imm16[15]==1&&ExtOp==1)?{16'b1111_1111_1111_1111,Imm16}:{16'b0000_0000_0000_0000,Imm16};
assign lu=(LuOp==1'b1)?{Imm16,16'b0}:Ext_out;
ID2EX IDtoEX(
			 reset,clk,
			 ID2EX_Flush,RegDstIn,//if beq, flush all
			 ALUFunIn, ALUSrc1In, ALUSrc2In, 
			 SignIn, MemRdIn, MemWrIn,
			 RegWrIn, MemtoRegIn,
			 DataBusA, DataBusB,
			 Rt, Rd, 
			 lu, 
			 ID2EX_RegDstOut,ALUFunOut,
			 ALUSrc1Out,ALUSrc2Out,
			 SignOut,ID2EX_MemRdOut,
			 ID2EX_MemWrOut,
			 ID2EX_RegWrOut,
			 ID2EX_MemToRegOut,
			 EX2MEM_rsData,EX2MEM_rtData,
			 EX2MEM_rt,EX2MEM_rd,
			 imm32_out,
			 ID_PCAdd4,
			 EX2PCAdd4_out
			 );

assign AluA=(ALUSrc1Out==1'b1)?{27'b0,imm32_out[10:6]}:EX2MEM_rsData;
assign AluB=(ALUSrc2Out==1'b1)?imm32_out:EX2MEM_rtData;

ALU alu(AluA,AluB,SignOut,ALUFunOut,EX_ALUout);
EX2MEM EXMEM(
			 reset,clk,
			 ID2EX_MemRdOut, ID2EX_MemWrOut, 
			 ID2EX_RegWrOut,
			 ID2EX_MemToRegOut,
			 EX_ALUout,
			 EX2MEM_rtData,RegAddrWr,
			 EX2MEM_MemRdOut, 
			 EX2MEM_MemWrOut, EX2MEM_RegWrOut, 
			 EX2MEM_MemToRegOut,
			 EX2MEM_ALUoutOut,
			 DataBusB_out,
			 EX2MEM_RegAddrWr,
			 EX2PCAdd4_out,
			 MEM_PCAdd4Out
			 );


Peripheral per(reset,clk,EX2MEM_MemRdOut,EX2MEM_MemWrOut,EX2MEM_ALUoutOut,DataBusB_out,pout,led,switch,digi,irq);
digitube_scan ds(digi,digi_out1,digi_out2,digi_out3,digi_out4);

DataMem dm(reset,clk,EX2MEM_MemRdOut,EX2MEM_MemWrOut,EX2MEM_ALUoutOut,DataBusB_out,dmout);

UART ua(clk,reset,EX2MEM_ALUoutOut,uout,EX2MEM_MemRdOut,DataBusB_out,EX2MEM_MemWrOut,UART_RXD,UART_TXD,sig,sig16);

assign MemReadData=(EX2MEM_ALUoutOut<32'h40000000)?dmout:(EX2MEM_ALUoutOut>=32'h40000018)?uout:pout;


assign RegWriteData=(MEM2WB_MemToRegOut[1])?
						  ((MEM2WB_MemToRegOut[0])? 32'b0:WB2PCAdd4Out):
						  ((MEM2WB_MemToRegOut[0])? MEM2WB_MEMDataOut:MEM2WB_ALUoutOut);
 
					  
MEM2WB MEMWB(
			 reset,clk,
			 EX2MEM_RegWrOut,
			 EX2MEM_MemToRegOut, 
			 EX2MEM_ALUoutOut,
			 MemReadData,
			 EX2MEM_RegAddrWr, 
			 MEM2WB_RegWrOut, 
			 MEM2WB_MemToRegOut,
			 MEM2WB_ALUoutOut,
			 MEM2WB_MEMDataOut,
			 MEM2WB_RegAddrWr,
			 MEM_PCAdd4Out,WB2PCAdd4Out
			);

			
 
Forwarding_Reg Forwardingr(
							IDInst[25:21],IDInst[20:16],
							RegAddrWr,
							ID2EX_RegWrOut,
							EX2MEM_RegAddrWr, 
							EX2MEM_RegWrOut,
							EX2MEM_MemToRegOut,
							MEM2WB_RegAddrWr,
							MEM2WB_RegWrOut, 
							ForwardA, ForwardB
							); 
ex_branch eb(DataBusA,DataBusB,BranchType,JHazardCom);
							
Hazard Hazard_Detection(
						IDInst[25:21],IDInst[20:16],
						IF2ID_Flush,
						IF2ID_Write,
						ID2EX_MemRdOut,
						EX2MEM_rt,
						ID2EX_Flush,
						BranchType,J,JHazardCom,
						PcNextEnable
               );
					


    assign DataBusA=(ForwardA==3'b000)?RegFileA:
		(ForwardA==3'b001)?EX_ALUout:
		(ForwardA==3'b011)?MemReadData:
		(ForwardA==3'b100)?RegWriteData:
		(ForwardA==3'b010)?EX2MEM_ALUoutOut:
		RegFileA;
   
   

     assign DataBusB =(ForwardB==3'b000)?RegFileB:
     (ForwardB==3'b010)?EX2MEM_ALUoutOut:
     (ForwardB==3'b011)?MemReadData:
     (ForwardB==3'b001)?EX_ALUout:
     (ForwardB==3'b100)?RegWriteData:
	  RegFileB;
 endmodule
