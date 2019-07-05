%% understanding frequencies of the main state machine
per_ch_freq=30e3; %30kS/s
data_clk_freq=2800*per_ch_freq;

sclk=data_clk_freq/4; %a,b (zero) c,d (one) defined in the FSM

period_one_140states_cycle=32*(1/sclk) + 12*(1/data_clk_freq); 
%32 bits for the command (32@sclk or 128@data_clk_freq) plus
%2@data_clk_freq and 10@data_clk_freq
% within such time you sampled one of the 16 channels of each chip

% you need 20 of this commands to complete an entire chip (they are called channels 0:19, 0:15 
% amplifiers and 4 auxiliary files)
period_to_complete_a_chip=20*period_one_140states_cycle;
freq_to_complete_a_chip=1/period_to_complete_a_chip; %i.e. to sample the same site again
