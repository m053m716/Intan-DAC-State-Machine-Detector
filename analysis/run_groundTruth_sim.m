clear; clc; close all force;

%% DEFINE WHAT TO RUN
NAME = 'R18-159_2019_02_01_2';
FS = 30000;

% For "generated data" using known ground truth spikes superimposed on
% biological noise, using the FSM (Fig. S3)
params = struct;
params.data_prefix = 'window-generated-spikes';
params.DAC_en         = [0    0     0    0    0   0    1    1];
params.DAC_edge_type  = [1    1     1    1    1   0    1    0]; % 0==Inc, 1==Exc
params.dac_thresholds = [-140 140 -140 -140  13   5 -600  -70];
params.window_start   = [0    2     1    1    3  40    1    0];
params.window_stop    = [1    5     2    5   15  50   10   20];
params.refractory_period     = 0; % samples
params.data_suffix = '_GeneratedGroundTruthData.mat';
params.dac_ratio_gain = 1;
params.edge_type = 'none';
params.peak_offset = 25;
params.XLIM = [-1.0 3.0];
params.YLIM = [-500 250; -500 250];
params.fs = FS;
params.make_spike_fig = false;

%% RUN SIMULATION
fsm_window_state = simulateFSM(NAME,params);
doOfflineDACdetect(NAME,fsm_window_state,params);

%%
% For "generated data" using known ground truth spikes superimposed on
% biological noise, but using only a pure THRESHOLD (Fig. S3)
params = struct;
params.data_prefix = 'thresh-generated-spikes';
params.DAC_en         = [0    0     0    0    0   0    0    1];
params.DAC_edge_type  = [1    1     1    1    1   0    1    0]; % 0==Inc, 1==Exc
params.dac_thresholds = [-140 140 -140 -140  13  15 -600 -100];
params.window_start   = [0    2     1    1    3  40    1    0];
params.window_stop    = [1    5     2    5   15  60   10    1];
params.refractory_period     = 0; % samples
params.data_suffix = '_GeneratedGroundTruthData.mat';
params.dac_ratio_gain = 1;
params.edge_type = 'rising';
params.peak_offset = 0;
params.XLIM = [-0.5 1.0];
params.YLIM = [-700 300; -700 300];
params.fs = FS;
params.make_spike_fig = false;
params.wlen = 30;

%% RUN SIMULATION
fsm_window_state = simulateFSM(NAME,params);
doOfflineDACdetect(NAME,fsm_window_state,params);

%%
nameStruct = struct('sortName','Sorted',...
   'threshName','thresh-generated-spikes',...
   'windowName','window-generated-spikes');
fsm = struct;
thresh = struct;
[thresh.spk,fsm.spk] = getComparisonPerformance(NAME,FS,nameStruct);
[fsm.t,fsm.y,fsm.type] = getGroundTruthperformance(NAME,FS,25,2,'window-generated-spikes');
[thresh.t,thresh.y,thresh.type] = getGroundTruthperformance(NAME,FS,25,2,'thresh-generated-spikes');

figure('Name','FSM Ground Truth Comparison'); 
plotconfusion(fsm.t,fsm.y); 
title('FSM Ground Truth Comparison',...
   'FontName','Arial','Color','k','FontSize',16);

figure('Name','Threshold Ground Truth Comparison'); 
plotconfusion(thresh.t,thresh.y); 
title('Threshold Ground Truth Comparison',...
   'FontName','Arial','Color','k','FontSize',16);
