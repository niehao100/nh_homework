
module counter_sync(
	clk,
	reset,
	dout
	);

input   [0:0]   clk,reset;
output 	[6:0] 	dout;
reg 	[3:0]	data;


initial begin 
data=0;

end

always @(negedge clk,negedge reset)	begin
		if(!reset)
			data<=0;
		else begin
			data[0]<=~data[0];
			if(data[0]==1 && data[1]==1 && data[2]==1)
				data[3]<=~data[3];
			if(data[0]==1 && data[1]==1)
					data[2]<=~data[2];
			if(data[0]==1)
						data[1]<=~data[1];
		end
end



		assign dout=(data==4'h0)?7'b1000000:
             (data==4'h1)?7'b1111001:
             (data==4'h2)?7'b0100100:
             (data==4'h3)?7'b0110000:
             (data==4'h4)?7'b0011001:
             (data==4'h5)?7'b0010010:
             (data==4'h6)?7'b0000010:
             (data==4'h7)?7'b1111000:
             (data==4'h8)?7'b0000000:
             (data==4'h9)?7'b0010000:
			    (data==4'hA)?7'b0001000:
			    (data==4'hB)?7'b0000011:
				(data==4'hC)?7'b1000110:
				(data==4'hD)?7'b0100001:
			   (data==4'hE)?7'b0000110:
			   (data==4'hF)?7'b0001110:7'b0;
endmodule				
