`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   	30 Jan 2014
// Design Name: 	SPART
// Module Name:    	spart
// Project Name: 
// Target Devices: 	Xilinx Virtex 5
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// clr_rda is needs to be modified depending on Rohit's sub module
//////////////////////////////////////////////////////////////////////////////////
module spart(
    input clk,
    input rst,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );

    wire [7:0] rx_databus;
	wire brg_en, brg_full;
	reg clr_rda;
	reg rx_tri_en, status_tri_en, brg_tri_en;

	// Instantiate sub-modules
	brg DUT_brg(.databus(databus),
				.clk(clk),
				.rst(rst),
				.brg_en(brg_en),
				.brg_full(brg_full),
				.ioaddr(ioaddr)
				);

	transmit DUT_tx(.databus(databus),
					.clk( clk),
					.rst( rst),
					.tbr(tbr),
					.brg_full(brg_full),
					.txd(txd),
					.ioaddr(ioaddr),
					.iorw(iorw),
					.iocs(iocs)
					);


	receiver DUT_rx(.DATABUS(rx_databus), 
					.clk(clk), 
					.rst(rst),
					.RDA(rda),
					.RX(rxd),
					.brg_en(brg_en),
					.clr_rda(clr_rda)
					);

	// Bus Interface
	// Enable tri-states for Receiver and Status to drive the bus when required.
	always @(*) begin
	rx_tri_en = 1'b0;
	status_tri_en = 1'b0;
	clr_rda = 1'b0;
		if (iocs) begin
			if (ioaddr == 2'b00 && iorw == 1'b1) begin // Read command
				rx_tri_en = 1'b1;
				clr_rda = 1'b1;
			end
			if (ioaddr == 2'b01 && iorw == 1'b1)  // Reading status register
				status_tri_en = 1'b1;
		end
		else begin
			rx_tri_en = 1'b0;
			status_tri_en = 1'b0;
		end
	end

	// If command is to read RX buffer or status register, databus is driven by either rx_databus or status register else 'ZZ
	assign databus = rx_tri_en ? rx_databus : (status_tri_en ? {6'h00,tbr,rda}: 8'hzz); 

	
endmodule
