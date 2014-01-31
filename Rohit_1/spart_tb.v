module spart_tb;

   // Inputs
	reg rxd;	
	reg clk;
	reg rst;
	reg iocs;
	reg iorw;   
   reg [1:0] ioaddr;
   wire tbr;
	// Outputs
	wire [7:0] databus;
	
   //reg [7:0] databus;
	wire rda;   
	
spart SPART(
    .clk(clk),
    .rst(rst),
    .iocs(iocs),
    .iorw(iorw),
    .rda(rda),
    .tbr(tbr),
    .ioaddr(ioaddr),
    .databus(databus),
    .txd(txd),
    .rxd(rxd)
    );
    
    
    initial begin
		// Initialize Inputs
		rxd = 1;
		clk = 0;
		rst = 0;
		iocs = 0;
		iorw = 0;
      ioaddr = 2'b00;
      
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	initial begin
	#20 rst = 1;
	#10 rst = 0;	
	
	iocs = 1;
	iorw = 1;
		
	#6300;
	rxd = 0;		
	
	
	#6500;
	rxd = 1;		
	
	#6500;	
	rxd = 1;		
	
   #6500;
	rxd = 1;

   #6500;
	rxd = 1;
	
	#6500;
	rxd = 1;
	
	#6500;
	rxd = 0;		
	
	#6500;
	rxd = 0;		
	
	#6500;
	rxd = 0;
		
   #6500;
	rxd = 1;	
	
	
	//#100
	//clr_rda = 1'b1;
	
	//#10;
	//clr_rda = 1'b0;
   	
   end

	always begin
		#5 clk = ~clk;
	end
endmodule