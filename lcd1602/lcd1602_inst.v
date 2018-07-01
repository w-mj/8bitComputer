	lcd1602 u0 (
		.clk         (<connected-to-clk>),         //                clk.clk
		.reset       (<connected-to-reset>),       //              reset.reset
		.address     (<connected-to-address>),     //   avalon_lcd_slave.address
		.chipselect  (<connected-to-chipselect>),  //                   .chipselect
		.read        (<connected-to-read>),        //                   .read
		.write       (<connected-to-write>),       //                   .write
		.writedata   (<connected-to-writedata>),   //                   .writedata
		.readdata    (<connected-to-readdata>),    //                   .readdata
		.waitrequest (<connected-to-waitrequest>), //                   .waitrequest
		.LCD_DATA    (<connected-to-LCD_DATA>),    // external_interface.DATA
		.LCD_ON      (<connected-to-LCD_ON>),      //                   .ON
		.LCD_BLON    (<connected-to-LCD_BLON>),    //                   .BLON
		.LCD_EN      (<connected-to-LCD_EN>),      //                   .EN
		.LCD_RS      (<connected-to-LCD_RS>),      //                   .RS
		.LCD_RW      (<connected-to-LCD_RW>)       //                   .RW
	);

