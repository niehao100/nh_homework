module seq_det_reg(clk,in,out,rst_n,state);
input in,rst_n,clk;
output reg [5:0] state;
output reg out; 

initial begin
    out=0;
    state=0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
       state=0;
    else begin
        state=state<<1;
        state[0]=in;
    end
end

always @(state) begin
    if(state==6'b101011)
        out<=1;
	 else out<=0;
end

endmodule

