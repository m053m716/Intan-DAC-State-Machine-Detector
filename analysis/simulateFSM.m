function [fsm_window_state,fig] = simulateFSM(name,params)
%% SIMULATEFSM    Simulates finite state machine (FSM) run on DAC
%
%  fsm_window_state = SIMULATEFSM(name);
%  fsm_window_state = SIMULATEFSM(name,params);
%
%  --------
%   INPUTS
%  --------
%    name      :     String of block name or cell array of strings.
%
%   params     :     Struct containing following fields:
%                    -> 'DAC_en'
%                    -> 'DAC_edge_type'
%                    -> 'dac_thresholds'
%                    -> 'window_start'
%                    -> 'window_stop'
%
%  --------
%   OUTPUT
%  --------
%  fsm_window_state  :     Simulated output from FSM
%
% By: Stefano Buccelli    v1.0  2019-02-06  ('matlab_tb.m')
% Adapted by: Max Murphy  v1.1  2019-02-07  (R2017a)

%% DEFAULTS
DAC_en=[0 0 0 0 1 1 1 1];
DAC_edge_type=[1 1 1 1 1 1 1 0]; % 0==Inclusion, 1==Exclusion
dac_thresholds=[-140 140 -140 -140 13 -25 -149 -40];
window_start=[0 2 1 1 3 4 1 0];
window_stop=[1 5 2 5 15 11 6 1];
make_spike_fig = false;
refractory_period = 0;
fs = 30000;
edge_type = 'none';
data_suffix = '_DAC.mat';
dac_ratio_gain = (0.195 / 312.5e-6);

%% PARSE INPUT
if nargin > 1
   f = fieldnames(params);
   for iF = 1:numel(f)
      if exist(f{iF},'var')~=0
         eval([f{iF} ' = params.(f{iF});']);
      end
   end
end
dac_thresholds_0195=get_safe(dac_thresholds);
pos_th=dac_thresholds>=0;
DAC_stop_max=max(window_stop.*DAC_en);

%% USE RECURSION FOR CELL ARRAY WITH MULTIPLE "NAME"
if iscell(name)
   fsm_window_state = cell(size(name));
   fig = cell(size(fsm_window_state));
   for ii = 1:numel(name)
      [fsm_window_state{ii},fig{ii}] = simulateFSM(name{ii},params);
   end
   return;
end

%% GET DATA
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');
in = load(fullfile(in_dir,[name data_suffix]),'data');
data = in.data * dac_ratio_gain;

%% initialize arrays
fsm_counter=zeros(1,length(data));
fsm_window_state=zeros(1,length(data));
DAC_fsm_out=zeros(1,length(data));

%% initialize figure with window discriminators
if (make_spike_fig)
   fig = figure('Name',sprintf('%s: Included and Excluded Spikes',name),...
      'Units','Normalized',...
      'Color','w',...
      'Position',[0.3 0.3 0.4 0.4]);
   time_ms=1e3*(1:45)/fs;
   incl_exc_col={'bo','ro'};
   for curr_dac=1:8
      if DAC_en(curr_dac)
         window_samples=window_start(curr_dac):window_stop(curr_dac)-1;
         window_samples_shifted=window_samples+14;
         subplot(1,2,1)
         plot(time_ms(window_samples_shifted),dac_thresholds_0195(curr_dac),incl_exc_col{DAC_edge_type(curr_dac)+1})
         hold on
         title('detected spikes in the last two samples')
         subplot(1,2,2)
         plot(time_ms(window_samples_shifted),dac_thresholds_0195(curr_dac),incl_exc_col{DAC_edge_type(curr_dac)+1})
         hold on
         title('aborted spikes in the last two samples')
      end
   end
else
   fig = [];
end

%% cycle over samples
tic
fprintf(1,'Simulating recording (%s)...%03g%%\n',name,0);
pct = 0;
refractory_counter = inf;
currentEdge = true;
for curr_sample=1:length(data)
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
         fsm_window_state(curr_sample+1) = 0;
         if (DAC_advance) && currentEdge
            if (refractory_counter > refractory_period)
               fsm_window_state(curr_sample+1)=1;
               fsm_counter(curr_sample+1)=fsm_counter(curr_sample)+1;
            end
         else
            currentEdge = true;
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
            if (make_spike_fig)
               if fsm_counter(curr_sample)==(DAC_stop_max-1)||fsm_counter(curr_sample)==(DAC_stop_max-2)
                  %% plotting aborted spikes in different subplot
                  figure(fig)
                  subplot(1,2,2)
                  idx = getSpikeSamples(curr_sample,fsm_counter(curr_sample));
                  plot(time_ms,data(idx),'k')
                  hold on
               end
            end
         end
      case 2
         DAC_fsm_out(curr_sample+1)=2;
         fsm_window_state(curr_sample+1)=0;
         refractory_counter = 0;
         if (make_spike_fig)
            figure(fig);
            subplot(1,2,1)
            idx = getSpikeSamples(curr_sample,DAC_stop_max);
            if (min(idx) > 0) && (max(idx) <= numel(data))
               plot(time_ms,data(idx),'k')
            end
            hold on
         end
         if strcmp(edge_type,'rising')
            currentEdge = false;
         end
      otherwise
         error('Invalid FSM state (%d).', fsm_window_state(curr_sample));
   end
   
   refractory_counter = refractory_counter + 1;
   cur_pct = floor(100*curr_sample/length(data));
   if (cur_pct > pct)
      pct = cur_pct;
      fprintf(1,'\b\b\b\b\b%03g%%\n',pct);
   end
end
% Account for 2-sample delay
fsm_window_state = [zeros(1,2), fsm_window_state(1:(end-2))];

toc

%% SUB-FUNCTIONS
   function safe_th=get_safe(threshold)
      %% GET_SAFE  Get correct threshold based on DAC quantization
      % if negative put +, if positive put -
      if threshold>=0
         safe_th=round(threshold/0.195)*0.195-0.195/2;
      else
         safe_th=round(threshold/0.195)*0.195+0.195/2;
      end
   end

   function idx = getSpikeSamples(curr_sample,offset)
      %% GETSPIKESAMPLES   Get samples corresponding to spike snippet
      idx = ((curr_sample-14):(curr_sample+30))-offset;
   end

end