module UART(clk,reset,Add,rdata,rd,wdata,wr,UART_RXD,UART_TXD,sig,sig16);
input clk,reset,UART_RXD,sig,sig16,rd,wr;
input [31:0]wdata,Add;
wire [7:0]led;
output reg [31:0]rdata;
//output [7:0]led;
reg  [2:0] CON;
output UART_TXD;
wire [7:0] RX_DATA;
reg [7:0]data;
reg[7:0] tx;
wire RX_status,TX_STATUS,TX_EN;
initial begin
	rdata=32'b0;
	data=8'b0;
	CON=3'b0;
end
assign led[0]=RX_status;
assign led[1]=TX_STATUS;
assign led[2]=TX_EN;
always @(clk) begin
 CON[0]=TX_STATUS;
 CON[1]=RX_status;
end
always @(posedge RX_status or posedge clk or negedge reset) begin
    if(reset==0)
      data=8'b0;
    else data=RX_DATA;
end
//assign led=RX_DATA;
always @(posedge clk) begin	
    if(rd) begin
        case(Add)
            32'h4000001C:begin
                rdata={24'b0,data};
            end
            32'h40000020:rdata={30'b0,CON};
            default:rdata=32'b0;
        endcase
    end
    else if(RX_status==0)rdata=32'b0;
end

always @(posedge clk) begin
    if(wr==1&&Add==32'h40000018&&TX_STATUS==1)
        tx=wdata[7:0];
    else if(wr==1&&Add==32'h40000020)
        CON[2]=wdata[2];
end
recevier rx(.in(UART_RXD),.clk(clk),.sig16(sig16),.reset(reset),.out(RX_DATA),.rx_status(RX_status));
controller con(.clk(clk),.RX_status(RX_status),.RX_DATA(RX_DATA),.TX_STATUS(TX_STATUS),.TX_EN(TX_EN),.reset(reset),.Add(Add),.wr(wr),.wdata(wdata));
transmitter tra(.clk(clk),.sig(sig),.reset(reset),.trans(tx),.tx_en(TX_EN),.tx_status(TX_STATUS),.out(UART_TXD));
endmodule

module controller(clk,reset,RX_status,RX_DATA,TX_STATUS,TX_EN,Add,wr,wdata);
input clk,RX_status,TX_STATUS,reset,wr;
input [31:0] wdata,Add;
input [7:0] RX_DATA;
output reg TX_EN;
initial begin 
    TX_EN<=0;
end


always@(posedge clk) begin
    if(Add==32'h40000018 && TX_STATUS==1 && wr==1) begin
        TX_EN=1;
    end
    else TX_EN=0;
end	
endmodule


module recevier(in,clk,sig16,reset,out,rx_status);
input clk,reset,sig16,in;
reg flag; 
reg [7:0] out1;
reg [20:0] temp;//
output  reg[7:0] out;
output reg rx_status;
initial begin
    flag=0;
    temp=0;
	rx_status=0;
end

always@(negedge sig16 or negedge reset)//
begin
    if(~reset)
    begin
        flag=0;
        out=0;
        out1=0;
    end
    else  begin
        if(in==0&&flag==0)
        begin
            flag=1;
        end
        if(flag==1)
        begin
            temp=temp+21'b1;
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
        if(rx_status==1) out=out1;
        else out=8'b0;
    end
end
endmodule

module transmitter(clk,sig,reset,trans,tx_en,tx_status,out);
input clk,sig,reset,tx_en;
input [7:0] trans;
reg flag1,flag2;
reg [3:0]count;
output reg out;
output reg tx_status;
reg tmp;
initial begin
    flag1=0;
    flag2=0;
    out=1;
    tx_status=1;
    count=0;
end

always@(posedge tx_en or posedge tmp) begin
    if(tx_en) begin
        flag1=1;
        tx_status=0;
    end
    else begin
        if(tmp) begin
            flag1=0;
            tx_status=1;
        end
    end
end
always@(posedge sig or negedge reset)
begin
    if(~reset)
    begin
        flag2=0;
        count=0;
    end
    else 
    begin
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
                count=count+4'b1;
            end
        end
        else
        begin
            out=1;
        end 
        if(count==4'b1000)
        begin
            tmp=1;flag2=0;count=0;
        end
        else
            tmp=0;
    end
end
endmodule

