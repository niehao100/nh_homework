//By Neil 2015/8/21
module ALUcmp(Z,V,N,ALUFun,cmp);
input Z,V,N;
input [3:0]ALUFun;
output reg cmp;
always @(*) begin
case (ALUFun)
    3'b001:cmp  <=  Z;
    3'b000:cmp  <=  ~Z;
    3'b010:cmp  <=  N;
    3'b110:cmp  <=  Z|N;
    3'b100:cmp  <=  Z|~N;
    3'b111:cmp  <=  ~(Z|N);
    default:cmp <=  1'b0;
endcase
end
endmodule
