// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS
// IN THIS FILE.

/******************************************************************************
 *                                                                            *
 * This module read and write data to the 16x2 Character LCD on the DE2       *
 *  Board.                                                                    *
 *                                                                            *
 ******************************************************************************/

module altera_up_character_lcd_communication (
	// Inputs
	clk,
	reset,

	data_in,
	enable,
	rs,
	rw,

	display_on,
	back_light_on,

	// Bidirectionals
	LCD_DATA,

	// Outputs
	LCD_ON,
	LCD_BLON,

	LCD_EN,
	LCD_RS,
	LCD_RW,

	data_out,
	transfer_complete
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

// Timing info for minimum wait between consecutive communications 
//   if using a 50MHz Clk
parameter	CLOCK_CYCLES_FOR_IDLE_STATE		= 7'h7F;	// Minimum 2500 ns
parameter	IC											= 7;		// Number of bits for idle counter
parameter	IDLE_COUNTER_INCREMENT				= 7'h01;

parameter	CLOCK_CYCLES_FOR_OPERATION_STATE	= 3;		// Minimum  40 ns
parameter	CLOCK_CYCLES_FOR_ENABLE_STATE		= 15;		// Minimum 230 ns
parameter	CLOCK_CYCLES_FOR_HOLD_STATE		= 1;		// Minimum  10 ns
parameter	SC											= 4;		// Number of bits for states counter
parameter	COUNTER_INCREMENT						= 4'h1;

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input						clk;
input						reset;

input			[ 7: 0]	data_in;
input						rs;
input						rw;
input						enable;

input						display_on;
input						back_light_on;

// Bidirectionals
inout			[ 7: 0]	LCD_DATA;

// Outputs
output reg				LCD_ON;
output reg				LCD_BLON;

output reg				LCD_EN;
output reg				LCD_RS;
output reg				LCD_RW;

output reg	[ 7: 0]	data_out;			// Stores data read from the LCD
output reg				transfer_complete;	// Indicates the end of the transfer

/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/
// states
parameter	LCD_STATE_4_IDLE			= 3'h4,
				LCD_STATE_0_OPERATION	= 3'h0,
				LCD_STATE_1_ENABLE		= 3'h1,
				LCD_STATE_2_HOLD			= 3'h2,
				LCD_STATE_3_END			= 3'h3;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires

// Internal Registers
reg			[ 7: 0]	data_to_lcd;

reg			[IC: 1]	idle_counter;
reg			[SC: 1]	state_0_counter;
reg			[SC: 1]	state_1_counter;
reg			[SC: 1]	state_2_counter;

// State Machine Registers
reg			[ 2: 0]	ns_lcd;
reg			[ 2: 0]	s_lcd;

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/

always @(posedge clk)
begin
	if (reset)
		s_lcd <= LCD_STATE_4_IDLE;
	else
		s_lcd <= ns_lcd;
end

always @(*)
begin
	ns_lcd = LCD_STATE_4_IDLE;

   case (s_lcd)
	LCD_STATE_4_IDLE:
		begin
			if ((idle_counter == CLOCK_CYCLES_FOR_IDLE_STATE) & enable)
				ns_lcd = LCD_STATE_0_OPERATION;
			else
				ns_lcd = LCD_STATE_4_IDLE;
		end
	LCD_STATE_0_OPERATION:
		begin
			if (state_0_counter == CLOCK_CYCLES_FOR_OPERATION_STATE)
				ns_lcd = LCD_STATE_1_ENABLE;
			else
				ns_lcd = LCD_STATE_0_OPERATION;
		end
	LCD_STATE_1_ENABLE:
		begin
			if (state_1_counter == CLOCK_CYCLES_FOR_ENABLE_STATE)
				ns_lcd = LCD_STATE_2_HOLD;
			else
				ns_lcd = LCD_STATE_1_ENABLE;
		end
	LCD_STATE_2_HOLD:
		begin
			if (state_2_counter == CLOCK_CYCLES_FOR_HOLD_STATE)
				ns_lcd = LCD_STATE_3_END;
			else
				ns_lcd = LCD_STATE_2_HOLD;
		end
	LCD_STATE_3_END:
		begin
			if (enable == 1'b0)
				ns_lcd = LCD_STATE_4_IDLE;
			else
				ns_lcd = LCD_STATE_3_END;
		end
	default:
		begin
			ns_lcd = LCD_STATE_4_IDLE;
		end
	endcase
end


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge clk)
begin
	if (reset)
	begin
		LCD_ON 	<= 1'b0;
		LCD_BLON <= 1'b0;
	end
	else
	begin
		LCD_ON 	<= display_on;
		LCD_BLON <= back_light_on;
	end
end

always @(posedge clk)
begin
	if (reset)
	begin
		LCD_EN				<= 1'b0;
		LCD_RS				<= 1'b0;
		LCD_RW				<= 1'b0;
		data_out				<= 8'h00;
		transfer_complete	<= 1'b0;
	end
	else
	begin
		if (s_lcd == LCD_STATE_1_ENABLE)
			LCD_EN		<= 1'b1;
		else
			LCD_EN		<= 1'b0;

		if (s_lcd == LCD_STATE_4_IDLE)
		begin
			LCD_RS		<= rs;
			LCD_RW		<= rw;
			
			data_to_lcd <= data_in;
		end

		if (s_lcd == LCD_STATE_1_ENABLE)
			data_out	<= LCD_DATA;

		if (s_lcd == LCD_STATE_3_END)
			transfer_complete	<= 1'b1;
		else
			transfer_complete	<= 1'b0;
	end
end

always @(posedge clk)
begin
	if (reset)
		idle_counter <= {IC{1'b0}};
	else if (s_lcd == LCD_STATE_4_IDLE)
		idle_counter <= idle_counter + IDLE_COUNTER_INCREMENT;
	else
		idle_counter <= {IC{1'b0}};
end

always @(posedge clk)
begin
	if (reset)
	begin
		state_0_counter <= {SC{1'b0}};
		state_1_counter <= {SC{1'b0}};
		state_2_counter <= {SC{1'b0}};
	end
	else
	begin
		if (s_lcd == LCD_STATE_0_OPERATION)
			state_0_counter <= state_0_counter + COUNTER_INCREMENT;
		else
			state_0_counter <= {SC{1'b0}};

		if (s_lcd == LCD_STATE_1_ENABLE)
			state_1_counter <= state_1_counter + COUNTER_INCREMENT;
		else
			state_1_counter <= {SC{1'b0}};

		if (s_lcd == LCD_STATE_2_HOLD)
			state_2_counter <= state_2_counter + COUNTER_INCREMENT;
		else
			state_2_counter <= {SC{1'b0}};
	end
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign LCD_DATA	= 
		(((s_lcd == LCD_STATE_1_ENABLE) ||
		  (s_lcd == LCD_STATE_2_HOLD)) &&
		  (LCD_RW == 1'b0)) ? data_to_lcd : 8'hzz;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/


endmodule

