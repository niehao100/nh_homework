module seq_det_reg(clk,in,out,rst_n,state)
input in,reset,clk;
output [6:6] state;
output out; 

initial begin
    out=0;
    tmp=0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
       state=0;
    else begin
        state=state<<1;
        state[5]=in;
    end
end

always @(state) begin
    if(state==6'b101011)
        out<=1;
end

endmodule

