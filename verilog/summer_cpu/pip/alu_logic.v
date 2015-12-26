//By Neil 2015/8/21
module ALUlg(A,B,ALUFun,lg);
input [31:0]A,B;
input [3:0]ALUFun;
output reg [31:0]lg;
always @(*) begin
    case (ALUFun)
        4'b1000:lg   <=  A&B;
        4'b1110:lg   <=  A|B;
        4'b0110:lg   <=  A^B;
        4'b0001:lg   <=  ~(A|B);
        4'b1010:lg   <=  A;
        default:lg   <=  A;
    endcase
end
endmodule
