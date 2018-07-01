
module serial (
	sysclk,
	nreset,
	mosi,
	nss,
	miso,
	sclk,
	stsourceready,
	stsourcevalid,
	stsourcedata,
	stsinkvalid,
	stsinkdata,
	stsinkready);	

	input		sysclk;
	input		nreset;
	input		mosi;
	input		nss;
	inout		miso;
	input		sclk;
	input		stsourceready;
	output		stsourcevalid;
	output	[7:0]	stsourcedata;
	input		stsinkvalid;
	input	[7:0]	stsinkdata;
	output		stsinkready;
endmodule
