clear; clc; close all force;

%% DEFINE WHAT TO RUN
% NAME = {'R18-159_2019_02_01_1'; ...
%         'R18-159_2019_02_01_2'; ...
%         'R18-159_2019_02_01_3'};
% NAME = {'R18-159_2019_02_01_2'; ...
%    'R18-159_2019_02_01_3'};
NAME = 'R18-159_2019_02_01_2';
% NAME = 'R18-43_2018_04_27_0';
FS = 30000;

%% DEFINE WINDOW PARAMETERS
% For window state machine (restrictive):
params = struct;
params.DAC_en         = [  1  1   1   1   1   1    1   1];
params.DAC_edge_type  = [  1  1   0   1   0   1    1   0]; % 0==Inc, 1==Exc
params.dac_thresholds = [-25 60 -30  -5  15 -45 -110 -40];
params.window_start   = [  0 19   7  18  22  13    4   6];
params.window_stop    = [  3 24   8  21  24  15   24   7];
params.refractory_period     = 0; % samples
params.data_suffix = '_DAC.mat';
params.dac_ratio_gain = (0.195 / 312.5e-6);
params.edge_type = 'none';
params.XLIM = [-1.0 0.4];

% For monopolar threshold:
% params = struct;
% params.DAC_en         = [  0  0   0   0   0   0    0   1];
% params.DAC_edge_type  = [  1  1   0   1   0   1    1   0]; % 0==Inc, 1==Exc
% params.dac_thresholds = [-25 60 -30  -5  15 -45 -110 -40];
% params.window_start   = [  0 19   7  18  22  13    4   0];
% params.window_stop    = [  3 24   8  21  24  15   24   1];
% params.refractory_period     = 0; % 60 samples --> 2 ms
% params.data_suffix = '_DAC.mat';
% params.dac_ratio_gain = (0.195 / 312.5e-6);
% params.edge_type = 'rising';
params.XLIM = [-1.0 0.4];

% For window state machine (ideal - thresh):
% params = struct;
% params.DAC_en         = [  0  0   0   0   0   0    0    1];
% params.DAC_edge_type  = [  1  1   0   1   1   1    1    0]; % 0==Inc,1==Exc
% params.dac_thresholds = [-25 60 -30  -5 -40  50  -60  -70];
% params.window_start   = [  0 19   7  18   2   4    0    0];
% params.window_stop    = [  3 24   8  21   8  10    5    1];
% params.refractory_period     = 0; % samples
% params.data_suffix = '_DAC-HPF-offline_P1_Ch_007.mat';
% params.dac_ratio_gain = 1;
% params.edge_type = 'rising';
% params.XLIM = [-0.6 0.4];

% For window state machine (ideal - fsm):
% params = struct;
% params.DAC_en         = [  0  0   0   0   1   1    1    1];
% params.DAC_edge_type  = [  1  1   0   1   1   0    1    0]; % 0==Inc,1==Exc
% params.dac_thresholds = [-25 60 -30  -5 -50  -90  -200  -70];
% params.window_start   = [  0 19   7  18   8   1    0    0];
% params.window_stop    = [  3 24   8  21  15   2    5    1];
% params.refractory_period     = 0; % samples
% params.data_suffix = '_DAC-HPF-offline_P1_Ch_007.mat';
% params.dac_ratio_gain = 1;
% params.edge_type = 'none';
% params.XLIM = [-0.6 0.4];

params.fs = FS;
params.make_spike_fig = false;

%% RUN SIMULATION
[fsm_window_state,fig] = simulateFSM(NAME,params);
doOfflineDACdetect(NAME,fsm_window_state,params);

%% GET SPIKES AND REJECTS
maxWindow = max(params.window_stop.*params.DAC_en);
spikes = getFSMDetectedSpikes(NAME,maxWindow,fsm_window_state,params);
rejects = getFSMRejectedSpikes(NAME,maxWindow,fsm_window_state,params);

%% PLOT SPIKES AND REJECTS
if iscell(NAME)
   all_params = repmat({params},numel(NAME),1);
else
   all_params = params;
end
   
try
   fig2 = plotFSMsnippets(NAME,spikes,rejects,all_params);
catch
   disp('Could not plot FSM snippets.');
   close(gcf);
end
