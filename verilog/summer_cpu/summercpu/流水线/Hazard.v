module Hazard(ID2EX_MemRead,ID2EX_Rt,IF2ID_Rs,IF2ID_Rt,Stall);
 input ID2EX_MemRead;
 input[4:0] ID2EX_Rt,IF2ID_Rs,IF2ID_Rt;
 output reg Stall;
 always @(*)
 begin
   if(ID2EX_MemRead&((ID2EX_Rt==IF2ID_Rs)|(ID2EX_Rt==IF2ID_Rt)))
     Stall<=1;
   else
     Stall<=0;
   end
 endmodule