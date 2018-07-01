
module lcd1602 (
	clk,
	reset,
	address,
	chipselect,
	read,
	write,
	writedata,
	readdata,
	waitrequest,
	LCD_DATA,
	LCD_ON,
	LCD_BLON,
	LCD_EN,
	LCD_RS,
	LCD_RW);	

	input		clk;
	input		reset;
	input		address;
	input		chipselect;
	input		read;
	input		write;
	input	[7:0]	writedata;
	output	[7:0]	readdata;
	output		waitrequest;
	inout	[7:0]	LCD_DATA;
	output		LCD_ON;
	output		LCD_BLON;
	output		LCD_EN;
	output		LCD_RS;
	output		LCD_RW;
endmodule
