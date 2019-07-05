`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:38:29 01/14/2019
// Design Name:   main
// Module Name:   C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/main_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module main_tb;

	// Inputs
	reg clk1_in;
	reg MISO1_A;
	reg MISO2_A;
	reg MISO1_B;
	reg MISO2_B;
	reg MISO1_C;
	reg MISO2_C;
	reg MISO1_D;
	reg MISO2_D;
	reg MISO1_E;
	reg MISO2_E;
	reg MISO1_F;
	reg MISO2_F;
	reg MISO1_G;
	reg MISO2_G;
	reg MISO1_H;
	reg MISO2_H;
	reg [7:0] hi_in;
	reg ADC_DOUT_1;
	reg ADC_DOUT_2;
	reg ADC_DOUT_3;
	reg ADC_DOUT_4;
	reg ADC_DOUT_5;
	reg ADC_DOUT_6;
	reg ADC_DOUT_7;
	reg ADC_DOUT_8;
	reg TTL_in_direct_1;
	reg TTL_in_direct_2;
	reg TTL_in_serial;
	reg TTL_in_serial_exp;
	reg expander_detect;
	reg expander_ID_1;
	reg [3:0] board_mode;
	reg LVDS_1_p;
	reg LVDS_1_n;
	reg LVDS_2_p;
	reg LVDS_2_n;
	reg LVDS_3_p;
	reg LVDS_3_n;

	// Outputs
	wire [12:0] mcb3_dram_a;
	wire [2:0] mcb3_dram_ba;
	wire mcb3_dram_ras_n;
	wire mcb3_dram_cas_n;
	wire mcb3_dram_we_n;
	wire mcb3_dram_odt;
	wire mcb3_dram_cke;
	wire mcb3_dram_dm;
	wire mcb3_dram_udm;
	wire mcb3_dram_ck;
	wire mcb3_dram_ck_n;
	wire mcb3_dram_cs_n;
	wire CS_b_A;
	wire SCLK_A;
	wire MOSI1_A;
	wire MOSI2_A;
	wire CS_b_B;
	wire SCLK_B;
	wire MOSI1_B;
	wire MOSI2_B;
	wire CS_b_C;
	wire SCLK_C;
	wire MOSI1_C;
	wire MOSI2_C;
	wire CS_b_D;
	wire SCLK_D;
	wire MOSI1_D;
	wire MOSI2_D;
	wire CS_b_E;
	wire SCLK_E;
	wire MOSI1_E;
	wire MOSI2_E;
	wire CS_b_F;
	wire SCLK_F;
	wire MOSI1_F;
	wire MOSI2_F;
	wire CS_b_G;
	wire SCLK_G;
	wire MOSI1_G;
	wire MOSI2_G;
	wire CS_b_H;
	wire SCLK_H;
	wire MOSI1_H;
	wire MOSI2_H;
	wire [7:0] SPI_port_LEDs;
	wire [1:0] hi_out;
	wire i2c_sda;
	wire i2c_scl;
	wire hi_muxsel;
	wire [7:0] led;
	wire DAC_SYNC;
	wire DAC_SCLK;
	wire DAC_DIN_1;
	wire DAC_DIN_2;
	wire DAC_DIN_3;
	wire DAC_DIN_4;
	wire DAC_DIN_5;
	wire DAC_DIN_6;
	wire DAC_DIN_7;
	wire DAC_DIN_8;
	wire ADC_CS;
	wire ADC_SCLK;
	wire serial_LOAD;
	wire serial_CLK;
	wire spare_1;
	wire [15:0] TTL_out_direct;
	wire sample_CLK_out;
	wire mark_out;
	wire [2:0] status_LEDs;
	wire LVDS_4_p;
	wire LVDS_4_n;
	wire I2C_SDA;
	wire I2C_SCK;

	// Bidirs
	wire [15:0] mcb3_dram_dq;
	wire mcb3_dram_udqs;
	wire mcb3_dram_udqs_n;
	wire mcb3_rzq;
	wire mcb3_zio;
	wire mcb3_dram_dqs;
	wire mcb3_dram_dqs_n;
	wire [15:0] hi_inout;
	wire hi_aa;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.clk1_in(clk1_in), 
		.mcb3_dram_dq(mcb3_dram_dq), 
		.mcb3_dram_a(mcb3_dram_a), 
		.mcb3_dram_ba(mcb3_dram_ba), 
		.mcb3_dram_ras_n(mcb3_dram_ras_n), 
		.mcb3_dram_cas_n(mcb3_dram_cas_n), 
		.mcb3_dram_we_n(mcb3_dram_we_n), 
		.mcb3_dram_odt(mcb3_dram_odt), 
		.mcb3_dram_cke(mcb3_dram_cke), 
		.mcb3_dram_dm(mcb3_dram_dm), 
		.mcb3_dram_udqs(mcb3_dram_udqs), 
		.mcb3_dram_udqs_n(mcb3_dram_udqs_n), 
		.mcb3_rzq(mcb3_rzq), 
		.mcb3_zio(mcb3_zio), 
		.mcb3_dram_udm(mcb3_dram_udm), 
		.mcb3_dram_dqs(mcb3_dram_dqs), 
		.mcb3_dram_dqs_n(mcb3_dram_dqs_n), 
		.mcb3_dram_ck(mcb3_dram_ck), 
		.mcb3_dram_ck_n(mcb3_dram_ck_n), 
		.mcb3_dram_cs_n(mcb3_dram_cs_n), 
		.CS_b_A(CS_b_A), 
		.SCLK_A(SCLK_A), 
		.MOSI1_A(MOSI1_A), 
		.MOSI2_A(MOSI2_A), 
		.MISO1_A(MISO1_A), 
		.MISO2_A(MISO2_A), 
		.CS_b_B(CS_b_B), 
		.SCLK_B(SCLK_B), 
		.MOSI1_B(MOSI1_B), 
		.MOSI2_B(MOSI2_B), 
		.MISO1_B(MISO1_B), 
		.MISO2_B(MISO2_B), 
		.CS_b_C(CS_b_C), 
		.SCLK_C(SCLK_C), 
		.MOSI1_C(MOSI1_C), 
		.MOSI2_C(MOSI2_C), 
		.MISO1_C(MISO1_C), 
		.MISO2_C(MISO2_C), 
		.CS_b_D(CS_b_D), 
		.SCLK_D(SCLK_D), 
		.MOSI1_D(MOSI1_D), 
		.MOSI2_D(MOSI2_D), 
		.MISO1_D(MISO1_D), 
		.MISO2_D(MISO2_D), 
		.CS_b_E(CS_b_E), 
		.SCLK_E(SCLK_E), 
		.MOSI1_E(MOSI1_E), 
		.MOSI2_E(MOSI2_E), 
		.MISO1_E(MISO1_E), 
		.MISO2_E(MISO2_E), 
		.CS_b_F(CS_b_F), 
		.SCLK_F(SCLK_F), 
		.MOSI1_F(MOSI1_F), 
		.MOSI2_F(MOSI2_F), 
		.MISO1_F(MISO1_F), 
		.MISO2_F(MISO2_F), 
		.CS_b_G(CS_b_G), 
		.SCLK_G(SCLK_G), 
		.MOSI1_G(MOSI1_G), 
		.MOSI2_G(MOSI2_G), 
		.MISO1_G(MISO1_G), 
		.MISO2_G(MISO2_G), 
		.CS_b_H(CS_b_H), 
		.SCLK_H(SCLK_H), 
		.MOSI1_H(MOSI1_H), 
		.MOSI2_H(MOSI2_H), 
		.MISO1_H(MISO1_H), 
		.MISO2_H(MISO2_H), 
		.SPI_port_LEDs(SPI_port_LEDs), 
		.hi_in(hi_in), 
		.hi_out(hi_out), 
		.hi_inout(hi_inout), 
		.hi_aa(hi_aa), 
		.i2c_sda(i2c_sda), 
		.i2c_scl(i2c_scl), 
		.hi_muxsel(hi_muxsel), 
		.led(led), 
		.DAC_SYNC(DAC_SYNC), 
		.DAC_SCLK(DAC_SCLK), 
		.DAC_DIN_1(DAC_DIN_1), 
		.DAC_DIN_2(DAC_DIN_2), 
		.DAC_DIN_3(DAC_DIN_3), 
		.DAC_DIN_4(DAC_DIN_4), 
		.DAC_DIN_5(DAC_DIN_5), 
		.DAC_DIN_6(DAC_DIN_6), 
		.DAC_DIN_7(DAC_DIN_7), 
		.DAC_DIN_8(DAC_DIN_8), 
		.ADC_CS(ADC_CS), 
		.ADC_SCLK(ADC_SCLK), 
		.ADC_DOUT_1(ADC_DOUT_1), 
		.ADC_DOUT_2(ADC_DOUT_2), 
		.ADC_DOUT_3(ADC_DOUT_3), 
		.ADC_DOUT_4(ADC_DOUT_4), 
		.ADC_DOUT_5(ADC_DOUT_5), 
		.ADC_DOUT_6(ADC_DOUT_6), 
		.ADC_DOUT_7(ADC_DOUT_7), 
		.ADC_DOUT_8(ADC_DOUT_8), 
		.TTL_in_direct_1(TTL_in_direct_1), 
		.TTL_in_direct_2(TTL_in_direct_2), 
		.serial_LOAD(serial_LOAD), 
		.serial_CLK(serial_CLK), 
		.TTL_in_serial(TTL_in_serial), 
		.TTL_in_serial_exp(TTL_in_serial_exp), 
		.spare_1(spare_1), 
		.expander_detect(expander_detect), 
		.expander_ID_1(expander_ID_1), 
		.TTL_out_direct(TTL_out_direct), 
		.sample_CLK_out(sample_CLK_out), 
		.mark_out(mark_out), 
		.status_LEDs(status_LEDs), 
		.board_mode(board_mode), 
		.LVDS_1_p(LVDS_1_p), 
		.LVDS_1_n(LVDS_1_n), 
		.LVDS_2_p(LVDS_2_p), 
		.LVDS_2_n(LVDS_2_n), 
		.LVDS_3_p(LVDS_3_p), 
		.LVDS_3_n(LVDS_3_n), 
		.LVDS_4_p(LVDS_4_p), 
		.LVDS_4_n(LVDS_4_n), 
		.I2C_SDA(I2C_SDA), 
		.I2C_SCK(I2C_SCK)
	);

	initial begin
		// Initialize Inputs
		clk1_in = 0;
		MISO1_A = 0;
		MISO2_A = 0;
		MISO1_B = 0;
		MISO2_B = 0;
		MISO1_C = 0;
		MISO2_C = 0;
		MISO1_D = 0;
		MISO2_D = 0;
		MISO1_E = 0;
		MISO2_E = 0;
		MISO1_F = 0;
		MISO2_F = 0;
		MISO1_G = 0;
		MISO2_G = 0;
		MISO1_H = 0;
		MISO2_H = 0;
		hi_in = 0;
		ADC_DOUT_1 = 0;
		ADC_DOUT_2 = 0;
		ADC_DOUT_3 = 0;
		ADC_DOUT_4 = 0;
		ADC_DOUT_5 = 0;
		ADC_DOUT_6 = 0;
		ADC_DOUT_7 = 0;
		ADC_DOUT_8 = 0;
		TTL_in_direct_1 = 0;
		TTL_in_direct_2 = 0;
		TTL_in_serial = 0;
		TTL_in_serial_exp = 0;
		expander_detect = 0;
		expander_ID_1 = 0;
		board_mode = 0;
		LVDS_1_p = 0;
		LVDS_1_n = 0;
		LVDS_2_p = 0;
		LVDS_2_n = 0;
		LVDS_3_p = 0;
		LVDS_3_n = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

