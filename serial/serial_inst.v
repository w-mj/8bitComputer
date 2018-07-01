	serial u0 (
		.sysclk        (<connected-to-sysclk>),        //              clock_sink.clk
		.nreset        (<connected-to-nreset>),        //        clock_sink_reset.reset_n
		.mosi          (<connected-to-mosi>),          //                export_0.mosi
		.nss           (<connected-to-nss>),           //                        .nss
		.miso          (<connected-to-miso>),          //                        .miso
		.sclk          (<connected-to-sclk>),          //                        .sclk
		.stsourceready (<connected-to-stsourceready>), // avalon_streaming_source.ready
		.stsourcevalid (<connected-to-stsourcevalid>), //                        .valid
		.stsourcedata  (<connected-to-stsourcedata>),  //                        .data
		.stsinkvalid   (<connected-to-stsinkvalid>),   //   avalon_streaming_sink.valid
		.stsinkdata    (<connected-to-stsinkdata>),    //                        .data
		.stsinkready   (<connected-to-stsinkready>)    //                        .ready
	);

