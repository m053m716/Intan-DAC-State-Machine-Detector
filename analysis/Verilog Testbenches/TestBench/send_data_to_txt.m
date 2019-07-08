%% send data to txt
clear
read_Intan_RHS2000_file % if you don't want to change parameters, you have to import R18-159_2019_01_31_1_190131_152307
%% don't forget to modify the filter in Verilog with this number:
fs=30e3;
fc=300;
b = 1.0 - exp(-2.0 * 3.1415926535897 * fc / fs); 
filterCoefficient = floor(65536.0 * b + 0.5);

%% thresholds
th_1=round(-46/0.195)*0.195; %uV
th_1_to_tb=round(th_1/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA
th_2=round(-66/0.195)*0.195; %uV
th_2_to_tb=round(th_2/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA
th_3=round(-13/0.195)*0.195; %uV
th_3_to_tb=round(th_3/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA
th_4=round(39/0.195)*0.195; %uV
th_4_to_tb=round(th_4/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA

%% plot to look at the data
ch_indx_ampl=3;
% ch_indx_ampl=1;
t=(1:1:size(amplifier_data,2))./fs;
amplif=amplifier_data(ch_indx_ampl,:);
dac=board_dac_data(1,:);
figure
h(1)=subplot(2,1,1);
plot(t,amplif)
title('amplifier')
h(2)=subplot(2,1,2);
plot(t,dac)
title('dac')
linkaxes(h,'x')
%% start and stop sample to send binary

start_sample=1;
stop_sample=size(amplifier_data,2);

amplifier_u16=32768+amplifier_data(ch_indx_ampl,start_sample:stop_sample)/0.195;
 
data_bin=dec2bin(amplifier_u16,16);
bin_matrix=char(data_bin);

fileID = fopen('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\HPF_tests\ampl_data_bin.txt', 'w');
for i=1:length(bin_matrix)
    %     fprintf(fileID, '%s \n', hex_matrix(i,:));
    fprintf(fileID, '%s \n', bin_matrix(i,:));
end
 fclose(fileID);