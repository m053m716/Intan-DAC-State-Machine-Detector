function rejects = getFSMRejectedSpikes(name,wlen,fsm_window_out,params)
%% GETFSMREJECTEDSPIKES    Get spikes rejected by state machine on DAC
%
%  rejects = GETFSMREJECTEDSPIKES(name);
%  rejects = GETFSMREJECTEDSPIKES(name,wlen,fsm_window_out);
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
%  rejects     :     Cell array same size as name. Each element contains
%                       spike waveform snippets corresponding to samples
%                       around waveforms that started the FSM but did not
%                       meet inclusion criteria for its duration.
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% DEFAULTS
DATA_DIR = 'data';
WLEN = 15;
DEBUG = false;
N_MAX = inf;

if nargin < 2
   wlen = WLEN;
end

samples_prior = wlen + 13;
samples_after = wlen - 13;

%% GET DATA DIRECTORY
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

%% USE RECURSION FOR MULTIPLE ENTRIES
if iscell(name)
   rejects = cell(size(name));
   for ii = 1:numel(name)
      if nargin > 2
         rejects{ii} = getFSMRejectedSpikes(name{ii},wlen,fsm_window_out{ii});
      else
         rejects{ii} = getFSMRejectedSpikes(name{ii},wlen);
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
   act = struct('data',fsm_window_out == 1);
   trig = struct('data',fsm_window_out == 2);
else
   act = load(fullfile(in_dir,[name '_DIG_fsm-active.mat']));
   trig = load(fullfile(in_dir,[name '_DIG_fsm-complete.mat']));
end

%%  Find all times FSM was successfully completed
idx = getFSMrejectIndices(act.data,trig.data,wlen,DEBUG) + wlen;
idx = reshape(idx,numel(idx),1);

%% Create indexing vector for snippets
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

vec = (-samples_prior) : samples_after;
vec = vec + idx;

exc = (vec < 1) | (vec > numel(dac.data));
vec(any(exc,2),:) = [];
rejects = dac.data(vec) * (0.195/0.0003125); % convert to uV

end