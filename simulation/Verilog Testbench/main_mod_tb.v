`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:17:09 01/25/2019
// Design Name:   main_reduced
// Module Name:   C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/main_mod_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main_reduced
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module main_mod_tb;

	// Inputs
	reg reset;
	reg dataclk;
	reg [15:0] ampl_to_DAC;
	reg SPI_start;
	reg [15:0] DAC_start_win_1;
	reg [15:0] DAC_start_win_2;
	reg [15:0] DAC_start_win_3;
	reg [15:0] DAC_start_win_4;
	reg [15:0] DAC_start_win_5;
	reg [15:0] DAC_start_win_6;
	reg [15:0] DAC_start_win_7;
	reg [15:0] DAC_start_win_8;
	reg [15:0] DAC_stop_win_1;
	reg [15:0] DAC_stop_win_2;
	reg [15:0] DAC_stop_win_3;
	reg [15:0] DAC_stop_win_4;
	reg [15:0] DAC_stop_win_5;
	reg [15:0] DAC_stop_win_6;
	reg [15:0] DAC_stop_win_7;
	reg [15:0] DAC_stop_win_8;
	reg [15:0] DAC_stop_max;
	reg [7:0] DAC_edge_type;
	reg [15:0] HPF_coefficient;
	reg HPF_en;
	reg [15:0] DAC_sequencer_1;
	reg [15:0] DAC_sequencer_2;
	reg [15:0] DAC_sequencer_3;
	reg [15:0] DAC_sequencer_4;
	reg [15:0] DAC_sequencer_5;
	reg [15:0] DAC_sequencer_6;
	reg [15:0] DAC_sequencer_7;
	reg [15:0] DAC_sequencer_8;
	reg [7:0] DAC_sequencer_en;
	reg [7:0] DAC_en;
	reg [2:0] DAC_gain;
	reg [6:0] DAC_noise_suppress;
	reg [15:0] DAC_thrsh_1;
	reg [15:0] DAC_thrsh_2;
	reg [15:0] DAC_thrsh_3;
	reg [15:0] DAC_thrsh_4;
	reg [15:0] DAC_thrsh_5;
	reg [15:0] DAC_thrsh_6;
	reg [15:0] DAC_thrsh_7;
	reg [15:0] DAC_thrsh_8;
	reg [7:0] DAC_thrsh_pol;
	reg DAC_reref_mode;
	reg [7:0] DAC_input_is_ref;
	reg [15:0] DAC_reref_register;
	reg DAC_fsm_mode;

	// Outputs
	wire [7:0] DAC_thresh_out;
	wire [7:0] DAC_SYNC;
	wire [7:0] DAC_SCLK;
	wire [7:0] DAC_DIN;
	wire [31:0] fsm_window_state;
	wire [15:0] DAC_output_register_1;
	wire [15:0] DAC_output_register_2;
	wire [15:0] DAC_output_register_3;
	wire [15:0] DAC_output_register_4;
	wire [15:0] DAC_output_register_5;
	wire [15:0] DAC_output_register_6;
	wire [15:0] DAC_output_register_7;
	wire [15:0] DAC_output_register_8;
	wire [31:0] main_state;
	wire sample_CLK_out;
	wire [5:0] channel;
	wire [15:0] DAC_register_1;
	wire [15:0] DAC_register_2;
	wire [15:0] DAC_register_3;
	wire [15:0] DAC_register_4;
	wire [15:0] DAC_register_5;
	wire [15:0] DAC_register_6;
	wire [15:0] DAC_register_7;
	wire [15:0] DAC_register_8;

// Additional
	integer f_DAC_out, f_fsm_window_state, count;
	parameter WIDTH = 6000001;
	reg [15:0] data_stored [0:WIDTH-1]; //200001 16-bits words is the length of raw_data.txt

	// Instantiate the Unit Under Test (UUT)
	main_reduced uut (
		.reset(reset), 
		.dataclk(dataclk), 
		.ampl_to_DAC(ampl_to_DAC), 
		.SPI_start(SPI_start), 
		.DAC_start_win_1(DAC_start_win_1), 
		.DAC_start_win_2(DAC_start_win_2), 
		.DAC_start_win_3(DAC_start_win_3), 
		.DAC_start_win_4(DAC_start_win_4), 
		.DAC_start_win_5(DAC_start_win_5), 
		.DAC_start_win_6(DAC_start_win_6), 
		.DAC_start_win_7(DAC_start_win_7), 
		.DAC_start_win_8(DAC_start_win_8), 
		.DAC_stop_win_1(DAC_stop_win_1), 
		.DAC_stop_win_2(DAC_stop_win_2), 
		.DAC_stop_win_3(DAC_stop_win_3), 
		.DAC_stop_win_4(DAC_stop_win_4), 
		.DAC_stop_win_5(DAC_stop_win_5), 
		.DAC_stop_win_6(DAC_stop_win_6), 
		.DAC_stop_win_7(DAC_stop_win_7), 
		.DAC_stop_win_8(DAC_stop_win_8), 
		.DAC_stop_max(DAC_stop_max), 
		.DAC_edge_type(DAC_edge_type), 
		.DAC_thresh_out(DAC_thresh_out), 
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.DAC_sequencer_1(DAC_sequencer_1), 
		.DAC_sequencer_2(DAC_sequencer_2), 
		.DAC_sequencer_3(DAC_sequencer_3), 
		.DAC_sequencer_4(DAC_sequencer_4), 
		.DAC_sequencer_5(DAC_sequencer_5), 
		.DAC_sequencer_6(DAC_sequencer_6), 
		.DAC_sequencer_7(DAC_sequencer_7), 
		.DAC_sequencer_8(DAC_sequencer_8), 
		.DAC_sequencer_en(DAC_sequencer_en), 
		.DAC_en(DAC_en), 
		.DAC_gain(DAC_gain), 
		.DAC_noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC), 
		.DAC_SCLK(DAC_SCLK), 
		.DAC_DIN(DAC_DIN), 
		.DAC_thrsh_1(DAC_thrsh_1), 
		.DAC_thrsh_2(DAC_thrsh_2), 
		.DAC_thrsh_3(DAC_thrsh_3), 
		.DAC_thrsh_4(DAC_thrsh_4), 
		.DAC_thrsh_5(DAC_thrsh_5), 
		.DAC_thrsh_6(DAC_thrsh_6), 
		.DAC_thrsh_7(DAC_thrsh_7), 
		.DAC_thrsh_8(DAC_thrsh_8), 
		.DAC_thrsh_pol(DAC_thrsh_pol), 
		.DAC_reref_mode(DAC_reref_mode), 
		.DAC_input_is_ref(DAC_input_is_ref), 
		.DAC_reref_register(DAC_reref_register), 
		.DAC_fsm_mode(DAC_fsm_mode), 
		.fsm_window_state(fsm_window_state), 
		.DAC_output_register_1(DAC_output_register_1), 
		.DAC_output_register_2(DAC_output_register_2), 
		.DAC_output_register_3(DAC_output_register_3), 
		.DAC_output_register_4(DAC_output_register_4), 
		.DAC_output_register_5(DAC_output_register_5), 
		.DAC_output_register_6(DAC_output_register_6), 
		.DAC_output_register_7(DAC_output_register_7), 
		.DAC_output_register_8(DAC_output_register_8), 
		.main_state(main_state), 
		.sample_CLK_out(sample_CLK_out), 
		.channel(channel), 
		.DAC_register_1(DAC_register_1), 
		.DAC_register_2(DAC_register_2), 
		.DAC_register_3(DAC_register_3), 
		.DAC_register_4(DAC_register_4), 
		.DAC_register_5(DAC_register_5), 
		.DAC_register_6(DAC_register_6), 
		.DAC_register_7(DAC_register_7), 
		.DAC_register_8(DAC_register_8)
	);

	initial begin
		// Initialize Inputs
		reset = 1;
		dataclk = 0;
		ampl_to_DAC = 0;
		SPI_start = 1;
		DAC_start_win_1 = 0;
		DAC_start_win_2 = 1;
		DAC_start_win_3 = 5;
		DAC_start_win_4 = 5;
		DAC_start_win_5 = 0;
		DAC_start_win_6 = 0;
		DAC_start_win_7 = 0;
		DAC_start_win_8 = 0;
		DAC_stop_win_1 = 1;
		DAC_stop_win_2 = 7;
		DAC_stop_win_3 = 8;
		DAC_stop_win_4 = 9;
		DAC_stop_win_5 = 0;
		DAC_stop_win_6 = 0;
		DAC_stop_win_7 = 0;
		DAC_stop_win_8 = 0;
		DAC_stop_max = 9;
		DAC_edge_type = 8'b00001110; // 0 is inclusion, 1 exclusion
		HPF_coefficient = 3991; // 3991 is 300Hz/30000kS  //3343 is 250/30000 // 5894 300/2000Hz
		HPF_en = 1;
		DAC_sequencer_1 = 0;
		DAC_sequencer_2 = 0;
		DAC_sequencer_3 = 0;
		DAC_sequencer_4 = 0;
		DAC_sequencer_5 = 0;
		DAC_sequencer_6 = 0;
		DAC_sequencer_7 = 0;
		DAC_sequencer_8 = 0;
		DAC_sequencer_en = 0;
		DAC_en = 8'b00001111;;
		DAC_gain = 0;
		DAC_noise_suppress = 0;
		DAC_thrsh_1 = 32532;//-46
		DAC_thrsh_2 = 32430;//-66
		DAC_thrsh_3 = 32701;//-13
		DAC_thrsh_4 = 32968;//39
		DAC_thrsh_5 = 0;
		DAC_thrsh_6 = 0;
		DAC_thrsh_7 = 0;
		DAC_thrsh_8 = 0;
		DAC_thrsh_pol = 8'b00001000; // 0 if negative threshold
		DAC_reref_mode = 0;
		DAC_input_is_ref = 0;
		DAC_reref_register = 0;
		DAC_fsm_mode = 1;
		count=0;

	// Wait 100 ns for global reset to finish
		#100;
      reset = 0;
		
		
		// Add stimulus here
	end
	
	initial begin
		$readmemb("ampl_data_bin.txt", data_stored); // read data from txt in binary format
		f_DAC_out = $fopen("output_main_reduced_2.txt","w");
		f_fsm_window_state = $fopen("output_fsm_window_state_1.txt","w");
	end
	
	always
		#2 
		dataclk =  ! dataclk;

	always @(posedge dataclk) begin
		if (channel==0 & main_state==100) begin
			ampl_to_DAC<=data_stored[count];
			count=count+1;
			end
		if (channel==0 & main_state==205) begin 
			$fwrite(f_DAC_out,"%b\n",   DAC_output_register_1); // write to DAC output_file
			$fwrite(f_fsm_window_state,"%b\n",   fsm_window_state); // write to DAC output_file
			$display ("Current value of DAC_register is %d", DAC_output_register_1);
			end
	end

endmodule

