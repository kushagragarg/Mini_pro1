`timescale 1ns/1ps

module transmit_tb;
reg clk, rst, iorw, iocs;
reg [1:0] ioaddr;
reg [7:0] databus;
wire tbr, txd;

transmit U0 (
.clk  (clk),
.rst  (rst),
.brg_full (brg_full),
.iorw (iorw),
.iocs (iocs),
.ioaddr (ioaddr),
.databus (databus),
.tbr (tbr),
.txd (txd)
);

brg BRG(.clk(clk),
				.rst(rst),
				.ioaddr(ioaddr),
				.databus(databus),
                .brg_en(brg_en),
				.brg_full(brg_full)
				);

initial
begin
clk = 0;
rst = 1;
iorw = 1;
iocs = 0;
databus = 8'h00;
ioaddr = 2'd0;

#40 rst = 0;

@ (posedge clk) begin
	if (tbr) begin
	iorw = 0;
	iocs = 1;
	databus = 8'h7B;
	end
end

#1;

@ (posedge clk) begin
	iorw = 1;
	iocs = 0;
end
// End of Write, now second write

#2288000;

@ (posedge clk) begin
	if (tbr) begin
	iorw = 0;
	iocs = 1;
	databus = 8'b10101010;
	end
end

#1;

@ (posedge clk) begin
	iorw = 1;
	iocs = 0;
end






//#200000;

//$stop;

end

always 
#10 clk = !clk;

endmodule
