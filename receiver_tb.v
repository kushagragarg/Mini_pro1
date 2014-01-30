`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:26:57 01/30/2014
// Design Name:   receiver
// Module Name:   C:/Users/rshukla/Xilinx_Projects/RECEIVER/receiver_tb.v
// Project Name:  RECEIVER
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: receiver
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module receiver_tb;

	// Inputs
	reg RX;
	reg brg_en;
	reg clk;
	reg rst;
	reg IOCS;
	reg IORW;
   reg clr_rda;
	// Outputs
	wire [7:0] DATABUS;
	wire RDA;
   

	
	// Instantiate the Unit Under Test (UUT)
	receiver uut (
		.RX(RX), 
		.DATABUS(DATABUS), 
		.RDA(RDA), 
		.brg_en(brg_en), 
		.clk(clk), 
		.rst(rst), 
		.IOCS(IOCS), 
		.IORW(IORW),
		.clr_rda(clr_rda)
	);

	initial begin
		// Initialize Inputs
		RX = 1;
		brg_en = 0;
		clk = 0;
		rst = 0;
		IOCS = 0;
		IORW = 0;
      clr_rda = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	initial begin
	#20 rst = 1;
	#10 rst = 0;	
	
	IOCS = 1;
	IORW = 1;
		
	#80;
	brg_en = 1;
	RX = 0;		
	#10;
	brg_en = 0;
	
	#80;
	brg_en = 1;
	RX = 0;		
	#10;
	brg_en = 0;
	
	#80;
	brg_en = 1;
	RX = 1;		
	#10;
	brg_en = 0;
	
   #80;
	brg_en = 1;
	RX = 0;		
	#10;
	brg_en = 0;

   #80;
	brg_en = 1;
	RX = 1;		
	#10;
	brg_en = 0;
	
	#80;
	brg_en = 1;
	RX = 1;		
	#10;
	brg_en = 0;	
	
	#80;
	brg_en = 1;
	RX = 0;		
	#10;
	brg_en = 0;
	
	#80;
	brg_en = 1;
	RX = 0;		
	#10;
	brg_en = 0;
	
	#80;
	brg_en = 1;
	RX = 0;		
	#10;
	brg_en = 0;
		
   #80;
	brg_en = 1;
	RX = 1;		
	#10;
	brg_en = 0;
	
	
	#100
	clr_rda = 1'b1;
	
	#10;
	clr_rda = 1'b0;
   	
   end

	always begin
		#5 clk = ~clk;
	end
	
	
      
endmodule

