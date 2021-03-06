//by neil 2015/8/21
//ALU--加法器单元
module ALUadd(A,B,Sign,ALUFun,zero,out_of_range,no_zero,addS);
input [31:0]A,B;
input Sign;
input [5:0]ALUFun;
output zero,out_of_range,no_zero;
output [31:0]addS;
wire [31:0]B_tmp;
wire [7:0]ctmp;
wire ctmp_31;
assign B_tmp=(ALUFun==5'b0)?B:((B^{32'hffffffff})+1);

adder4  a1(.A(A[3 :0 ]),.B(B_tmp[3 :0 ]),.cout(ctmp[0]),.cin(1'b0)   ,.addS(addS[3 :0 ]),.cout_3());
adder4  a2(.A(A[7 :4 ]),.B(B_tmp[7 :4 ]),.cout(ctmp[1]),.cin(ctmp[0]),.addS(addS[7 :4 ]),.cout_3());
adder4  a3(.A(A[11:8 ]),.B(B_tmp[11:8 ]),.cout(ctmp[2]),.cin(ctmp[1]),.addS(addS[11:8 ]),.cout_3());
adder4  a4(.A(A[15:12]),.B(B_tmp[15:12]),.cout(ctmp[3]),.cin(ctmp[2]),.addS(addS[15:12]),.cout_3());
adder4  a5(.A(A[19:16]),.B(B_tmp[19:16]),.cout(ctmp[4]),.cin(ctmp[3]),.addS(addS[19:16]),.cout_3());
adder4  a6(.A(A[23:20]),.B(B_tmp[23:20]),.cout(ctmp[5]),.cin(ctmp[4]),.addS(addS[23:20]),.cout_3());
adder4  a7(.A(A[27:24]),.B(B_tmp[27:24]),.cout(ctmp[6]),.cin(ctmp[5]),.addS(addS[27:24]),.cout_3());
adder4  a8(.A(A[31:28]),.B(B_tmp[31:28]),.cout(ctmp[7]),.cin(ctmp[6]),.addS(addS[31:28]),.cout_3(ctmp_31));
assign zero=(addS==0);
assign out_of_range=(Sign&(ctmp[7]==ctmp_31))|((~Sign)&((ctmp[7]&ALUFun)|(~ctmp[7]&~ALUFun)));
assign no_zero=(Sign&addS[31]);
endmodule

//四位加法器
module adder4(A,B,cout,cout_3,cin,addS);
input [3:0]A,B;
input cin;
reg [2:0]ctmp;
output cout,cout_3;
output [3:0]addS;
wire [3:0]p,g;

assign    p[0]=A[0]^B[0];
assign    p[1]=A[1]^B[1];
assign    p[2]=A[2]^B[2];
assign    p[3]=A[3]^B[3];
assign    g[0]=A[0]&B[0];
assign    g[1]=A[1]&B[1];
assign    g[2]=A[2]&B[2];
assign    g[3]=A[3]&B[3];
assign    cout=g[3]|(g[2]&p[3])|(g[1]&p[2]&p[3])|(p[3]&p[2]&p[1]&g[0])|(p[0]&p[1]&p[2]&p[3]&cin);
assign    cout_3=g[2]|(g[1]&p[2])|(p[2]&p[1]&g[0])|(p[0]&p[1]&p[2]&cin);
assign    addS[0]=p[0]^cin;
assign    addS[1]=p[1]^(g[0]|(p[0]&cin));
assign    addS[2]=p[2]^(g[1]|(p[1]&g[0])|(p[1]&p[0]&cin));
assign    addS[3]=p[3]^(g[2]|(g[1]&p[2])|(p[2]&p[1]&g[0])|(p[0]&p[1]&p[2]&cin));
endmodule


/*单位加法器
module adder(A,B,addS,cout,cin);
input A,B,cin;
output  cout,addS;
assign addS=(A^B)^cin;
assign cout= (A&B)|((A|B)&cin);
endmodule*/
