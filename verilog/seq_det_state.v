module seq_det_state(clk,rst_n,in,out,state);

input clk,rst_n,in;
reg [2:0] c_s,  n_s;

output reg [2:0] state;
output reg out;
parameter [2:0]
    START=0,
    SA=1,
    SB=2,
    SC=3,
    SD=4,
    SE=5,
    SF=6;

initial begin
     out<=0;
    c_s<=START;
    n_s<=START;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        c_s <= START;
    else c_s<=n_s;
end

always @(c_s) begin
    case(c_s)
        START: begin
            if(in==1)
                n_s=SA;
            else n_s=START;
            end
        SA: begin
            if(in==0)
                n_s=SB;
            else n_s=SA;
            end
        SB: begin 
            if(in==1)
                n_s=SC;
            else n_s=START;
            end
        SC:begin
            if(in==0)
                n_s=SD;
            else n_s=SA;
            end
        SD:begin
            if(in==1)
                n_s=SE;
            else n_s=START;
        end
        SE:begin
            if(in==1)
                n_s=SF;
            else
                n_s=SD;
        end
        SF:begin
            if(in==1)
                n_s=SA;
            else n_s=SB;
        end 
          default: n_s=START;
    endcase
end

always @(c_s) begin
    out=0;
    case(c_s)
        START: state=3'b000;
        SA: state=3'b001;
        SB: state=3'b010;
        SC: state=3'b011;
        SD: state=3'b100;
        SE: state=3'b101;
        SF: begin
            state<=3'b110;
            out<=1;
            end
        default: state=3'b000;
    endcase
end


endmodule
