`timescale 1ns / 1ps
module vga_controller(
input reset, 
input clk, 
output VGA_RED,
output VGA_GREEN,
output VGA_BLUE,
output VGA_HSYNC, 
output VGA_VSYNC);


//language templates BRAM module

//init BRAM -> test image

	//Pixel signal every time the next pixel cycle comes.  (how many clocks are necessary to move to the next pixel?)
	// 1/60= 521HYNC SIGNALS = 521*800 pixel signals ->  pixel period= 1/(521*800*60) = 1.99936020473clocks of a 50mhz clock

//HSYNC counting 800pixels
	//dont show pixels for 16 signals
	// keep HSYNC 0 for 96 signals 
	//return it up for 48signals
	//show pixels again for the next 640 signals
	//dont show pixels for 16 signals
	
//VSYNC counting 521HSYNC signal, signal on 480 HSYNC signals {0 all colours} keep 0 for 2 signals

endmodule


