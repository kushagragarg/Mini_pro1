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
	reg clk;
	reg rst;
	reg IOCS;
	reg IORW;
   reg clr_rda;
   reg [1:0] ioaddr;
   reg TBR;
	// Outputs
	wire [7:0] DATABUS;
	
   reg [7:0] databus;
	wire RDA;   
   wire brg_en;
   wire brg_full;
	
	// Instantiate the Unit Under Test (UUT)
	receiver uut (
		.RX(RX), 
		.DATABUS(DATABUS), 
		.RDA(RDA), 
		.brg_en(brg_en), 
		.clk(clk), 
		.rst(rst), 
		.clr_rda(clr_rda)
	);
	
	brg BRG(
	   .clk(clk),
      .rst(rst),
      .ioaddr(ioaddr),
      .databus(databus),
      .brg_en(brg_en),
      .brg_full(brg_full)
   );

   

	initial begin
		// Initialize Inputs
		RX = 1;
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
	
	
	#100
	clr_rda = 1'b1;
	
	//#10;
	//clr_rda = 1'b0;
   	
   end

	always begin
		#5 clk = ~clk;
	end
	
	
      
endmodule

