//by Pray Wolf 
//2015.9.2
module PC(clk,reset,ALUOut0,ConBA,DatabusA,JT,PCSrc,PC);
  input clk,reset;
  input ALUOut0;
  input[31:0] ConBA,DatabusA;
  input[25:0] JT;
  input[2:0] PCSrc;
  wire [31:0]PC_add_4;
  output reg[31:0] PC;
  parameter ILLOP=32'h8000_0004;
  parameter XADR=32'h8000_0020;
initial 
PC=32'b0;
  assign PC_add_4=PC+32'd4;//为了保证PC最高位不变

  always @(posedge clk,negedge reset)
    begin
      if(reset==0)//reset????
        PC<=32'h8000000;
      else
        begin
          case(PCSrc)
            3'b000:PC<={PC[31],PC_add_4[30:0]};
            3'b001:PC<=(ALUOut0==1)? {PC[31],ConBA[30:0]}:{PC[31],PC_add_4[30:0]};
            3'b010:PC<={PC[31:28],JT,2'b00};//J,Jal不改变最高位
            3'b011:PC<=DatabusA;
            3'b100:PC<=ILLOP;
            3'b101:PC<=XADR;
				default:PC<=32'h8000000;
          endcase
        end
    end
endmodule
    
