//By Neil 2015/8/21
module ALU(A,B,Sign,ALUFun,result);
input [31:0]A,B;
input [5:0]ALUFun;
input Sign;
output reg [31:0]result;
wire zero,out_of_range,no_zero,cmp;
wire [31:0]B_tmp,addS,shift,lg;
assign B_tmp=(ALUFun[3]==1'b1)?32'b0:B;
ALUadd add(.A(A),.B(B_tmp),.Sign(Sign),.ALUFun(ALUFun[1]),.zero(zero),.out_of_range(out_of_range),.no_zero(no_zero),.addS(addS));
ALUcmp compare(.Z(zero),.V(out_of_range),.N(no_zero),.ALUFun(ALUFun[3:1]),.cmp(cmp));
ALUlg lgc(.A(A),.B(B),.ALUFun(ALUFun[3:0]),.lg(lg));
ALUshift shi(.A(A[4:0]),.B(B),.ALUFun(ALUFun[1:0]),.shift(shift));


always@(*) begin
    case(ALUFun[5:4])
        2'b00: result    <=  addS;
        2'b11: result    <=  {31'b0,cmp};
        2'b01: result    <=  lg;
        2'b10: result    <=  shift;
        default: result  <=  0;
    endcase
end
endmodule
