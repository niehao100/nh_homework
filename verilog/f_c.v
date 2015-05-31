//-----------top-level和控制信号--------
module f_c(clock_50,testmode,sw2,ledr,hex3,hex2,hex1,hex0);
input clock_50,sw2;
reg clr_count,lat,state;
wire  to_test1,to_test0,clock_1;
wire [3:0] d1,d2,d3,d4;
input [1:0] testmode;
output ledr;
output [6:0]hex3,hex2,hex1,hex0;

signalinput  inp(.testmode(testmode),.sysclk(clock_50),.sigin(to_test0));
f_d division(.in(to_test0),.select(sw2),.out(to_test1));
counter count(.in(to_test1),.reset(clr_count),.d1(d1),.d2(d2),.d3(d3),.d4(d4));
f_latch la(.sig(lat),.d1(d1),.d2(d2),.d3(d3),.d4(d4),.od1(hex0),.od2(hex1),.od3(hex2),.od4(hex3));
clock cl1(.sysclk(clock_50),.clk1(clock_1));

initial begin
	lat<=0;
	clr_count=0;
	state=0;

end

always @(posedge clock_1) begin
	lat=~lat;
	if(state==0) begin
	 clr_count=1;
	 end
	else clr_count=0;
		if(state==0) state=1;
	else state=0;
end

assign ledr=sw2;
endmodule

//------------十分频--------------
module f_d(in,out,select);
 input in,select;
 output reg out;
 reg in_div;
 reg [3:0] count;
 initial begin
	count=4'd0;
	in_div=0;
end
 always @(in)	
		out=(select==0)?in:in_div;
		

always @(posedge in) begin
	 if(count==4'd4)
		in_div=~in_div;
	  if(count==4'd4) count=0;
	  else count=count+4'd1;
end
endmodule
//--------------时钟--------------
module clock(sysclk,clk1/*1Hz信号*/);
input sysclk;
output reg clk1;
reg [25:0] count;
initial begin
    clk1=0;
    count=0;
end
always @(posedge sysclk) begin
    count=count+1;
    if(count==26'd25000000) begin
        clk1=!clk1;
        count=0;
    end
end
endmodule

//---------计数器---------
module counter(in,reset,d1,d2,d3,d4);
input in,reset;
output reg [3:0] d4,d3,d2,d1;
reg _cadd;//进位
initial begin
    d4<=4'd0;
    d3<=4'd0;
    d2<=4'd0;
    d1<=4'd0;
end
always@(posedge in or posedge reset) begin
    if(reset) 
        d1<=4'd0;
    else begin
        if(d1==9)
          d1<=0;
        else 
            d1<=d1+4'd1;
    end
end
 always@(negedge d1[3] or posedge reset) begin
    if(reset) 
        d2<=4'd0;
    else begin
            if(d2==9) 
                d2<=0;
            else
              d2<=d2+4'd1;
    end
end
 always@(negedge d2[3] or posedge reset) begin
     if(reset) 
        d3<=4'd0;
    else begin
            if(d3==9) 
                d3<=0;
            else
              d3<=d3+4'd1;
    end
end
 always@(negedge d3[3] or posedge reset) begin
       if(reset) 
        d4<=4'd0;
    else begin
            if(d4==9) 
                d4<=0;
            else
              d4<=d4+4'd1;
    end
end
endmodule

//--------16位锁存器和显示输出--------
module f_latch(sig,d1,d2,d3,d4,od1,od2,od3,od4);
input sig;
input [4:0] d1,d2,d3,d4;
reg [4:0] t1,t2,t3,t4;
output [6:0] od1,od2,od3,od4;

always @(d1 or d2 or d3 or d4)begin
    if(!sig) begin
        t1<=d1;
        t2<=d2;
        t3<=d3;
        t4<=d4;
    end;
end
	assign od1=(t1==4'd0)?7'b1000000:
           (t1==4'd1)?7'b1111001:
           (t1==4'd2)?7'b0100100:
           (t1==4'd3)?7'b0110000:
           (t1==4'd4)?7'b0011001:
           (t1==4'd5)?7'b0010010:
           (t1==4'd6)?7'b0000010:
           (t1==4'd7)?7'b1111000:
           (t1==4'd8)?7'b0000000:
           (t1==4'd9)?7'b0010000:0;
	assign od2=(t2==4'd0)?7'b1000000:
           (t2==4'd1)?7'b1111001:
           (t2==4'd2)?7'b0100100:
           (t2==4'd3)?7'b0110000:
           (t2==4'd4)?7'b0011001:
           (t2==4'd5)?7'b0010010:
           (t2==4'd6)?7'b0000010:
           (t2==4'd7)?7'b1111000:
           (t2==4'd8)?7'b0000000:
           (t2==4'd9)?7'b0010000:0;
	assign od3=(t3==4'd0)?7'b1000000:
           (t3==4'd1)?7'b1111001:
           (t3==4'd2)?7'b0100100:
           (t3==4'd3)?7'b0110000:
           (t3==4'd4)?7'b0011001:
           (t3==4'd5)?7'b0010010:
           (t3==4'd6)?7'b0000010:
           (t3==4'd7)?7'b1111000:
           (t3==4'd8)?7'b0000000:
           (t3==4'd9)?7'b0010000:0;
	assign od4=(t4==4'd0)?7'b1000000:
           (t4==4'd1)?7'b1111001:
           (t4==4'd2)?7'b0100100:
           (t4==4'd3)?7'b0110000:
           (t4==4'd4)?7'b0011001:
           (t4==4'd5)?7'b0010010:
           (t4==4'd6)?7'b0000010:
           (t4==4'd7)?7'b1111000:
           (t4==4'd8)?7'b0000000:
           (t4==4'd9)?7'b0010000:0;
endmodule

//-----------------------------测试信号----------------------
module signalinput(
    input [1:0] testmode,//00,01,10,11 分别代表 4 种频率,分别为 3125 , 6250 , 50 , 12500Hz ,使用SW1~SW0 来控制
    input sysclk,// 系统时钟 50M
    output reg sigin// 输出待测信号
    );
    reg[20:0] state;
    reg[20:0] divide;
    initial
    begin
        sigin=0;
        state=21'b000000000000000000000;
        divide=21'b000000_1111_1010_0000000;
    end
    always@(testmode)
    begin
        case(testmode[1:0])
            2'b00:divide=21'd16000; //3125Hz
            2'b01:divide=21'd8000; //6250Hz
            2'b10:divide=21'd1000000; //50Hz
            2'b11:divide=21'd4000; //12500Hz
        endcase
    end
    always@(posedge sysclk)// 按 divide 分频
    begin
        if(state==0)
            sigin=~sigin;
        state=state+21'b0_00__0000_0000_0000_0000_10;
        if(state==divide)
            state=27'b000_0000_0000_0000_0000_0000_0000;
    end
endmodule
