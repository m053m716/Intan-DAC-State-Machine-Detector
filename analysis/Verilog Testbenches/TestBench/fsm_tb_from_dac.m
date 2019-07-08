%% testbench of fsm algorithm from dac values
clear
x = readModifiedIntan(['C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\R19-00_2019-01-23\R19-00_2019-01-23_9_190123_193957.rhs']);

n_dacs=size(x.dac_triggers,2);
board_dac_data_uint16=x.board_dac_data(1,:);
board_dac_data_to_th=0.195 * (board_dac_data_uint16 - 32768); % uV, step 0.195uV

DAC_fsm_counter=0;

for curr_sample=1:length(board_dac_data_to_th)
    DAC_advance=;
    for curr_DAC=1:4
        DAC_fsm_counter>=window_start(curr_DAC)&DAC_fsm_counter<window_stop(curr_DAC)
    end
end
