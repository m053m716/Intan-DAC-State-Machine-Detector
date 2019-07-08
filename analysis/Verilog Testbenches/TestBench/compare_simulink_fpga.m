%% compare results from simulink with those from FPGA
% close all
% clear
% clc
% read_Intan_RHS2000_file('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\R19-00_2019-01-23\R19-00_2019-01-23_2_190123_095121.rhs')
% load('C:\Users\BuccelliLab\Documents\GitHub\intan_project\debugging\simulink\scope_data_from_dac_recording_2.mat')
fsm_from_simulink=simOut.ScopeData.signals(3).values';

num_dig_in=size(board_dig_in_channels,2);
for curr_ind=1:num_dig_in
    if (board_dig_in_channels(curr_ind).native_channel_name=='DIGITAL-IN-13')
        indx_complete=curr_ind;
    elseif (board_dig_in_channels(curr_ind).native_channel_name=='DIGITAL-IN-14')
        indx_active=curr_ind;
    end
end

fsm_from_dig_in=board_dig_in_data(indx_complete,:)*2+board_dig_in_data(indx_active,:);
figure
h(1)=subplot(3,1,1);
plot(fsm_from_dig_in)
title('fsm out from dig in (FPGA)')
h(2)=subplot(3,1,2);
plot(fsm_from_simulink)
title('fsm out from simulink')
h(3)=subplot(3,1,3);
plot(fsm_from_simulink(1:length(fsm_from_dig_in)-1)-fsm_from_dig_in(2:end))
title('fsm out from simulink - FPGA')
linkaxes(h,'x')