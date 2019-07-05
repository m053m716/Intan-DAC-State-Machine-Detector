function [spikes,idx] = getFSMDetectedSpikes(name,fsm_window_state,params)
%% GETFSMDETECTEDSPIKES    Get spikes detected by state machine on DAC
%
%  [spikes,idx] = GETFSMDETECTEDSPIKES(name);
%  [spikes,idx] = GETFSMDETECTEDSPIKES(name,fsm_window_state);
%  [spikes,idx] = GETFSMDETECTEDSPIKES(name,fsm_window_state,params);
%
%  --------
%   INPUTS
%  --------
%    name      :     Cell array of block names (e.g.
%                       {'R18-159_2019_02_01_1'})
%
%  fsm_window_state :  Simulated FSM state values for duration of recording,
%                       from matlab_check_performance/SIMULATEFSM
%
%  params      :     Parameters struct
%
%  --------
%   OUTPUT
%  --------
%   spikes     :     Cell array same size as name. Each element contains
%                       spike waveform snippets corresponding to samples
%                       around the detected spike index.
%
%     idx      :     Sample indices corresponding to spikes.
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% DEFAULTS

data_suffix = '_DAC.mat';
dac_ratio_gain = (0.195 / 312.5e-6);
peak_offset = 13;
n_max = inf;
data_dir = 'data';
wlen = 15;
if nargin > 3
   if isfield(params,'data_suffix')
      data_suffix = params.data_suffix;
   end
   
   if isfield(params,'dac_ratio_gain')
      dac_ratio_gain = params.dac_ratio_gain;
   end
   
   if isfield(params,'n_max')
      n_max = params.n_max;
   end
   
   if isfield(params,'peak_offset')
      peak_offset = params.peak_offset;
   end
   
   if isfield(params,'data_dir')
      data_dir = params.data_dir;
   end
   
   if isfield(params,'wlen')
      wlen = params.wlen;
   end
end

%% GET INPUT DATA DIRECTORY
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,data_dir);

%% USE RECURSION FOR MULTIPLE ENTRIES
if iscell(name)
   spikes = cell(size(name));
   for ii = 1:numel(name)
      if nargin > 2
         spikes{ii} = getFSMDetectedSpikes(name{ii},wlen,fsm_window_state{ii});
      else
         spikes{ii} = getFSMDetectedSpikes(name{ii},wlen);
      end
   end
   return;
end

%% LOAD DATA
dac = load(fullfile(in_dir,[name data_suffix]));

if nargin > 1
   trig = struct('data',fsm_window_state == 2);
else
   trig = load(fullfile(in_dir,[name '_DIG_fsm-complete.mat']));
end

%%  Find all times FSM was successfully completed
idx = find(trig.data);
idx = reshape(idx,numel(idx),1);

%% Create indexing vector for snippets
samples_prior = wlen + peak_offset;
samples_after = wlen - peak_offset;
vec = (-samples_prior) : samples_after;
vec = vec + idx;

%% Remove any indices out of range
exc = (vec < 1) | (vec > numel(dac.data));
vec(any(exc,2),:) = [];
idx(any(exc,2)) = [];

%% Reduce the size of the number to keep
iKeep = randperm(min(size(vec,1),n_max),min(size(vec,1),n_max));
vec = vec(iKeep,:);
idx = idx(iKeep);

spikes = dac.data(vec) * dac_ratio_gain; % convert to uV

end
