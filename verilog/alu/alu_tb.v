//by PrayWolf
// modified by Neil
module ALUtb;
  reg[31:0] A,B;
  reg[5:0] ALUfun;
  reg Sign;
  wire[31:0] S;
  ALU testALU(.A(A),.B(B),.ALUFun(ALUfun),.Sign(Sign),.result(S));
  initial
   begin
     A=32'b1010_0010_1011_0000_0100_0010_1101_0001;
     B=32'b1010_0010_1011_0000_0100_0010_1101_0001;
     Sign=1'b0;
     ALUfun=6'b110011;  //EQ;
     #50 ALUfun=6'b110001;  //NEQ
     #50 ALUfun=6'b110101;  //LT
     #50 B=32'b0000_0000_0000_0000_0000_0000_0000_0000;
     ALUfun=6'b111101;  //LEZ
     #50 ALUfun=6'b111001;  //GEZ
     #50 ALUfun=6'b111111;  //GTZ
    	#50 Sign=1'b1;
     ALUfun=6'b110011;  //EQ;
     #50 ALUfun=6'b110001;  //NEQ
     #50 ALUfun=6'b110101;  //LT
     #50 B=32'b0000_0000_0000_0000_0000_0000_0000_0000;
     ALUfun=6'b111101;  //LEZ
     #50 ALUfun=6'b111001;  //GEZ
     #50 ALUfun=6'b111111;  //GTZ

   end
 endmodule

 
