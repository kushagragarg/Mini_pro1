`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Wisconsin-Madison
// Engineer: Rohit Shukla
// 
// Create Date:    21:56:45 01/28/2014 
// Design Name: Receiver module for SPART
// Module Name:    receiver 
// Project Name: SPART
// Target Devices: Virtex-5 (Digilent opensparc board)
// Tool versions: Xilinx ISE
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module receiver(
	input 		 RX,
	output  [7:0] DATABUS,
	output reg 	 RDA,
	input 		 brg_en,
	input 		 clk,
	input 		 rst,
	input 		 clr_rda		 
    );

	// Counter increments from 0 to 9. After its value becomes 9, this means
        // we have received all the serial data from computer. Now reset 
	// it to 0. 
	reg [3:0] counter;
	// A one bit state to keep in track whether we have started receiving
	// the serial data. 
	reg [1:0] state;
	reg [1:0] next_state;
	// Store the one bit input data in the register first.
	reg received_input_bit;

	// Sore the received bits in the ReceivedData register.
	// When all of the input serial data has been received
	// send it to the processor through DATABUS.
	reg [7:0] ReceivedData;
    
	assign DATABUS = ReceivedData;

   ////////////
   // STATES //
   ////////////
   localparam  NOT_RECEIVING_DATA  = 0,    
               RECEIVE_DATA        = 1,    
               SET_RDA             = 2; 
               
   //////////////////////
   // INPUT BITS STATE //
   //////////////////////
   localparam	START_BIT                 = 0,    
		COMPLETED_RECEIVING_DATA  = 9;
  
   
	always @(posedge clk)
	begin
		if(rst)
		begin
			ReceivedData <= 8'h0;
			received_input_bit <= 1'b0;
			state <= NOT_RECEIVING_DATA;
			counter <= 4'h0;
			next_state <= NOT_RECEIVING_DATA;
			RDA <= 1'b0;
		end
		else
		begin
			received_input_bit <= RX;
			state <= next_state;
			if( (received_input_bit == START_BIT) && (state == NOT_RECEIVING_DATA) && brg_en)
			begin
				next_state <= RECEIVE_DATA;
				counter <= counter+1;
			end
			else
			begin
				if( (state == RECEIVE_DATA) && (counter != COMPLETED_RECEIVING_DATA) && brg_en )
				begin
					ReceivedData <= {ReceivedData[6:0], received_input_bit};
					counter <= counter+1;
				end
				else if((state == RECEIVE_DATA) && (counter == COMPLETED_RECEIVING_DATA))
				begin
					next_state <= SET_RDA;
					counter <= 4'h0;
     				RDA <= 1'b1;
				end
				else if((state == SET_RDA) && (RDA == 1'b1) && (clr_rda == 1'b1))
				begin
					next_state <= NOT_RECEIVING_DATA;
					RDA <= 1'b0;
			//		DATABUS <= ReceivedData; // Needn't assign receiver here .... since read is asynchronous
					ReceivedData <= 8'b0;
				end     
			end
			
		end
	end


endmodule
