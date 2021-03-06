% clear

% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end
cd ..
fs=30e3; % 20kHz sampling rate 
%% retrieve binary data from txt files (output of testbench main_red_tb.v)
% 1. DAC_output_register_1
fileID_DAC = fopen('output_main_reduced_2.txt', 'r');
retrieved_vector_DAC_bin = fscanf(fileID_DAC, '%s');
retrieved_matrix_DAC_bin = reshape(retrieved_vector_DAC_bin,16,[])';
fclose(fileID_DAC);
% 2. fsm_window_state
fileID_fsm_state = fopen('output_fsm_window_state_1.txt', 'r');
retrieved_bin_vector_fsm = fscanf(fileID_fsm_state, '%s');
retrieved_matrix_fsm_bin = reshape(retrieved_bin_vector_fsm,32,[])';
fclose(fileID_DAC);

%% convert binary to decimal
tb_DAC_uint16 = bin2dec(retrieved_matrix_DAC_bin(1:end,:)); %uint16 range (0:2^16-1)=0:65535
tb_fsm_uint16 = bin2dec(retrieved_matrix_fsm_bin(1:end,:));    %uint16 range (0:2^16-1)=0:65535
% tb_DAC_uint16 = bin2dec(retrieved_matrix_DAC_bin(1:length(board_dac_data(1,:)),:)); %uint16 range (0:2^16-1)=0:65535
% tb_fsm_uint16 = bin2dec(retrieved_matrix_fsm_bin(1:length(board_dac_data(1,:)),:));    %uint16 range (0:2^16-1)=0:65535
%% thresholds used 
th_1=round(-46/0.195)*0.195; %uV
th_1_to_tb=round(th_1/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA
th_2=round(-66/0.195)*0.195; %uV
th_2_to_tb=round(th_2/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA
th_3=round(-13/0.195)*0.195; %uV
th_3_to_tb=round(th_3/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA
th_4=round(39/0.195)*0.195; %uV
th_4_to_tb=round(th_4/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA

%% define limits for plots
start_sample=1;
% stop_sample=length(tb_DAC_uint16); 
stop_sample=min(length(tb_DAC_uint16),length(board_dac_data(1,:))); 
range_to_plot=start_sample:stop_sample;
time_s=range_to_plot./fs;
%% plot signals difference in uint16 
board_dac_data_u16=32768+(board_dac_data(1,range_to_plot)./312.5e-6 ); %back to uint16

figure

h(1)=subplot(3,1,1);
plot(time_s,tb_DAC_uint16)
title('testbench DAC output uint16')
ylabel('DAC values [uint16]')
xlabel('time [s]')

h(2)=subplot(3,1,2);
plot(time_s,board_dac_data_u16)
title('online board DAC data')
ylabel('DAC values [uint16]')
xlabel('time [s]')

h(3)=subplot(3,1,3);
diff_tb_real_dac=tb_DAC_uint16(range_to_plot)-board_dac_data_u16(range_to_plot)';
plot(time_s,diff_tb_real_dac)
title('difference testbench - online dac output')
linkaxes(h,'x')
ylabel('DAC values [uint16]')
xlabel('time [s]')
linkaxes([h(1) h(2)],'y')

diff_reshape=diff_tb_real_dac(101:floor(length(diff_tb_real_dac)/100)*100);
diff_reshape_reshaped=reshape(diff_reshape,100,[]);
a=sum(diff_reshape_reshaped==1);
%% plot signals in uV with window thresholds and fsm_window_state
retrieved_bin_matrix_dec_DAC_mV = 312.5e-6 * (tb_DAC_uint16 - 32768);   % units = mV
retrieved_bin_matrix_dec_DAC_uV = retrieved_bin_matrix_dec_DAC_mV*1e3;  % units = uV

online_res_mV=board_dac_data(1,range_to_plot);
online_res_uV=online_res_mV*1e3;

figure

h(1)=subplot(4,1,1);
plot(time_s,retrieved_bin_matrix_dec_DAC_uV)
hold on
plot(h(1).XLim,[th_1 th_1],'g')
plot(h(1).XLim,[th_2 th_2],'r')
plot(h(1).XLim,[th_3 th_3],'r')
title('testbench DAC output uV')
xlabel('time [s]')
ylabel('DAC values [uV]')


h(2)=subplot(4,1,2);
plot(time_s,online_res_uV)
hold on
plot(h(1).XLim,[th_1 th_1],'g')
plot(h(1).XLim,[th_2 th_2],'r')
plot(h(1).XLim,[th_3 th_3],'r')
title('online board DAC data uV')
xlabel('time [s]')
ylabel('DAC values [uV]')

h(3)=subplot(4,1,3);
plot(time_s,tb_fsm_uint16(range_to_plot))
title('fsm window state [0 = idle, 1 = track, 2 = stim]')
xlabel('time [s]')

h(4)=subplot(4,1,4);
plot(time_s,board_dig_in_data(:,range_to_plot))
title('board_dig_in_data','interpreter','none')
legend({'complete','active','idle'})
xlabel('time [s]')

linkaxes([h(1) h(2)],'xy')
linkaxes([h(3) h(4)],'xy')
linkaxes(h,'x')

%% programmatically check difference between fsm_state from tb and dig in from recordings
num_dig_in=size(board_dig_in_channels,2);
for curr_ind=1:num_dig_in
    if (board_dig_in_channels(curr_ind).native_channel_name=='DIGITAL-IN-13')
        indx_complete=curr_ind;
    elseif (board_dig_in_channels(curr_ind).native_channel_name=='DIGITAL-IN-14')
        indx_active=curr_ind;
    end
end
%%

fsm_state_real=board_dig_in_data(indx_complete,range_to_plot).*2;% complete
fsm_state_real=fsm_state_real+board_dig_in_data(indx_active,range_to_plot).*1;% active
fsm_state_tb=tb_fsm_uint16(range_to_plot)';

fsm_state_real_cut_shift=fsm_state_real(3:end);
fsm_state_tb_cut_shift=fsm_state_tb(1:end-2);

figure
h(1)=subplot(4,1,1);
plot(fsm_state_tb_cut_shift)
hold on
plot(fsm_state_real_cut_shift)
legend({'tb','real'})
title('fsm state comparison testbench vs dig in')
h(2)=subplot(4,1,2);
plot(fsm_state_real_cut_shift-fsm_state_tb_cut_shift)
title('difference fsm state from testbench - dig in')
h(3)=subplot(4,1,3);
plot(tb_DAC_uint16(range_to_plot)-board_dac_data_u16(range_to_plot)')
title('difference testbench - online dac output')
h(4)=subplot(4,1,4);
% plot(board_dac_data(1,range_to_plot)-board_dac_data(5,range_to_plot))
title('DAC 1 - DAC 5')
ylabel('DAC difference [V] step 312.5 uV ')
linkaxes(h,'x')