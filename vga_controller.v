`timescale 1ns / 1ps
module vga_controller(
	input reset, 
	input clk, 
	output VGA_RED,
	output VGA_GREEN,
	output VGA_BLUE,
	output reg VGA_HSYNC, //Decoded count_pixel values generate the VGA_HSYNC signal which corresponds to a monitor’s line retracing time. 
	//This signals timing is predefined within manufacturers specifications and various timings correspond to different refresh rates and resolutions
	output reg VGA_VSYNC);//Same as the above but corresponding to a monitor's entire frame retracing time (from the bottom left to the top right pixel)




reg [1:0] count_clocks=0; 
always @(posedge clk, posedge reset)
	if (reset) 
		count_clocks<=0;
	else 
		count_clocks<=count_clocks+1'b1;	
wire pixel_signal=count_clocks[0];//A clock that corresponds to the time available to display one pixel of information. 
//50Mhz clock cycles  necessary to move to the next pixel:
//1/60= 521HYNC SIGNALS = 521*800 pixel signals ->  pixel period= 1/(521*800*60) = 1.99936020473clocks of a 50mhz clock
		//We are assumming a resync is taking place inside the monitor itself everytime the monitor needs to do a Horizontal retrace 
		//(x800 pixel signals). The resulting error  0.511836216=25.6% after x800 pixel cycles is not high enought to skew the monitors
		// sampling from the middle of the incoming pixel signal's period to the wrong pixel.

												////For better accuracy the code below should be used instead, (lower error)
												//  clk instance_name   (
												//    .CLK_IN1(clk),      // IN
												//    .CLK_OUT1(pixel_signal));    // OUT

reg [9:0] count_pixels=0;   //A counter clocked by the pixel clock controls the horizontal timing. Decoded counter
// values generate the VGA_HSYNC signal. This counter tracks the current pixel display location on a given row. 

reg [9:0] count_lines=0;	 //count_pixels controls the horizontal timing. Decoded counter values generate the VGA_HSYNC 
//signal. Count_lines is a separate counter that tracks vertical timing. The vertical-sync counter increments with each 
//HS pulse and decoded values generate the VS signal. This counter tracks the current display row.	

reg [20:0] virtual_out=0;  //Count_lines and count_pixels ,together with the logic that defines the states where pixels are rotated,
//are continuously running counters that form the address that is used by the video display buffer (the BRAM modules initialized in part 1). 
//the register above is not used in the current spartan3 implementation because of hardware limitations
reg [13:0] scaled_image_out=0; //Replacement of virtual_out register. 
//Becase the internal memory of the fPGA is insufficient to support the full 640x480 resolution, it is necessary 
//to slow down the address rotation by repeating the same addresses through  the BRAM
reg [2:0] scaling_horizontal_counter=0;//Controls horizontal scalling. The same horizontal pixel inside the VRAM is displayed 4 consequetive times
reg [2:0] scaling_vertical_counter=0;//Controls vertical scalling. The same vertical pixel line inside the VRAM is displayed 4 consequetive times


vga_testImage_BRAM_initialization_RED bram1(clk,scaled_image_out,1'b1,VGA_RED); //BRAM instances:  Utilizing the bulk memory necessary for storing the image.
vga_testImage_BRAM_initialization_GREEN bram2(clk,scaled_image_out,1'b1,VGA_BLUE); //12288 out of the 16383 bits provided by a  the 16Kx1 preconfigured BRAM block 
vga_testImage_BRAM_initialization_BLUE bram3(clk,scaled_image_out,1'b1,VGA_GREEN); //are used to store the pixel value for each one of the 3 colours (Red , Green, Blue). 
//3 BRAM modules contain the preinitialized memory representing the test image. The instances of those modules take as input the current address
// that the active pixel is corresponding to and feed the data directly to the Red, Green, Blue  Fpga pins. The blocks utilizing the VRAM are permanently
// activated and their data are static





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

//state machine. 
//Count pixel 0 - 95  State0  signal HSYNC=0
//Count pixel 96 - 143 State1 signal HSYNC=1
//Count pixel 144- 783 State2 signal HSYNC=1 , rotates pixels from memory into VGA_RED,VGA_BLUE,VGA_GREEN 
//Count pixel 784-799 State3 signal HSYNC=1

//VGA_HSYNC Signal timings and memory writing
always @(posedge pixel_signal, posedge reset) 
	if (reset) 						  //RESET
		VGA_HSYNC<=1;
	else if (count_pixels<=95)   //PULSE WIDTH
		VGA_HSYNC<=0;     
	else if (count_pixels>=144 & count_pixels<=783) //DISPLAY TIME //96+48=144//
		VGA_HSYNC<=1;									
	else 						//BACK PORCH&FRONT PORCH
		VGA_HSYNC<=1;     
	
	//VGA_VSYNC Signal timings and memory writing		
always @(posedge pixel_signal, posedge reset)
	if (reset) 
		begin
			VGA_VSYNC<=1;
			virtual_out<=0;
		end
	else if (count_lines==0 | count_lines==1)			//PULSE WIDTH
			VGA_VSYNC<=0;	
	else if (count_lines>=31 & count_lines<=510) 
		begin														//DISPLAY TIME
			VGA_VSYNC<=1;
			if (count_pixels>=144 & count_pixels<=783)
				begin 
					virtual_out<=(count_pixels-144)+(count_lines-31)*640;  ///VERILOG DOESNT SUPPORT DIVISION FUNCTION. 
					//The scalling problem could be really easily solved just by dividing with 5 and not taking account the result as the input vertical and horizontal coordinates
				end
			else
				begin  //OUT OF SYNC SIGNAL: STATE INSIDE BACK PORCH&FRONT PORCH OF HSYNC SIGNAL
					virtual_out<=0;
				end
		end
	else 			
		begin   //OUT OF SYNC SIGNAL: STATE INSIDE BACK PORCH&FRONT PORCH OF VSYNC SIGNAL
			VGA_VSYNC<=1;
		end
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//Image up-scaling implementation: 	
always @(posedge pixel_signal, posedge reset)
		if (reset) 
			begin
				scaled_image_out=0;
				scaling_horizontal_counter=0;
				scaling_vertical_counter=0;
			end
		else if (count_lines>=31 & count_lines<=510)
			begin
				if (count_pixels>=145 & count_pixels<=784)
					begin
						if (scaling_horizontal_counter==4)
							begin
								scaled_image_out=scaled_image_out+1;
								scaling_horizontal_counter=0;
							end
						else 
								scaling_horizontal_counter=scaling_horizontal_counter+1;
					end
				else if (count_pixels==799)
					begin 
							if (scaling_vertical_counter!=4)
								begin
									scaling_vertical_counter=scaling_vertical_counter+1;
									scaled_image_out=scaled_image_out-128;
								end
							else 
								scaling_vertical_counter=0;
					end
				else
					scaling_horizontal_counter=0;
			end
		else
			begin
				scaling_vertical_counter=0;
				scaled_image_out=0;
			end
///////////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule


