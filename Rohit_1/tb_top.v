`timescale 1ns/1ps

module tb_top;
reg clk, rst, RX;
reg [1:0] br_cfg;
wire txd;

top_level U0 (
.clk  (clk),
.rst  (rst),
.txd (txd),
.rxd (RX),
.br_cfg (br_cfg)
);



initial
begin
clk = 0;
rst = 1;
br_cfg = 2'b01;

#40 rst = 0;

#6300;
RX = 0;		


#6500;
RX = 1;		

#6500;	
RX = 1;		

#6500;
RX = 1;

#6500;
RX = 1;

#6500;
RX = 1;

#6500;
RX = 0;		

#6500;
RX = 0;		

#6500;
RX = 0;
	
#6500;
RX = 1;	

end

always 
#10 clk = ~clk;

endmodule
