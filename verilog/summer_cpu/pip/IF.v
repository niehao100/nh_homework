`timescale 1ns/1ps
module IF(writeEn, reset, clk, Pc_In, Pc_Out);

input	writeEn, reset, clk;
input	[31:0]	Pc_In;
output	reg	[31:0]	Pc_Out;

always @(negedge reset or posedge clk) begin
	if(!reset) begin
		Pc_Out<=32'h80000000;
	end
	else begin
		if(writeEn) begin
			Pc_Out<=Pc_In;
		end
		else begin
			Pc_Out<=Pc_Out;
		end
	end
end

endmodule
