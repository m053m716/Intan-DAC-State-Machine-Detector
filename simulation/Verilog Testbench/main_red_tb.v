`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:43:00 01/17/2019
// Design Name:   main_reduced
// Module Name:   C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/main_red_tb.v
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

module main_red_tb;

	// Inputs
	reg reset;
	reg dataclk;
	reg [15:0] ampl_to_DAC;
	reg SPI_start;
	reg [15:0] DAC_start_win_1;
	reg [15:0] DAC_start_win_2;
	reg [15:0] DAC_stop_win_1;
	reg [15:0] DAC_stop_win_2;
	reg [15:0] DAC_stop_max;
	reg [1:0] DAC_edge_type;
	reg [15:0] HPF_coefficient;
	reg HPF_en;
	reg [15:0] DAC_sequencer_1;
	reg [15:0] DAC_sequencer_2;
	reg DAC_sequencer_en_1;
	reg DAC_sequencer_en_2;
	reg [1:0] DAC_en;
	reg [2:0] DAC_gain;
	reg [6:0] DAC_noise_suppress;
	reg [15:0] DAC_thrsh_1;
	reg [15:0] DAC_thrsh_2;
	reg DAC_thrsh_pol_1;
	reg DAC_thrsh_pol_2;
	reg DAC_reref_mode;
	reg [1:0] DAC_input_is_ref;
	reg [15:0] DAC_reref_register;
	reg DAC_fsm_mode;

	// Outputs
	wire [1:0] DAC_thresh_out;
	wire [1:0] DAC_SYNC;
	wire [1:0] DAC_SCLK;
	wire [1:0] DAC_DIN;
	wire [31:0] fsm_window_state;
	wire [15:0] DAC_output_register_1;
	wire [15:0] DAC_output_register_2;
	wire [31:0] main_state;
	wire sample_CLK_out;
	wire [5:0] channel;
	wire [15:0] DAC_register_1;
	wire [15:0] DAC_register_2;

	// Additional
	integer f_DAC_out, f_fsm_window_state, count;
	parameter WIDTH = 60001;
	reg [15:0] data_stored [0:WIDTH-1]; //200001 16-bits words is the length of raw_data.txt

	// Instantiate the Unit Under Test (UUT)
	main_reduced uut (
		.reset(reset), 
		.dataclk(dataclk), 
		.ampl_to_DAC(ampl_to_DAC), 
		.SPI_start(SPI_start), 
		.DAC_start_win_1(DAC_start_win_1), 
		.DAC_start_win_2(DAC_start_win_2), 
		.DAC_stop_win_1(DAC_stop_win_1), 
		.DAC_stop_win_2(DAC_stop_win_2), 
		.DAC_stop_max(DAC_stop_max), 
		.DAC_edge_type(DAC_edge_type), 
		.DAC_thresh_out(DAC_thresh_out), 
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.DAC_sequencer_1(DAC_sequencer_1), 
		.DAC_sequencer_2(DAC_sequencer_2), 
		.DAC_sequencer_en_1(DAC_sequencer_en_1), 
		.DAC_sequencer_en_2(DAC_sequencer_en_2), 
		.DAC_en(DAC_en), 
		.DAC_gain(DAC_gain), 
		.DAC_noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC), 
		.DAC_SCLK(DAC_SCLK), 
		.DAC_DIN(DAC_DIN), 
		.DAC_thrsh_1(DAC_thrsh_1), 
		.DAC_thrsh_2(DAC_thrsh_2), 
		.DAC_thrsh_pol_1(DAC_thrsh_pol_1), 
		.DAC_thrsh_pol_2(DAC_thrsh_pol_2), 
		.DAC_reref_mode(DAC_reref_mode), 
		.DAC_input_is_ref(DAC_input_is_ref), 
		.DAC_reref_register(DAC_reref_register), 
		.DAC_fsm_mode(DAC_fsm_mode), 
		.fsm_window_state(fsm_window_state), 
		.DAC_output_register_1(DAC_output_register_1), 
		.DAC_output_register_2(DAC_output_register_2), 
		.main_state(main_state), 
		.sample_CLK_out(sample_CLK_out), 
		.channel(channel), 
		.DAC_register_1(DAC_register_1), 
		.DAC_register_2(DAC_register_2)
	);

	initial begin
		// Initialize Inputs
		reset = 1;
		dataclk = 0;
		ampl_to_DAC = 0;
		SPI_start = 1;
		DAC_start_win_1 = 0;
		DAC_start_win_2 = 2;
		DAC_stop_win_1 = 3;
		DAC_stop_win_2 = 5;
		DAC_stop_max = 3;
		DAC_edge_type = 2'b10; // 0 is inclusion, 1 exclusion
		HPF_coefficient = 3991; // 3991 is 300Hz/30000kS  //3343 is 250/30000 // 5894 300/2000Hz
		HPF_en = 1;
		DAC_sequencer_1 = 0;
		DAC_sequencer_2 = 0;
		DAC_sequencer_en_1 = 0;
		DAC_sequencer_en_2 = 0;
		DAC_en = 2'b11;
		DAC_gain = 0;
		DAC_noise_suppress = 0;
		DAC_thrsh_1 = 30794;//-385
		DAC_thrsh_2 = 27122;//-1101
		DAC_thrsh_pol_1 = 0; //DAC_thrsh_pol ? (DAC_input_offset >= DAC_thrsh) : (DAC_input_offset <= DAC_thrsh))
		DAC_thrsh_pol_2 = 0; //0 if negative threshold
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


