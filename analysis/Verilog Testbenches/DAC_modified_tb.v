`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:33:04 01/14/2019
// Design Name:   DAC_modified
// Module Name:   C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/DAC_modified_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DAC_modified
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DAC_modified_tb;

	// Inputs
	reg reset;
	reg dataclk;
	reg [31:0] main_state;
	reg [5:0] channel;
	reg [15:0] DAC_input;
	reg [15:0] DAC_sequencer_in;
	reg use_sequencer;
	reg DAC_en;
	reg [2:0] gain;
	reg [6:0] noise_suppress;
	reg [15:0] DAC_thrsh;
	reg DAC_thrsh_pol;
	reg [15:0] DAC_fsm_start_win_in;
	reg [15:0] DAC_fsm_stop_win_in;
	reg [15:0] DAC_fsm_state_counter_in;
	reg [15:0] HPF_coefficient;
	reg HPF_en;
	reg software_reference_mode;
	reg [15:0] software_reference;

	// Outputs
	wire DAC_SYNC;
	wire DAC_SCLK;
	wire DAC_DIN;
	wire DAC_thrsh_out;
	wire DAC_fsm_inwin_out;
	wire [15:0] DAC_register;
	
	// Additional
	integer f, count;
	parameter WIDTH = 6001;
	reg [15:0] data_stored [0:WIDTH-1]; //200001 16-bits words is the length of raw_data.txt
	
	// Instantiate the Unit Under Test (UUT)
	DAC_modified uut (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_input), 
		.DAC_sequencer_in(DAC_sequencer_in), 
		.use_sequencer(use_sequencer), 
		.DAC_en(DAC_en), 
		.gain(gain), 
		.noise_suppress(noise_suppress), 
		.DAC_SYNC(DAC_SYNC), 
		.DAC_SCLK(DAC_SCLK), 
		.DAC_DIN(DAC_DIN), 
		.DAC_thrsh(DAC_thrsh), 
		.DAC_thrsh_pol(DAC_thrsh_pol), 
		.DAC_thrsh_out(DAC_thrsh_out), 
		.DAC_fsm_start_win_in(DAC_fsm_start_win_in), 
		.DAC_fsm_stop_win_in(DAC_fsm_stop_win_in), 
		.DAC_fsm_state_counter_in(DAC_fsm_state_counter_in), 
		.DAC_fsm_inwin_out(DAC_fsm_inwin_out), 
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(software_reference_mode), 
		.software_reference(software_reference), 
		.DAC_register(DAC_register)
	);

	initial begin
		// Initialize Inputs
		reset = 1;
		dataclk = 0;
		main_state = 99;
		channel = 0;
		DAC_input = 0;
		DAC_sequencer_in = 0;
		use_sequencer = 0;
		DAC_en = 1;
		gain = 0;
		noise_suppress = 0;
		DAC_thrsh = 1;
		DAC_thrsh_pol = 0;
		DAC_fsm_start_win_in = 0;
		DAC_fsm_stop_win_in = 0;
		DAC_fsm_state_counter_in = 0;
		HPF_coefficient = 3343; // 250Hz/30000kS
		HPF_en = 1;
		software_reference_mode = 0;
		software_reference = 0;
		count = 0;

		// Wait 100 ns for global reset to finish
		#100;
      reset=0;  

	end
	
	initial begin
		$readmemb("ampl_data_bin.txt", data_stored); // read data from txt in binary format
		f = $fopen("output_3.txt","w");
	end
	
	always
		#2 
		dataclk =  ! dataclk;

	always @(posedge dataclk) begin
		case (main_state)
			99 : #1 main_state <=100;
			100: begin
					DAC_input<=data_stored[count];
					count=count+1;
					#1 main_state <=135;
					end
			135:  #1 main_state <=170;
			170: begin 
					#1 main_state <=205;
					$fwrite(f,"%b\n",   DAC_register); // write to output_file
					$display ("Current value of DAC_register is %d", DAC_register);
					end
			205:  #1 main_state <=99;
		endcase
	end

endmodule

/*	parameter ms_wait  	= 99,   //state_clk =0
   parameter ms_clk1_a 	= 100,  //state_clk =1 only when channel == 0 (update time in fsm) odd bits
   parameter ms_clk9_d 	= 135,  //state_clk =0
	parameter ms_clk18_c = 170,  //state_clk =1 only when channel == 0  even bits
   parameter ms_clk27_b = 205*/ //state_clk =0
	
	// NOTE: in main.v
	//  channel, channelMISO // varies from 0-19 (amplfier channels 0-15, plus 4 auxiliary commands)
// sample clock goes high during channel 0 SPI command

