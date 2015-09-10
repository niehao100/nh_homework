module uart(clk,reset,Add,rdata,rd,wdata,wr,UART_RXD,UART_TXD,sig,sig16);
input clk,reset,UART_RXD,sig,sig16,rd,wr;
output [31:0]rdata;
output UART_TXD;
wire [7:0] RX_DATA;
wire RX_status,TX_STATUS,TX_EN;

assign rdata=(rd==1)?{24'b0,con_data}:32'b0;


recevier rx(.in(UART_RXD),.clk(sys_clk),.sig16(sig16),.reset(reset),.out(RX_DATA),.rx_status(RX_status));
controller con(.clk(sys_clk),.RX_status(RX_status),.RX_DATA(RX_DATA),.TX_STATUS(TX_STATUS),.TX_EN(TX_EN),.reset(reset),wr);
transmitter tra(.clk(sys_clk),.sig(sig),.reset(reset),.trans(wdata[7:0]),.tx_en(TX_EN),.tx_status(TX_STATUS),.out(UART_TXD));
endmodule

module controller(clk,reset,RX_status,RX_DATA,TX_STATUS,TX_EN,wr,data);
input clk,RX_status,TX_STATUS,reset,wr;
input [31:0] wdata;
input [7:0] RX_DATA;
output reg [7:0] data;
reg [1:0]flag;
output reg TX_EN;

initial begin 
    TX_EN<=0;
    flag<=0;
end

always @(posedge clk) begin
    if(reset==1) begin
        flag=0;
    end
    if(flag==2'd2) flag=0;
    if(flag==2'd1) flag=flag+1;
    if(RX_status==1) begin
        data=RX_DATA;
        flag=1;
    end
end

always@(posedge clk) begin
    if(add==32'h4000001c && TX_STATUS==1 && flag!=0 && wr==1) begin
        TX_EN=1;
    end
    else TX_EN=0;
end	
endmodule


module recevier(in,clk,sig16,reset,out,rx_status);
input clk,reset,sig16,in,receiv;
reg flag; 
reg [7:0] out1;
reg [20:0] temp;//count1 半比特宽 ,count2 八个抽样周期，count3抽八个值
reg[7:0] data;
output  reg[7:0] out;
output reg rx_status;
initial begin
    flag=0;
    temp=0;
end

always@(negedge sig16 or negedge reset)//
begin
    if(~reset)
    begin
        flag=0;
        out=0;
        out1=0;
    end
    else 
        if(receiv)
        begin
            if(in==0&&flag==0)
            begin
                flag=1;
            end
            if(flag==1)
            begin
                temp=temp+1;
                if(temp==24)
                    out1[0]=in;
                if(temp==40)
                    out1[1]=in;
                if(temp==56)
                    out1[2]=in;
                if(temp==72)
                    out1[3]=in;
                if(temp==88)
                    out1[4]=in;
                if(temp==104)
                    out1[5]=in;
                if(temp==120)
                    out1[6]=in;
                if(temp==136)
                begin
                    out1[7]=in;
                    rx_status=1;
                end
                if(temp==152)
                    rx_status=0;
                if(temp>152)
                begin
                    flag=0;
                    temp=0;
                end
            end
           out=out1;
        end
end
endmodule

module transmitter(clk,sig,reset,trans,tx_en,tx_status,out);
input clk,sig,reset,tx_en,transm;
input [7:0] trans;
reg flag1,flag2;
reg [3:0]count;
output reg out;
output reg tx_status;
initial begin
    flag1=0;
    flag2=0;
    out=1;
    tx_status=0;
    count=0;
end

always@(posedge sig or negedge reset)
begin


    if(~reset)
    begin
        tx_status=0;
        flag1=0;
        flag2=0;
        count=0;
    end
    else 
    begin
        if(tx_en==1)
        begin
            flag1=1;
            tx_status=0;
        end
        if(flag1==1)
        begin
            if(~flag2)
            begin
                out=0;
                flag2=1;
            end
            else 
            begin
                out=trans[count];
                count=count+1;
            end
        end
        else
        begin
            out=1;
            tx_status=1;
        end 
        if(count==8)
        begin
            flag1=0;flag2=0;tx_status=0;count=0;
        end
    end
end
endmodule

