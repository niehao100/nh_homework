module uart(sys_clk,reset,UART_RXD,UART_TXD,RX_DATA);
input sys_clk,reset,UART_RXD;
output UART_TXD;
output [7:0] RX_DATA;
wire [7:0]TX_DATA;
wire RX_status,TX_STATUS,TX_EN,sig,sig16;

signal d(.sysclk(sys_clk),.sig(sig),.sig16(sig16));
recevier rx(.in(UART_RXD),.clk(sys_clk),.sig16(sig16),.reset(reset),.out(RX_DATA),.rx_status(RX_status));
controller con(.clk(sys_clk),.RX_status(RX_status),.RX_DATA(RX_DATA),.TX_STATUS(TX_STATUS),.TX_EN(TX_EN),.trans(TX_DATA),.reset(reset));
transmitter tra(.clk(sys_clk),.sig(sig),.reset(reset),.trans(TX_DATA),.tx_en(TX_EN),.tx_status(TX_STATUS),.out(UART_TXD));
endmodule

module controller(clk,reset,RX_status,RX_DATA,TX_STATUS,TX_EN,trans);
input clk,RX_status,TX_STATUS,reset;
input [7:0] RX_DATA;
reg [7:0] data;
reg [1:0]flag;
output reg[7:0] trans;
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
			if(data[0]==1)	begin
				data=data^8'b11111111;
			end
		end
	end
		
	always@(posedge clk) begin
		if(TX_STATUS==1 && flag!=0) begin
				trans=data;
				TX_EN=1;
		end
		else TX_EN=0;
	end	
endmodule

	
module recevier(in,clk,sig16,reset,out,rx_status,data);
     input clk,reset,sig16,in;
      reg [4:0] count1,count2,count3; //count1 半比特宽 ,count2 八个抽样周期，count3抽八个值
	  reg [1:0] if_rec;
	  output reg[7:0] data;
	  output  reg[7:0] out;
	  output reg rx_status;
	  initial begin
		if_rec=0;
		data=0;
		count1=0;count2=0;count3=0;
	end
	
	always@(posedge sig16) begin
	   if(reset==0) begin
		   if_rec=2'b10;
			count3=5'd12;
		end
		if(if_rec==0) begin  
			if(in==0) begin 
				if(count1==5'd7) begin
					count1=0;
					if_rec=1;
				end
			count1=count1+1;
			end
		end
		else begin
				count2=count2+1;
				if(count3==5'd8) begin
					if_rec=2'b10;
				end
				if(count3==5'd12)  begin
				  count3=0;
				  if_rec=0;
				  count2=0;
				  data=0;
				 end
				if(count2==5'd16) begin
					count2=0;
					if(if_rec==1) begin
					   data=data>>1;
					   data[7]=in;
					 end
					count3=count3+1;
				end
		end
	end
	
	always @(posedge clk) begin
		if(reset==0)
			out=0;
		if(count3==5'd11) begin
			rx_status=1;
			out=data;
		end
		else rx_status=0;
	end			
endmodule

module transmitter(clk,sig,reset,trans,tx_en,tx_status,out,count);
    input clk,sig,reset,tx_en;
    input [7:0] trans;
    reg [7:0] data;
	reg enable;
	output reg [3:0]count;
    output reg out;
	output reg tx_status;
	initial begin
	  enable=0;
	  out=1;
	  tx_status=1;
	  count=0;
	 end
	 
	always@(posedge sig ) begin
		if(reset==0) begin
			count=4'd10;
		end
		if(count==4'd10) begin
			count=0;
			out=1;
		end 
		if(enable==1) begin
			case(count)		
			 4'b0000:begin 
			   data=trans;
			   out=0; 			
			 end
			 4'b1001:begin
			   out=1;
			  end
			 default: begin
			   out=data[0];
			   data=data>>1;
			 end
		  endcase
		  count=count+1;
		end  
	end
	
	always@ (posedge tx_en or posedge clk) begin
		if(tx_en==1) begin
			enable=1;
			tx_status=0;
		end
		else begin
			if(count==4'd10) begin
				enable=0;
				tx_status=1;
			end
		end
	end	

endmodule

//生成9600Hz和9600*16Hz的信号
module signal(
    input sysclk,// 系统时钟 50M
    output reg sig,sig16// 输出待测信号 
	);
    reg[9:0] state1;
    reg[13:0] state2;
    initial
    begin
		sig<=0;
		sig16<=0;
		state2<=0;
		state1<=0;
	end
  
    always@(posedge sysclk)// 按 divide 分频
    begin
        if(state1==0)
            sig16=~sig16;
        state1=state1+10'b100;
        if(state1==10'd652)
            state1=0;
    end
	
	always@(posedge sysclk)// 按 divide 分频
    begin
        if(state2==0)
            sig=~sig;
        state2=state2+14'b0000_0000_0000_10;
        if(state2==14'd5208)
            state2=0;
    end
endmodule