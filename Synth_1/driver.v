`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    driver 
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
module driver(
    input clk,
    input rst,
    input [1:0] br_cfg,
    output reg iocs,
    output reg iorw,
    input rda,
    input tbr,
    output reg [1:0] ioaddr,
    inout [7:0] databus
    );

	parameter IDLE = 1'b0;
  parameter WRITE = 1'b1;

	parameter BRG_CGF_325 = 2'b00;
	parameter BRG_CGF_162 = 2'b01;
	parameter BRG_CGF_81 = 2'b10;
	parameter BRG_CGF_40 = 2'b11;
	
//	reg iocs, iorw;
//	reg [1:0] ioaddr;
//	reg [7:0] databus;
	reg state;  // 0 implies idle, 1 implies write state
	reg next_state;
	reg [1:0] ready_rw;
	reg [7:0] databus_drive;  // Data which will drive the bus
    reg [7:0] databus_input;

	reg [7:0] div_low;
	reg [7:0] div_high;
	

// Read case, needs to be changed
assign databus =  (iorw == 0 & iocs == 1 ) ? databus_drive : 8'hzz;
//assign databus_input = databus;


always @ (*) begin
	case (br_cfg) 
//	begin
	BRG_CGF_325:
	//if (br_cfg == 2'b00)
	begin	// Div - 325
	div_low <=  8'h45;
	div_high <= 8'h01;
	end
	
	BRG_CGF_162:
//	else if (br_cfg == 2'b01)
	begin	// Div - 162
	div_low <=  8'hA2;
	div_high <= 8'h00;
	end
	
	BRG_CGF_81:	
//	else if (br_cfg == 2'b10)
	begin	// Div - 81
	div_low <=  8'h51;
	div_high <= 8'h00;
	end
	
	BRG_CGF_40:
//	else if (br_cfg == 3)
	begin	// Div - 40
	div_low <=  8'h28;
	div_high <= 8'h00;
	end
	
	//end
	endcase
end
		
	always @ (posedge clk)
	begin
	if(rst) begin
	state <= #1 IDLE;
	
  end
	else
	state <= #1 next_state;
	end
	
	
	

	
	always @(state or tbr or ready_rw)
	begin
	case(state)
	IDLE : if ((tbr == 1) & (ready_rw == 2 ))
			next_state = WRITE;
			
	WRITE : next_state = IDLE;
	default : next_state = IDLE;
	endcase
	end
	
	// Output logic
	
	always @ (posedge clk)
	begin
		if (rst) begin
		iocs <=0;
		iorw <= 1;
		ioaddr <= 2'b00;
		databus_drive <= 8'h00;
		ready_rw <= 2'b00;
		end

// Upon reset program div buf
		else if ( ready_rw == 0)
    begin
		ioaddr <= 2'b10; // Div buffer low
		iocs <= 1;
		iorw <= 0;
		databus_drive <= div_low; // condition based on input
		ready_rw <= ready_rw + 1;
		end

		else if ( ready_rw == 1)
    begin
		ioaddr <= 2'b11; // Div buffer low
		iocs <= 1;
		iorw <= 0;
		databus_drive <= div_high; // condition based on input
		ready_rw <= ready_rw + 1;
		end

		else if ( ready_rw == 2 )
			begin
			case(next_state)
			IDLE :  begin
					iocs <=0;
					iorw <= 1;
					end
			WRITE : begin
					iocs <= 1;
					iorw <= 0;
					databus_drive <= 8'b01010101;  // Generate random value may be later
					ioaddr <= 2'b00;
					end
			endcase
			end
	end
	
	
endmodule
