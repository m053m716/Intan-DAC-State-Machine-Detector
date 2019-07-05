function fig = plotFSMsnippets(name,snippets,rejects,params)
%% PLOTFSMSPIKES  Plot spikes detected on DAC FSM
%
% fig = PLOTFSMSPIKES(name,spikes,rejects,params);
%
% --------
%  INPUTS
% --------
% name       :     Cell array of block names
%
% snippets   :     Cell array of "good" spikes or waveforms
%
% rejects    :     Cell array of "rejected" spikes or waveforms
%
% params     :     Cell array of parameters used for FSM on DAC
%
% --------
%  OUTPUT
% --------
% fig        :     Cell array of figure handles produced
%
% By: Max Murphy v1.0   2019-02-04  Original version (R2017a)

%% DEFAULTS
FS = 30000;          % Hz
N_SPIKES  = 250;     % Max. number of spike waveforms to plot
N_REJECTS = 250;     % Max. number of rejected waveforms to plot
PRE_SAMPLES = 13;    % Number of samples prior to waveform
% STIM_DELAY_MS = 10;  % (ms) Delay between spike trigger and STIM onset
STIM_DELAY_MS = 0;
STIM_TOTAL_DURATION_MS = 0.2; % (ms) Total duration of stim (both phases)
YLIM = [-200 200;-250 100];   % Y-axis limits (micro-volts)
XLIM = [-0.6 0.4]; % X-axis limits (ms)

%% USE RECURSION TO ITERATE
if iscell(name)
   fig = cell(size(name));
   for ii = 1:numel(name)
      fig{ii} = plotFSMsnippets(name{ii},snippets{ii},rejects{ii},params{ii});
   end
   return;
end

if isfield(params,'XLIM')
   XLIM = params.XLIM;
end

%% PARSE INPUT
dacParams = parseParams(params);

% Offset by 2 samples to account for delay on trigger:
T = 0 : (size(snippets,2)-1);
T = T - (dacParams.wMax + PRE_SAMPLES) + 2;
t = T / FS * 1000;

%% MAKE FIGURE
fig = figure('Name',['DAC spikes: ' name],...
   'Units','Normalized',...
   'Color','w',...
   'Position',[0.1,0.45,0.35,0.45]);
if isnan(XLIM(1))
   xl = [min(t) max(t)];
else
   xl = XLIM;
end
if isempty(rejects) % If rejects empty --> stim waveforms
   ax = axes(fig,'Color','w',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8],...
   'NextPlot','add',...
   'XLimMode','manual',...
   'XLim',xl,...
   'XColor','k',...
   'YLimMode','manual',...
   'YLim',YLIM(1,:),...
   'YColor','k',...
   'FontName','Arial',...
   'FontSize',12);

   % Plot prior segment (not yet in FSM)
   iStart = (PRE_SAMPLES - 2);
   samples = 1:iStart;
   plot(ax,t(samples),snippets(:,samples),...
      'Color',[0.0 0.0 0.0],...
      'Linewidth',1.5);
   
   % Plot initial (trigger segment)
   iStop = iStart + dacParams.wMax;
   samples = iStart:iStop;
   plot(ax,t(samples),snippets(:,samples),...
      'Color',[0.1 0.1 0.8],...
      'Linewidth',1.5);
   
   % Add intermediate segments (5-sample delay for sequencer)
   iStim = iStop + 5 + (STIM_DELAY_MS / 1000 * FS);
   samples = iStop:iStim;
   plot(ax,t(samples),snippets(:,samples),...
      'Color',[0.0 0.0 0.0],...
      'Linewidth',1.5);
   
   % Add stim part
   iStimStop = size(snippets,2);
   samples = iStim:iStimStop;
   plot(ax,t(samples),snippets(:,samples),...
      'Color',[0.8 0.1 0.1],...
      'Linewidth',1.5);

   addLevels(ax,dacParams,FS,1.5,5);
else % Otherwise plot rejected spikes and overlay detected ones

   ax = axes(fig,'Color','w',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8],...
   'NextPlot','add',...
   'XLimMode','manual',...
   'XLim',xl,...
   'XColor','k',...
   'YLimMode','manual',...
   'YLim',YLIM(2,:),...
   'YColor','k',...
   'FontName','Arial',...
   'FontSize',12);

   % Plot rejects first
   if N_REJECTS > size(rejects,1)
      plot(ax,t,rejects.',...
         'Color',[0.85 0.85 0.85],...
         'Linewidth',1.75);
   else
      plot(ax,t,rejects(randperm(size(rejects,1),N_REJECTS),:).',...
         'Color',[0.85 0.85 0.85],...
         'Linewidth',1.75);
   end
   hold on;
   % Overlay spikes
   if N_SPIKES > size(snippets,1)
      plot(ax,t,snippets.',...
         'Color',[0.6 0.1 0.8],...
         'Linewidth',1.75);
   else
      plot(ax,t,snippets(randperm(size(snippets,1),N_SPIKES),:).',...
         'Color',[0.6 0.1 0.8],...
         'Linewidth',1.75);
      
   end
   % Add threshold levels
   addLevels(ax,dacParams,FS,3,15);
end

xlabel('Time (ms)','FontName','Arial','FontSize',14,'Color','k');
ylabel('Amplitude (\muV)','FontName','Arial','FontSize',14,'Color','k');
title('FSM Detected Spikes','FontName','Arial','FontSize',18,'Color','k');

   function dacParams = parseParams(params)
      %% PARSEPARAMS    Get parameters from different kinds of input struct
      dacParams = struct;
      if numel(params) > 1
         dacParams.wStart = [params.window_start_sample];
         dacParams.wStop = [params.window_stop_sample];
         dacParams.wThresh = [params.voltage_threshold];
         dacParams.wType = [params.trigger_window_type];
         dacParams.wMax = max([params.window_stop_sample]);
         dacParams.n = numel(params);
      else
         dacParams.wStart = params.window_start(logical(params.DAC_en));
         dacParams.wStop = params.window_stop(logical(params.DAC_en));
         dacParams.wThresh = params.dac_thresholds(logical(params.DAC_en));
         dacParams.wType = params.DAC_edge_type(logical(params.DAC_en));
         dacParams.wMax = max(dacParams.wStop);
         dacParams.n = sum(params.DAC_en);
      end
   end

   function addLevels(ax,dacParams,fs,lineWidth,markerSize)
      %% ADDLEVELS   Add window threshold levels to figure
      for iP = 1:dacParams.n
         x = [dacParams.wStart(iP), dacParams.wStop(iP)-0.9];
         x = x - dacParams.wMax - 1; % extra sample for trigger
         x = x/fs*1000;
         y = [dacParams.wThresh(iP), dacParams.wThresh(iP)];
         ie = dacParams.wType(iP);
         
         if ie == 0
            line(ax,x,y,'Color','c','LineWidth',lineWidth,...
               'Marker','o','MarkerFaceColor','k',...
               'MarkerIndices',1,'MarkerSize',markerSize);
         else
            line(ax,x,y,'Color','r','LineWidth',lineWidth,...
               'Marker','o','MarkerFaceColor','k',...
               'MarkerIndices',1,'MarkerSize',markerSize);
         end
      end
   end


end