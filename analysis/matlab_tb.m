clear
clc
close all
% matlab testbench for the spike detection with window disciriminators
read_Intan_RHS2000_file('..\data\R18-159_2019_02_01_2_190201_143203.rhs')
fs=frequency_parameters.amplifier_sample_rate;
data=0.195*(board_dac_data(1,:)./312.5e-6);

%% set parameters
DAC_en=[0 0 0 0 1 1 1 1];
DAC_edge_type=[1 1 1 1 1 1 1 0]; % 0==Inclusion, 1==Exclusion
dac_thresholds=[-140 140 -140 -140 13 -25 -149 -40];
pos_th=dac_thresholds>=0;
dac_thresholds_0195=zeros(1,8);
for curr_dac=1:8
    dac_thresholds_0195(curr_dac)=get_safe(dac_thresholds(curr_dac));
end

window_start=[0 2 1 1 3 4 1 0];
window_stop=[1 5 2 5 15 11 6 1];
DAC_stop_max=max(window_stop.*DAC_en);

%% initialize arrays
fsm_counter=zeros(1,length(data));
fsm_window_state=zeros(1,length(data));
DAC_fsm_out=zeros(1,length(data));

%% initialize figure with window discriminators
figure(101)
time_ms=(1:60)/fs;
incl_exc_col={'bo','ro'};
for curr_dac=1:8
    if DAC_en(curr_dac)
        window_samples=window_start(curr_dac):window_stop(curr_dac)-1;
        window_samples_shifted=window_samples+29;
        plot(time_ms(window_samples_shifted),dac_thresholds(curr_dac),incl_exc_col{DAC_edge_type(curr_dac)+1});
        hold on
    end
end

%% cycle over samples
tic
pct = 0;
fprintf(1,'Running simulation...%03g%%\n',pct);
for curr_sample=1:length(data)
   cur_pct = floor(curr_sample / length(data) * 100);
   if (cur_pct > pct)
      pct = cur_pct;
      fprintf(1,'\b\b\b\b\b%03g%%\n',pct);
   end
   %% work done by DAC_output
   DAC_thresh_out=zeros(1,8);
   DAC_in_window=(fsm_counter(curr_sample)>=window_start) & (fsm_counter(curr_sample)<window_stop);
   check_all_pos=data(curr_sample)>=dac_thresholds_0195;
   check_all_neg=data(curr_sample)<=dac_thresholds_0195;
   DAC_thresh_out(pos_th)=check_all_pos(pos_th);
   DAC_thresh_out(~pos_th)=check_all_neg(~pos_th);
   
   %% set logic
   DAC_in_en = (~DAC_in_window) | (~DAC_en); % Tracks "In window" or "Enabled"; if a DAC channel is not one or the other, it will not interrupt state machine
   DAC_thresh_int = xor(DAC_thresh_out,DAC_edge_type); % Intermediate threshold to X-OR the threshold level with the threshold type. If threshold is HIGH, but edge is also HIGH, interrupts machine.
   DAC_state_status = DAC_thresh_int | DAC_in_en; % The thresholding does not matter outside the window, or if DAC is disabled.
   DAC_check_states = all(DAC_state_status); % Reduce the state status to a logical value (all conditions must be met)
   DAC_any_enabled = any(DAC_en); 				% At least one DAC must be enabled to run the machine (otherwise it will constantly stim.)
   DAC_advance = DAC_check_states && DAC_any_enabled; % If all state criteria are met, advances to next clock cycle iteration.
   

   %% fsm
   switch fsm_window_state(curr_sample)
       case 0
           DAC_fsm_out(curr_sample+1)=0;
           if DAC_advance
               fsm_window_state(curr_sample+1)=1;
               fsm_counter(curr_sample+1)=fsm_counter(curr_sample)+1;
           end
       case 1
            DAC_fsm_out(curr_sample+1)=1;
            if DAC_advance
                if fsm_counter(curr_sample)==DAC_stop_max
                    fsm_window_state(curr_sample+1)=2;
                    fsm_counter(curr_sample+1)=0;
                else
                    fsm_window_state(curr_sample+1)=1;
                    fsm_counter(curr_sample+1)=fsm_counter(curr_sample)+1;
                end
            else
                fsm_window_state(curr_sample+1)=0;
                fsm_counter(curr_sample+1)=0;
            end
       case 2
            DAC_fsm_out(curr_sample+1)=2;
            fsm_window_state(curr_sample+1)=0;
            figure(101)
            plot(time_ms,data([curr_sample-29:curr_sample+30]-DAC_stop_max),'k')
            hold on
   end

end
toc
%% compare results
fsm_from_matlab=fsm_window_state;

num_dig_in=size(board_dig_in_channels,2);
for curr_ind=1:num_dig_in
    if (board_dig_in_channels(curr_ind).native_channel_name=='DIGITAL-IN-13')
        indx_complete=curr_ind;
    elseif (board_dig_in_channels(curr_ind).native_channel_name=='DIGITAL-IN-14')
        indx_active=curr_ind;
    end
end


fsm_from_dig_in=board_dig_in_data(indx_complete,:)*2+board_dig_in_data(indx_active,:);
%%
figure('Name','Comparison of Simulated and Recorded Detector States',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8],...
   'Color','w');
h(1)=subplot(4,1,1);
plot(h(1),fsm_from_dig_in,'Color','k')
title('Recorded Detector State (FPGA)','FontName','Arial','FontSize',14,'Color','k');
h(2)=subplot(4,1,2);
plot(h(2),fsm_from_matlab,'Color','b')
title('Simulated Detector State (Matlab)','FontName','Arial','FontSize',14,'Color','k');
h(3)=subplot(4,1,3);
plot(h(3),fsm_from_matlab(1:length(fsm_from_dig_in)-2)-fsm_from_dig_in(3:end),'Color','r')
title('Difference','FontName','Arial','FontSize',14,'Color','k');
h(4)=subplot(4,1,4);
plot(h(4),data,'Color','k')
title('DAC Amplifier Stream','FontName','Arial','FontSize',14,'Color','k');
linkaxes(h,'x')

% figure
% plot(fsm_from_dig_in)
% hold on
% plot(fsm_from_matlab)

function safe_th=get_safe(threshold)
% if negative put +, if positive put -
if threshold>=0
    safe_th=round(threshold/0.195)*0.195-0.195/2;
else
    safe_th=round(threshold/0.195)*0.195+0.195/2;
end
end