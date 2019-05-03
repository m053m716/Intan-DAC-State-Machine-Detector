function [stimWaveforms,vec,trigs] = getFSMstimsOutsideBlanking(stimName,stimVec,stimTriggers,wlen)
%% GETFSMSTIMSOUTSIDEBLANKING    Get stim waveforms outside blanking periods
%
%  stimWaveforms = GETFSMSTIMSOUTSIDEBLANKING(stimName,stimVec,stimTriggers);
%  stimWaveforms = GETFSMSTIMSOUTSIDEBLANKING(stimName,stimVec,stimTriggers,wlen);
%
%  --------
%   INPUTS
%  --------
%  stimName    :     Name of recording block. (or cell array of strings)
%
%  stimVec     :     Indexing vector from GETFSMTRIGGEREDSTIMS
%
%  stimTriggers:     Index of triggers for stimuli from
%                       GETFSMTRIGGEREDSTIMS
%
%   wlen       :     (Optional) Maximum window stop length for FSM
%
%  --------
%   OUTPUT
%  --------
%  stimWaveforms :      Waveforms corresponding to triggers that happened
%                          outside of stimulus "blanking" epochs that were
%                          preset by the Intan stimulus sequencer.
%
% By: Max Murphy  v1.0  2019-02-07  Original version (R2017a)

%% DEFAULTS
FS = 30000;             % Sample acquisition rate on amplifier channels
STIM_BLANKING_MS = 28;  % (ms) Length of refractory period after stimulus
% STIM_DELAY_MS = 10;     % (ms) Delay from trigger to stimulus
STIM_DELAY_MS = 0;
WLEN = 15;

%% PARSE INPUT
if nargin < 4
   wlen = WLEN;
end

if iscell(stimName)
   stimWaveforms = cell(size(stimName));
   vec = cell(size(stimWaveforms));
   trigs = cell(size(stimWaveforms));
   for ii = 1:numel(stimWaveforms)
      [stimWaveforms{ii},vec{ii},trigs{ii}] =...
         getFSMstimsOutsideBlanking(stimName{ii},stimVec{ii},stimTriggers{ii},wlen);
   end   
   return;
end

%% GET INPUT DATA DIRECTORY
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

%% Compute offset and blanking sample counts
stim_blanking = round(STIM_BLANKING_MS / 1000 * FS);
stim_offset = round(STIM_DELAY_MS / 1000 * FS);

% Stimuli were delivered to Probe B (P2) on amp channel B-011:
stimCommand = load(fullfile(in_dir,[stimName '_STIM.mat']));

%% Find times from outside blanking epochs
data = abs(stimCommand.data) > 0;

stim_onsets = find(diff(data)>0)+1; % Stimulus pulse ONSET
stim_offsets = find(diff(data)<0);  % Stimulus pulse OFFSET

%% Exclude any triggers that are within the BLANKING period of a stimulus
iExclude = zeros(size(stimTriggers));
for iStim = 1:numel(stim_offsets)
   idx = (stimTriggers > (stim_onsets(iStim) - stim_offset + 2*wlen)) & ...
      (stimTriggers <= (stim_offsets(iStim) + stim_blanking));
   iExclude = iExclude + idx;
end
trigs = stimTriggers(iExclude < 1);
vec = stimVec(iExclude < 1,:);

%% Return snippets based on indexing vector
dac = load(fullfile(in_dir,[stimName '_DAC.mat']));
stimWaveforms = dac.data(vec) * (0.195/0.0003125); % convert to uV

end