fs=20e3; % 20kHz sampling rate 
%% retrieve binary data from txt files (output of testbench main_red_tb.v)
% 1. DAC_output_register_1
fileID_DAC = fopen('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\HPF_tests\output_main_reduced_2.txt', 'r');
retrieved_vector_DAC_bin = fscanf(fileID_DAC, '%s');
retrieved_matrix_DAC_bin = reshape(retrieved_vector_DAC_bin,16,[])';
fclose(fileID_DAC);
% 2. fsm_window_state
fileID_fsm_state = fopen('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\HPF_tests\output_fsm_window_state_1.txt', 'r');
retrieved_bin_vector_fsm = fscanf(fileID_fsm_state, '%s');
retrieved_matrix_fsm_bin = reshape(retrieved_bin_vector_fsm,32,[])';
fclose(fileID_DAC);

%% convert binary to decimal
tb_DAC_uint16 = bin2dec(retrieved_matrix_DAC_bin(1:end,:)); %uint16 range (0:2^16-1)=0:65535
tb_fsm_uint16 = bin2dec(retrieved_matrix_fsm_bin(1:end,:));    %uint16 range (0:2^16-1)=0:65535

%% thresholds used 
th_1=-100; %uV
th_2=-350; %uV
th_1_to_tb=floor(32768+th_1/0.195); %uint16
th_2_to_tb=floor(32768+th_2/0.195); %uint16

%% define limits for plots
start_sample=1;
stop_sample=length(tb_DAC_uint16); 
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
plot(time_s,tb_DAC_uint16(range_to_plot)-board_dac_data_u16(range_to_plot)')
title('difference testbench - online dac output')
linkaxes(h,'x')
ylabel('DAC values [uint16]')
xlabel('time [s]')
linkaxes([h(1) h(2)],'y')

%% plot signals in uV with window thresholds and fsm_window_state
retrieved_bin_matrix_dec_DAC_mV = 312.5e-6 * (tb_DAC_uint16 - 32768);   % units = mV
retrieved_bin_matrix_dec_DAC_uV = retrieved_bin_matrix_dec_DAC_mV*1e3;  % units = uV

online_res_mV=board_dac_data(1,range_to_plot);
online_res_uV=online_res_mV*1e3;

figure

h(1)=subplot(5,1,1);
plot(time_s,retrieved_bin_matrix_dec_DAC_uV)
hold on
plot(h(1).XLim,[th_1 th_1],'g')
plot(h(1).XLim,[th_2 th_2],'r')
title('testbench DAC output uV')
xlabel('time [s]')
ylabel('DAC values [uV]')


h(2)=subplot(5,1,2);
plot(time_s,online_res_uV)
hold on
plot(h(1).XLim,[th_1 th_1],'g')
plot(h(1).XLim,[th_2 th_2],'r')
title('online board DAC data uV')
xlabel('time [s]')
ylabel('DAC values [uV]')

h(3)=subplot(5,1,3);
plot(time_s,tb_fsm_uint16(range_to_plot))
title('fsm window state [0 = idle, 1 = track, 2 = stim]')
xlabel('time [s]')

h(4)=subplot(5,1,4);
plot(time_s,board_dig_in_data(:,range_to_plot))
title('board_dig_in_data','interpreter','none')
legend({'complete','active','idle'})
xlabel('time [s]')

h(5)=subplot(5,1,5);
plot(time_s,board_dig_out_data(:,range_to_plot))
title('board_dig_out_data','interpreter','none')
xlabel('time [s]')

linkaxes([h(1) h(2)],'xy')
linkaxes([h(3) h(4)],'xy')
linkaxes(h,'x')