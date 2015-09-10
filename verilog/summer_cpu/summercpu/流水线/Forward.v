module Forward(EX2MEM_RegWrite,MEM2WB_RegWrite,EX2MEMRd,MEM2WBRd,ID2EXRs,ID2EXRt,forwardA,forwardB);
  input EX2MEM_RegWrite;
  input MEM2WB_RegWrite;
  input[4:0] EX2MEMRd;
  input[4:0] MEM2WBRd;
  input[4:0] ID2EXRs;
  input[4:0] ID2EXRt; 
  output reg[1:0] forwardA;
  output reg[1:0] forwardB;
  
  always @(*)
  begin
    if((EX2MEM_RegWrite)&(|EX2MEMRd)&(EX2MEMRd==ID2EXRs))
      forwardA<=2'b10;
    else
      if((MEM2WB_RegWrite)&(|MEM2WBRd)&(MEM2WBRd==ID2EXRs))
        forwardA<=2'b01;
      else
        forwardA<=2'b0;
      end
  always @(*)
  begin
  if((EX2MEM_RegWrite)&(|EX2MEMRd)&(EX2MEMRd==ID2EXRt))
      forwardB<=2'b10;
    else
      if((MEM2WB_RegWrite)&(|MEM2WBRd)&(MEM2WBRd==ID2EXRt))
        forwardB<=2'b01;
      else
        forwardB<=2'b0;   
  end
endmodule