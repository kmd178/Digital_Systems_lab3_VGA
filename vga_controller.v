`timescale 1ns / 1ps
module vga_controller(
	input reset, 
	input clk, 
	output reg VGA_RED,
	output reg VGA_GREEN,
	output reg VGA_BLUE,
	output reg VGA_HSYNC, 
	output reg VGA_VSYNC);


////For better accuracy 
//  clk instance_name   (
//    .CLK_IN1(clk),      // IN
//    .CLK_OUT1(pixel_signal));    // OUT

reg [9:0] count_pixels=0;
reg [9:0] count_lines=0;

reg [1:0] count_clocks=0; //every 2 clocks
always @(posedge clk, posedge reset)
	if (reset) 
		count_clocks<=0;
	else 
		count_clocks<=count_clocks+1'b1;	
wire pixel_signal=count_clocks[0];
//////////////////////
always @(posedge pixel_signal, posedge reset)
	if (reset) 
		count_pixels<=0;
	else if (count_pixels==799)  //RESTART FROM FIRST PIXEL OF THE CORRESPONTING NEXT LINE
		count_pixels<=0;	
	else								  //NEW PIXEL
		count_pixels<=count_pixels+1'b1;
		
always @(posedge pixel_signal, posedge reset)
	if (reset) 
		count_lines<=0;
	else if (count_lines==520 & count_pixels==799)   ///RESTART FROM FIRST LINE
		count_lines<=0;
	else if (count_pixels==799)  ///NEW LINE PROCCESSING THE LAST PIXEL
		count_lines<=count_lines+1'b1;
		
reg Change_pixel_flag=1; 
//state machine. 
//Count pixel 0 - 95  State0  signal HSYNC=0
//Count pixel 96 - 143 State1 signal HSYNC=1
//Count pixel 144- 783 State2 signal HSYNC=1 , rotates pixels from memory into VGA_RED,VGA_BLUE,VGA_GREEN 
//Count pixel 784-799 State3 signal HSYNC=1

//VGA_HSYNC Signal timings and memory writing
always @(posedge pixel_signal, posedge reset) 
	if (reset) 
		VGA_HSYNC<=1;
	else if (count_pixels<=95)   //PULSE WIDTH
		VGA_HSYNC<=0;     
	else if (count_pixels>=144 & count_pixels<=783) //DISPLAY TIME //96+48=144
		begin
			VGA_HSYNC<=1;
			Change_pixel_flag<=1;
		end
	else 
		begin						//BACK PORCH&FRONT PORCH
			VGA_HSYNC<=1;
			Change_pixel_flag<=0;
		end
		 //Cannot alter pixels

//VGA_VSYNC Signal timings and memory writing		
always @(posedge pixel_signal, posedge reset)
	if (reset) 
			VGA_VSYNC<=1;
	else if (count_lines==1 | count_lines==0)
			VGA_VSYNC<=0;	
	else if (count_lines>=31 & count_lines<=510) 
		begin
			VGA_VSYNC<=1;
			if (Change_pixel_flag)
				begin 
					VGA_RED<=1;
					VGA_BLUE<=0;
					VGA_GREEN<=0;
					//memory[count_pixels-16]<=count_pixels+1'b1;
				end
		end
	else 
		begin   //OUT OF SYNC SIGNAL
			VGA_VSYNC<=1;
			VGA_RED<=1;
			VGA_BLUE<=0;
			VGA_GREEN<=0;
		end
			//Cannot alter pixels


//Pixel signal every 2 clocks //
	//Pixel signal every time the next pixel cycle comes.  (how many clocks are necessary to move to the next pixel?)
	// 1/60= 521HYNC SIGNALS = 521*800 pixel signals ->  pixel period= 1/(521*800*60) = 1.99936020473clocks of a 50mhz clock
	// we are assumming a resync is taking place inside the monitor itself everytime monitor needs
   //	to do a Horizontal retrace (x800 pixel signals) the  0.511836216=25.6% error is not enought to skew the monitors sampling
	//from the middle of the income pixel signal's period to the wrong pixel 

//HSYNC counting 800pixels
	//dont show pixels for 16 signals
	// keep HSYNC 0 for 96 signals 
	//return it up for 48signals
	//show pixels again for the next 640 signals
	//dont show pixels for 16 signals
	
//VSYNC counting 521HSYNC signal, signal on 480 HSYNC signals {0 all colours} keep 0 for 2 signals

endmodule


