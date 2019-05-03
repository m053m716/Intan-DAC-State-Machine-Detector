function [vec,idx] = getFSMTriggeredStims(name,wlen,fsm_window_out)
%% GETFSMTRIGGEREDSTIMS   Get spikes detected by state machine on DAC
%
%  [vec] = GETFSMTRIGGEREDSTIMS(name);
%  [vec,idx] = GETFSMTRIGGEREDSTIMS(name,wlen,fsm_window_out);
%
%  --------
%   INPUTS
%  --------
%    name      :     Cell array of block names (e.g.
%                       {'R18-159_2019_02_01_1'})
%
%   wlen       :     (Optional) Maximum window stop length for FSM
%
%  fsm_window_out :  (Optional) Simulated FSM state values for duration of 
%                       recording, from SIMULATEFSM
%
%  --------
%   OUTPUT
%  --------
%     vec      :     Matrix of samples indices corresponding to spike
%                       waveform snippets for each spike.
%
%     idx      :     Sample indices corresponding to spikes.
%
%
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% DEFAULTS
DATA_DIR = 'data';
N_MAX = 250;
WLEN = 15;
FS = 30000;             % Amplifier sampling rate (Hz)
PRIOR_SAMPLES = 13;     % Number of samples before trigger
% STIM_DELAY_MS = 10;     % (ms) Delay from trigger to stimulus
STIM_DELAY_MS = 2;
STIM_DURATION_MS = 0.25;   % (ms) duration of stimulus

%% GET INPUT DATA DIRECTORY
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,DATA_DIR);

%% PARSE INPUT
if nargin < 2
   wlen = WLEN;
end

if iscell(name)
   vec = cell(size(name));
   idx = cell(size(vec));
    
   for ii = 1:numel(name)
      if nargin > 2
         [vec{ii},idx{ii}] = getFSMTriggeredStims(name{ii},wlen,fsm_window_out{ii});
      else
         [vec{ii},idx{ii}] = getFSMTriggeredStims(name{ii},wlen);
      end
   end
   return;
end

%% LOAD DATA
if nargin > 2
   trig = struct('data',fsm_window_out == 2);
else
   trig = load(fullfile(in_dir,[name '_DIG_fsm-complete.mat']));
end

%% GET INDEXING VECTORS
samples_prior = wlen + PRIOR_SAMPLES;
stim_offset = round(STIM_DELAY_MS / 1000 * FS);
stim_duration = round(STIM_DURATION_MS / 1000 * FS);
samples_after = round(stim_offset + stim_duration);

%%  Find all times FSM was successfully completed
idx = find(trig.data);
idx = reshape(idx,numel(idx),1);

%% Create indexing vector for snippets
vec = (-samples_prior) : samples_after;
vec = vec + idx;

%% Remove any indices out of range
dac = load(fullfile(in_dir,[name '_DAC.mat']));
exc = (vec < 1) | (vec > numel(dac.data));
vec(any(exc,2),:) = [];
idx(any(exc,2)) = [];

%% Reduce the size of the number to keep
iKeep = randperm(min(size(vec,1),N_MAX),min(size(vec,1),N_MAX));
vec = vec(iKeep,:);
idx = idx(iKeep);

end
