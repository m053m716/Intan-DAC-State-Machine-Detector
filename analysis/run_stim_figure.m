%% RUN_STIM_FIGURE   Make stimulus artifact figure
clear; close all force; clc;

%% GET STIMS
% stimName = 'R18-159_2019_02_01_3';
stimName = 'R18-159_2019_01_31_2';
stimParams = getFSMParams(stimName);
wlen = max([stimParams.window_stop_sample]);
[stimWaveSamples,stimTriggers] = getFSMTriggeredStims(stimName,wlen);
stimWaveforms = getFSMstimsOutsideBlanking(stimName,stimWaveSamples,...
   stimTriggers,wlen);

%% PLOT STIMS
try
   fig3 = plotFSMsnippets(stimName,stimWaveforms,[],stimParams);
catch
   disp('Could not plot FSM stimuli.');
   close(gcf);
end

