module cloc(sysclk,clk,sig,sig16);
input sysclk;
output reg clk,sig,sig16;
reg [31:0]divide1;
integer state1,state2,state3;
initial
begin
    divide1=32'd26;
    clk=0;
    sig=0;
    sig16=0;
    state1=0;
    state2=0;
    state3=0;
end

always@(posedge sysclk) begin 
    if(state1==0)
        clk=~clk;
    state1=state1+32'b10;
    if(state1==divide1)
        state1=32'b0;
end



always@(posedge sysclk)// 按 divide 分频
begin
    if(state2==0)
        sig16=~sig16;
        state2=state2+10'b100;
    if(state2==10'd652)
        state2=0;
end

always@(posedge sysclk)// 按 divide 分频
begin
    if(state3==0)
        sig=~sig;
    state3=state3+14'b0000_0000_0000_10;
    if(state3==14'd5208)
        state3=0;
end

endmodule
