/////////////////////////////////////////////////////////////////////////////
//Altera ATPP合作伙伴 至芯科技 携手 特权同学 共同打造 FPGA开发板系列
//工程硬件平台： Altera Cyclone IV FPGA 
//开发套件型号： SF-CY4 特权打造
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供SF-CY4开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
//最新资料下载： http://pan.baidu.com/s/1jGpMIJc
//公                司： 上海或与电子科技有限公司
/////////////////////////////////////////////////////////////////////////////
module VGADriver(
			input clk_25m,	//PLL输出25MHz时钟
			input rst_n,	//复位信号，低电平有效
			input pixel_r, pixel_g, pixel_b,
			output[11: 0] row, colum, 
			output vga_r,	//VGA显示色彩R
			output vga_g,	//VGA显示色彩G
			output vga_b,	//VGA显示色彩B
			output reg vga_hsy,	//VGA显示行同步信号
			output reg vga_vsy	//VGA显示场同步信号
		);

//-----------------------------------------------------------
wire clk;


//-----------------------------------------------------------
//VGA Timing 640*480 & 25MHz & 60Hz
assign clk = clk_25m;
	
parameter VGA_HTT = 12'd800-12'd1;	//Hor Total Time
parameter VGA_HST = 12'd96;		//Hor Sync  Time
parameter VGA_HBP = 12'd48;//+12'd16;		//Hor Back Porch
parameter VGA_HVT = 12'd640;	//Hor Valid Time
parameter VGA_HFP = 12'd16;		//Hor Front Porch

parameter VGA_VTT = 12'd525-12'd1;	//Ver Total Time
parameter VGA_VST = 12'd2;		//Ver Sync Time
parameter VGA_VBP = 12'd33;//-12'd4;		//Ver Back Porch
parameter VGA_VVT = 12'd480;	//Ver Valid Time
parameter VGA_VFP = 12'd10;		//Ver Front Porch

parameter VGA_CORBER = 12'd80;	//8等分做Color bar显示

//-----------------------------------------------------------
	//x和y坐标计数器
reg[11:0] xcnt;
reg[11:0] ycnt;
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) xcnt <= 12'd0;
	else if(xcnt >= VGA_HTT) xcnt <= 12'd0;
	else xcnt <= xcnt+1'b1;

always @(posedge clk or negedge rst_n)
	if(!rst_n) ycnt <= 12'd0;
	else if(xcnt == VGA_HTT) begin
		if(ycnt >= VGA_VTT) ycnt <= 12'd0;
		else ycnt <= ycnt+1'b1;
	end
	else ;
		
//-----------------------------------------------------------
	//行、场同步信号生成
always @(posedge clk or negedge rst_n)
	if(!rst_n) vga_hsy <= 1'b0;
	else if(xcnt < VGA_HST) vga_hsy <= 1'b1;
	else vga_hsy <= 1'b0;
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) vga_vsy <= 1'b0;
	else if(ycnt < VGA_VST) vga_vsy <= 1'b1;
	else vga_vsy <= 1'b0;	
	
//-----------------------------------------------------------	
	//显示有效区域标志信号生成
reg vga_valid;	//显示区域内，该信号高电平

reg[11: 0] row_r, colum_r;
assign row = row_r;
assign colum = colum_r;

always @(posedge clk or negedge rst_n)
	if(!rst_n) vga_valid <= 1'b0;
	else 
		if((xcnt >= (VGA_HST+VGA_HBP)) && (xcnt < (VGA_HST+VGA_HBP+VGA_HVT))
				&& (ycnt >= (VGA_VST+VGA_VBP)) && (ycnt < (VGA_VST+VGA_VBP+VGA_VVT))) begin
		 vga_valid <= 1'b1;
		 colum_r = (xcnt - (VGA_HST+VGA_HBP));
		 row_r = (ycnt - (VGA_VST+VGA_VBP));
		 end
	else vga_valid <= 1'b0;
	
assign vga_r = vga_valid ? pixel_r:1'b0;
assign vga_g = vga_valid ? pixel_g:1'b0;	
assign vga_b = vga_valid ? pixel_b:1'b0;	
	
endmodule

