`timescale 1ns/1ps

module tb_top;
reg clk, rst, rxd;
reg [1:0] br_cfg;
wire txd;

top_level U0 (
.clk  (clk),
.rst  (rst),
.txd (txd),
.rxd (rxd),
.br_cfg (br_cfg)
);



initial
begin
clk = 0;
rst = 1;
br_cfg = 2'b01;

#40 rst = 0;

end

always 
#10 clk = !clk;

endmodule
