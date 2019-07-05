function [spikes,idx] = getFSMDetectedSpikes(name,wlen,fsm_window_out,params)
%% GETFSMDETECTEDSPIKES    Get spikes detected by state machine on DAC
%
%  [spikes,idx] = GETFSMDETECTEDSPIKES(name);
%  [spikes,idx] = GETFSMDETECTEDSPIKES(name,wlen,fsm_window_out);
%
%  --------
%   INPUTS
%  --------
%    name      :     Cell array of block names (e.g.
%                       {'R18-159_2019_02_01_1'})
%
%    wlen      :     Number of samples in state machine (Max. Window stop)
%
%  fsm_window_out :  Simulated FSM state values for duration of recording,
%                       from matlab_check_performance/SIMULATEFSM
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
DATA_DIR = 'data';
WLEN = 15;
N_MAX = inf;
PRIOR_SAMPLES = 13;

if nargin < 2
   wlen = WLEN;
end

%% GET INPUT DATA DIRECTORY
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,DATA_DIR);

%% USE RECURSION FOR MULTIPLE ENTRIES
if iscell(name)
   spikes = cell(size(name));
   for ii = 1:numel(name)
      if nargin > 2
         spikes{ii} = getFSMDetectedSpikes(name{ii},wlen,fsm_window_out{ii});
      else
         spikes{ii} = getFSMDetectedSpikes(name{ii},wlen);
      end
   end
   return;
end

%% LOAD DATA
if nargin > 3
   dac = load(fullfile(in_dir,[name params.data_suffix]));
else
   dac = load(fullfile(in_dir,[name '_DAC.mat']));
end

if nargin > 2
   trig = struct('data',fsm_window_out == 2);
else
   trig = load(fullfile(in_dir,[name '_DIG_fsm-complete.mat']));
end

%%  Find all times FSM was successfully completed
idx = find(trig.data);
idx = reshape(idx,numel(idx),1);

%% Create indexing vector for snippets
samples_prior = wlen + PRIOR_SAMPLES;
samples_after = wlen - PRIOR_SAMPLES;
vec = (-samples_prior) : samples_after;
vec = vec + idx;

%% Remove any indices out of range
exc = (vec < 1) | (vec > numel(dac.data));
vec(any(exc,2),:) = [];
idx(any(exc,2)) = [];

%% Reduce the size of the number to keep
iKeep = randperm(min(size(vec,1),N_MAX),min(size(vec,1),N_MAX));
vec = vec(iKeep,:);
idx = idx(iKeep);

spikes = dac.data(vec) * (0.195/0.0003125); % convert to uV

end
