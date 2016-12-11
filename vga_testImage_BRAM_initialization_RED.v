`timescale 1ns / 1ps

module vga_testImage_BRAM_initialization_RED(
	input CLK,
	input [13:0] ADDR,
	input EN,
	output DO);
   // RAMB16_S1: 16kx1 Single-Port RAM
   //            Spartan-3E
   // Xilinx HDL Language Template, version 14.7
   RAMB16_S1 #(
      .INIT(1'b0),  // Value of output RAM registers at startup
      .SRVAL(1'b0), // Output value upon SSR assertion
      .WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

      // The forllowing INIT_xx declarations specify the initial contents of the RAM
      // Address 0 to 4095
      .INIT_00(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_01(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_02(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_03(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_04(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_05(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_06(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_07(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_08(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_09(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_0A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_0B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_0D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_0F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      // Address 4096 to 8191
      .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_11(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_13(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_15(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_17(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_19(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      // Address 8192 to 12287
      .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_21(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_23(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
      .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_25(256'hffffff000000000000ffffffffffff000000000000ffffffffffffffffffffff),
      .INIT_26(256'hffffff000000000000000000ffffff0000000000000000000000000000000000),
      .INIT_27(256'hffffff000000000000ffffffffffff000000000000ffffffffffffffffffffff),
      .INIT_28(256'hffffff000000000000000000ffffff0000000000000000000000000000000000),
      .INIT_29(256'hffffff000000000000ffffffffffff000000000000ffffffffffffffffffffff),
      .INIT_2A(256'hffffff000000000000000000ffffff0000000000000000000000000000000000),
      .INIT_2B(256'hffffff000000000000ffffffffffff000000000000ffffffffffffffffffffff),
      .INIT_2C(256'hffffff000000000000000000ffffff0000000000000000000000000000000000),
      .INIT_2D(256'hffffff000000000000ffffffffffff000000000000ffffffffffffffffffffff),
      .INIT_2E(256'hffffff000000000000000000ffffff0000000000000000000000000000000000),
      .INIT_2F(256'hffffff000000000000ffffffffffff000000000000ffffffffffffffffffffff),
      // Address 12288 to 16383
      .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000)
   ) RAMB16_S1_inst (
      .DO(DO),      // 1-bit Data Output
      .ADDR(ADDR),  // 14-bit Address Input
      .CLK(CLK),    // Clock
      .DI(DI),      // 1-bit Data Input
      .EN(EN),      // RAM Enable Input
      .SSR(SSR),    // Synchronous Set/Reset Input
      .WE(WE)       // Write Enable Input
   );

  // End of RAMB16_S1_inst instantiation


endmodule
