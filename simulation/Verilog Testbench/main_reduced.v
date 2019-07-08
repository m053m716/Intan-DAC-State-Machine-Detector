`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:05:36 01/15/2019 
// Design Name: 
// Module Name:    main_reduced 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module main_reduced(
	input wire			reset,
	input wire			dataclk,
	input wire [15:0] ampl_to_DAC,
	input wire			SPI_start,
	
	input wire [15:0]	DAC_start_win_1,	
	input wire [15:0]	DAC_start_win_2,
	input wire [15:0]	DAC_start_win_3,	
	input wire [15:0]	DAC_start_win_4,
	input wire [15:0]	DAC_start_win_5,	
	input wire [15:0]	DAC_start_win_6,
	input wire [15:0]	DAC_start_win_7,	
	input wire [15:0]	DAC_start_win_8,

	
	input wire [15:0]	DAC_stop_win_1,
	input wire [15:0]	DAC_stop_win_2,
	input wire [15:0]	DAC_stop_win_3,
	input wire [15:0]	DAC_stop_win_4,
	input wire [15:0]	DAC_stop_win_5,
	input wire [15:0]	DAC_stop_win_6,
	input wire [15:0]	DAC_stop_win_7,
	input wire [15:0]	DAC_stop_win_8,
	
	
	input wire [15:0]	DAC_stop_max,
	input wire [7:0]	DAC_edge_type,	
	output wire[7:0]	DAC_thresh_out, //this was 8bits in the original main
	
	input wire [15:0] HPF_coefficient,
	input wire			HPF_en,
	
	input wire [15:0] DAC_sequencer_1,
	input wire [15:0] DAC_sequencer_2,
	input wire [15:0] DAC_sequencer_3,
	input wire [15:0] DAC_sequencer_4,
	input wire [15:0] DAC_sequencer_5,
	input wire [15:0] DAC_sequencer_6,
	input wire [15:0] DAC_sequencer_7,
	input wire [15:0] DAC_sequencer_8,
	
	input wire [7:0]	DAC_sequencer_en,
	
	input wire [7:0]	DAC_en, 			//this was 8bits in the original main
	input wire [2:0]  DAC_gain,
	input wire [6:0]  DAC_noise_suppress,
	output wire[7:0]	DAC_SYNC,
	output wire[7:0]	DAC_SCLK,
	output wire[7:0]	DAC_DIN,
	input wire [15:0]	DAC_thrsh_1,
	input wire [15:0]	DAC_thrsh_2,
	input wire [15:0]	DAC_thrsh_3,
	input wire [15:0]	DAC_thrsh_4,
	input wire [15:0]	DAC_thrsh_5,
	input wire [15:0]	DAC_thrsh_6,
	input wire [15:0]	DAC_thrsh_7,
	input wire [15:0]	DAC_thrsh_8,

	input wire [7:0]	DAC_thrsh_pol,
	input wire        DAC_reref_mode,
	input wire[7:0]	DAC_input_is_ref,
	input wire [15:0]	DAC_reref_register,
	input wire 			DAC_fsm_mode,
	
	output integer 	fsm_window_state=0,
	output wire[15:0] DAC_output_register_1,
	output wire[15:0] DAC_output_register_2,
	output wire[15:0] DAC_output_register_3,
	output wire[15:0] DAC_output_register_4,
	output wire[15:0] DAC_output_register_5,
	output wire[15:0] DAC_output_register_6,
	output wire[15:0] DAC_output_register_7,
	output wire[15:0] DAC_output_register_8,
	
	output integer		main_state,
	output reg			sample_CLK_out=0,
	output reg [5:0]	channel=0,  // varies from 0-19 (amplfier channels 0-15, plus 4 auxiliary commands)
	output reg[15:0]  DAC_register_1=16'b0,
	output reg[15:0]  DAC_register_2=16'b0,
	output reg[15:0]  DAC_register_3=16'b0,
	output reg[15:0]  DAC_register_4=16'b0,
	output reg[15:0]  DAC_register_5=16'b0,
	output reg[15:0]  DAC_register_6=16'b0,
	output reg[15:0]  DAC_register_7=16'b0,
	output reg[15:0]  DAC_register_8=16'b0
	
    );


reg [15:0]		DAC_fsm_counter = 16'b0;
wire[7:0] 		DAC_in_window;
wire [7:0]	   DAC_state_status;
reg  [7:0]		DAC_fsm_out = 8'b0;
wire [7:0]		DAC_thresh_int;
wire [7:0]		DAC_in_en;
wire 				DAC_advance;
wire 				DAC_check_states;
wire 				DAC_any_enabled;


	localparam
			  fsm_idle   = 0,
			  fsm_track  = 1,
			  fsm_stim   = 2,
				ms_wait    = 99,
				ms_clk1_a  = 100,
				
				ms_clk9_d  = 135,
				
				ms_clk18_c = 170,
				
				ms_clk27_b = 205,
			
				ms_cs_i    = 238,
				ms_cs_j    = 239;

	assign DAC_in_en = (~DAC_in_window) | (~DAC_en); // Tracks "In window" or "Enabled"; if a DAC channel is not one or the other, it will not interrupt state machine
	assign DAC_thresh_int = DAC_thresh_out ^ DAC_edge_type; // Intermediate threshold to X-OR the threshold level with the threshold type. If threshold is HIGH, but edge is also HIGH, interrupts machine.
	assign DAC_state_status = DAC_thresh_int | DAC_in_en; // The thresholding does not matter outside the window, or if DAC is disabled.
	assign DAC_check_states = &DAC_state_status; // Reduce the state status to a logical value (all conditions must be met)
	assign DAC_any_enabled = |DAC_en; 				// At least one DAC must be enabled to run the machine (otherwise it will constantly stim.)
	assign DAC_advance = DAC_check_states && DAC_any_enabled; // If all state criteria are met, advances to next clock cycle iteration.

	DAC_modified DAC_modified_1 (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_1), 
		.DAC_sequencer_in(DAC_sequencer_1), 
		.use_sequencer(DAC_sequencer_en[0]), 
		.DAC_en(DAC_en[0]), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC[0]), 
		.DAC_SCLK(DAC_SCLK[0]), 
		.DAC_DIN(DAC_DIN[0]), 
		.DAC_thrsh(DAC_thrsh_1), 
		.DAC_thrsh_pol(DAC_thrsh_pol[0]), 
		.DAC_thrsh_out(DAC_thresh_out[0]), 
		.DAC_fsm_start_win_in(DAC_start_win_1), //
		.DAC_fsm_stop_win_in(DAC_stop_win_1), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[0]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_input_is_ref[0]), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_1)
	);
					
	DAC_modified DAC_modified_2 (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_2), 
		.DAC_sequencer_in(DAC_sequencer_2), 
		.use_sequencer(DAC_sequencer_en[1]), 
		.DAC_en(DAC_en[1]), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC[1]), 
		.DAC_SCLK(DAC_SCLK[1]), 
		.DAC_DIN(DAC_DIN[1]), 
		.DAC_thrsh(DAC_thrsh_2), 
		.DAC_thrsh_pol(DAC_thrsh_pol[1]), 
		.DAC_thrsh_out(DAC_thresh_out[1]), 
		.DAC_fsm_start_win_in(DAC_start_win_2), //
		.DAC_fsm_stop_win_in(DAC_stop_win_2), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[1]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_input_is_ref[1]), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_2)
	);

DAC_modified DAC_modified_3 (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_3), 
		.DAC_sequencer_in(DAC_sequencer_3), 
		.use_sequencer(DAC_sequencer_en[2]), 
		.DAC_en(DAC_en[2]), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC[2]), 
		.DAC_SCLK(DAC_SCLK[2]), 
		.DAC_DIN(DAC_DIN[2]), 
		.DAC_thrsh(DAC_thrsh_3), 
		.DAC_thrsh_pol(DAC_thrsh_pol[2]), 
		.DAC_thrsh_out(DAC_thresh_out[2]), 
		.DAC_fsm_start_win_in(DAC_start_win_3), //
		.DAC_fsm_stop_win_in(DAC_stop_win_3), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[2]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_input_is_ref[2]), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_3)
	);

DAC_modified DAC_modified_4 (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_4), 
		.DAC_sequencer_in(DAC_sequencer_4), 
		.use_sequencer(DAC_sequencer_en[3]), 
		.DAC_en(DAC_en[3]), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC[3]), 
		.DAC_SCLK(DAC_SCLK[3]), 
		.DAC_DIN(DAC_DIN[3]), 
		.DAC_thrsh(DAC_thrsh_4), 
		.DAC_thrsh_pol(DAC_thrsh_pol[3]), 
		.DAC_thrsh_out(DAC_thresh_out[3]), 
		.DAC_fsm_start_win_in(DAC_start_win_4), //
		.DAC_fsm_stop_win_in(DAC_stop_win_4), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[3]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_input_is_ref[3]), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_4)
	);
	
DAC_modified DAC_modified_5 (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_5), 
		.DAC_sequencer_in(DAC_sequencer_5), 
		.use_sequencer(DAC_sequencer_en[4]), 
		.DAC_en(DAC_en[4]), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC[4]), 
		.DAC_SCLK(DAC_SCLK[4]), 
		.DAC_DIN(DAC_DIN[4]), 
		.DAC_thrsh(DAC_thrsh_5), 
		.DAC_thrsh_pol(DAC_thrsh_pol[4]), 
		.DAC_thrsh_out(DAC_thresh_out[4]), 
		.DAC_fsm_start_win_in(DAC_start_win_5), //
		.DAC_fsm_stop_win_in(DAC_stop_win_5), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[4]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_input_is_ref[4]), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_5)
	);
	
DAC_modified DAC_modified_6 (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_6), 
		.DAC_sequencer_in(DAC_sequencer_6), 
		.use_sequencer(DAC_sequencer_en[5]), 
		.DAC_en(DAC_en[5]), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC[5]), 
		.DAC_SCLK(DAC_SCLK[5]), 
		.DAC_DIN(DAC_DIN[5]), 
		.DAC_thrsh(DAC_thrsh_6), 
		.DAC_thrsh_pol(DAC_thrsh_pol[5]), 
		.DAC_thrsh_out(DAC_thresh_out[5]), 
		.DAC_fsm_start_win_in(DAC_start_win_6), //
		.DAC_fsm_stop_win_in(DAC_stop_win_6), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[5]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_input_is_ref[5]), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_6)
	);

DAC_modified DAC_modified_7 (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_7), 
		.DAC_sequencer_in(DAC_sequencer_7), 
		.use_sequencer(DAC_sequencer_en[6]), 
		.DAC_en(DAC_en[6]), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC[6]), 
		.DAC_SCLK(DAC_SCLK[6]), 
		.DAC_DIN(DAC_DIN[6]), 
		.DAC_thrsh(DAC_thrsh_7), 
		.DAC_thrsh_pol(DAC_thrsh_pol[6]), 
		.DAC_thrsh_out(DAC_thresh_out[6]), 
		.DAC_fsm_start_win_in(DAC_start_win_7), //
		.DAC_fsm_stop_win_in(DAC_stop_win_7), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[6]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_input_is_ref[6]), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_7)
	);
	
DAC_modified DAC_modified_8 (
		.reset(reset), 
		.dataclk(dataclk), 
		.main_state(main_state), 
		.channel(channel), 
		.DAC_input(DAC_register_8), 
		.DAC_sequencer_in(DAC_sequencer_8), 
		.use_sequencer(DAC_sequencer_en[7]), 
		.DAC_en(DAC_en[7]), 
		.gain(DAC_gain), 
		.noise_suppress(DAC_noise_suppress), 
		.DAC_SYNC(DAC_SYNC[7]), 
		.DAC_SCLK(DAC_SCLK[7]), 
		.DAC_DIN(DAC_DIN[7]), 
		.DAC_thrsh(DAC_thrsh_8), 
		.DAC_thrsh_pol(DAC_thrsh_pol[7]), 
		.DAC_thrsh_out(DAC_thresh_out[7]), 
		.DAC_fsm_start_win_in(DAC_start_win_8), //
		.DAC_fsm_stop_win_in(DAC_stop_win_8), 
		.DAC_fsm_state_counter_in(DAC_fsm_counter), 
		.DAC_fsm_inwin_out(DAC_in_window[7]), //
		.HPF_coefficient(HPF_coefficient), 
		.HPF_en(HPF_en), 
		.software_reference_mode(DAC_reref_mode & ~DAC_input_is_ref[7]), 
		.software_reference(DAC_reref_register), 
		.DAC_register(DAC_output_register_8)
	);
	always @(posedge sample_CLK_out) begin
		if (reset) begin
			// MM 1/16/18 - FSM DISCRIMINATOR - START
			fsm_window_state <= fsm_idle;
			DAC_fsm_out <= 8'b0100_0000;
			DAC_fsm_counter <= 16'b0;
			// END
		end else begin					
			if (DAC_fsm_mode) begin
				case (fsm_window_state)
					
					fsm_idle: begin
						DAC_fsm_out <= 8'b0100_0000;
						if (DAC_advance) begin
							fsm_window_state <= fsm_track;
							DAC_fsm_counter <= DAC_fsm_counter + 1;
						end
					end
					
					fsm_track: begin
						DAC_fsm_out <= 8'b0010_0000;
						if (DAC_advance) begin
							if (DAC_fsm_counter==DAC_stop_max) begin
								fsm_window_state <= fsm_stim;
								DAC_fsm_counter <= 16'b0;
							end else begin
								fsm_window_state <= fsm_track;
								DAC_fsm_counter <= DAC_fsm_counter + 1;
							end
						end else begin
							fsm_window_state <= fsm_idle;
							DAC_fsm_counter <= 16'b0;
						end
					end 
						  
					fsm_stim: begin
						DAC_fsm_out <= 8'b0001_0000;
						fsm_window_state <= fsm_idle;
					end
					
					default: begin
						DAC_fsm_out <= 8'b0100_0000;
						fsm_window_state <= fsm_idle;
						DAC_fsm_counter <= 16'b0;
					end
				endcase
			end else begin
				fsm_window_state <= fsm_idle;
				DAC_fsm_counter <= 16'b0;
				DAC_fsm_out <= 8'b0000_0000;
			end
		end
	end
		
	// MM 1/22/2018 - FSM DISCRIMINATOR - END

		 	
	// reduced MAIN FSM 
					 	
	always @(posedge dataclk) begin
		if (reset) begin
			main_state <= ms_wait;
			sample_CLK_out <= 0;
			channel <= 0;
			
		end else begin

			case (main_state)
			
				ms_wait: begin
					sample_CLK_out <= 0;
					channel <= 0;
					if (SPI_start) begin
						main_state <= ms_cs_j;
					end
				end

				ms_cs_j: begin
						main_state <= ms_clk1_a;
				end

				ms_clk1_a: begin
					if (channel == 0) begin	// sample clock goes high during channel 0 SPI command
						sample_CLK_out <= 1'b1;
					end else begin
						sample_CLK_out <= 1'b0;
					end


					if (channel == 0) begin		// update  DAC registers with the amplifier data
						DAC_register_1 <= ampl_to_DAC;
						DAC_register_2 <= ampl_to_DAC;
						DAC_register_3 <= ampl_to_DAC;
						DAC_register_4 <= ampl_to_DAC;
						DAC_register_5 <= ampl_to_DAC;
						DAC_register_6 <= ampl_to_DAC;
						DAC_register_7 <= ampl_to_DAC;
						DAC_register_8 <= ampl_to_DAC;
					end
					main_state <= ms_clk9_d;
				end
				
				ms_clk9_d: begin
					main_state <= ms_clk18_c;
				end

				ms_clk18_c: begin
					main_state <= ms_clk27_b;
				end
				
				ms_clk27_b: begin
					main_state <= ms_cs_i;
				end
				
				ms_cs_i: begin
					if (channel == 19) begin
						channel <= 0;
					end else begin
						channel <= channel + 1;
					end
					main_state <= ms_cs_j;
				end
				
				default: begin
					main_state <= ms_wait;
				end
				
			endcase
		end
	end


		
endmodule
