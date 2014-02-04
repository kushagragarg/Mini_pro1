`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    transmit
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module transmit( 
clk,
rst,
brg_full,
//baud rate generator en
iorw, //constitutes wr_en
iocs, //constitutes wr_en
databus,
ioaddr,
tbr,
txd
);

//Input ports
input clk;
input rst;
input brg_full; 
input iorw;
input iocs;
input [1:0] ioaddr;
//input wr_en;  // Active high
input [7:0] databus;

// Output ports
output tbr;
output txd;

reg [8:0] piso; // parallel in serial out shifter
reg [3:0] count;
reg buffer_full;

assign tbr = ~buffer_full;
assign txd = piso[0];  // Last bit of shifter sent out
assign cnt_flag = (count == 10);

always @ (posedge clk)
begin
     if(rst) begin
		 piso <= 9'h1FF;  // Should send out STOP bit
     end

	 else if (iocs & ~iorw & (ioaddr == 2'd0)) begin
		 piso <= {databus[7:0],1'b1};
	 end

	
	else if (buffer_full && brg_full && ~cnt_flag ) begin
	if (count == 0)
		piso[0] <= 1'b0; // Start bit
	else
		piso <= {1'b1, piso[8:1]}; // Shift
	end

	else if (cnt_flag & brg_full)  begin
		piso <= 9'h1FF;
	end
end

//Different block for buffer_full
always @ (posedge clk)
begin
if (rst)
	buffer_full <= 1'b0;
else if (cnt_flag & brg_full)
	buffer_full <= 1'b0;
else if (iocs & ~iorw & (ioaddr == 2'b0))
	buffer_full <= 1'b1;
end


// Different block for count
always @ (posedge clk)
begin
if (rst)
	count <= 0;
else if (cnt_flag & brg_full) // When all bits are sent, reset count to 0
	count <= 0;
else if (brg_full & buffer_full) // On each brg en, increment count by one
	count <= count + 1;
end
	
endmodule
