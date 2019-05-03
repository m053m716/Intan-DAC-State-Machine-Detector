%% RUN_COMPARISON_CONFUSION_MATS  Run confusion matrices the "new" way
clear; clc; close all force

%% SET INFO
% NAME = 'R18-159_2019_02_01_2';
NAME = 'R18-43_2018_04_27_0';
FS = 30000; % Hz
TEXT_X = [0.71 1.01 1.71 2.01];

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
[threshSpk,fsmSpk] = getComparisonPerformance(NAME,FS);

% figure('Color','w',...
%    'NumberTitle','off');
% str = sprintf('%s: Threshold Crossings',strrep(NAME,'_','-'));
% plotconfusion(threshSpk.confusion.targets,threshSpk.confusion.outputs,str);
% set(gcf,'Name',str);

figure('Color','w',...
   'NumberTitle','off');
str = sprintf('%s: State Machine Spikes',strrep(NAME,'_','-'));
plotconfusion(fsmSpk.confusion.targets,fsmSpk.confusion.outputs,str);
set(gcf,'Name',str);

%% Parse data to plot
nTrueThresholdSpikes = sum((threshSpk.target == 1) & (threshSpk.output == 1));
nFalseThresholdSpikes = sum((threshSpk.target == 2) & (threshSpk.output == 1));

nTrueFSMSpikes = sum((fsmSpk.target == 1) & (fsmSpk.output == 1));
nFalseFSMSpikes = sum((fsmSpk.target == 2) & (fsmSpk.output == 1));
c = categorical({'Threshold Comparator','State Machine Detector'});

%% Make figure
fig = figure('Name','Spike Detection Comparison',...
   'Units','Normalized',...
   'Position',[0.3 0.3 0.3 0.45],...
   'Color','w');
ax = axes(fig,'Units','Normalized',...
   'Color','w',...
   'XColor','k',...
   'YColor','k',...
   'YScale','log',...
   'FontName','Arial',...
   'Position',[0.075 0.075 0.825 0.825],...
   'NextPlot','add');
bar(ax,c,[nTrueThresholdSpikes,nFalseThresholdSpikes;...
   nTrueFSMSpikes,nFalseFSMSpikes],1.0,'EdgeColor','none');
text(ax,TEXT_X(1),nTrueFSMSpikes+100,... % For the text offset
   sprintf('N = %g',nTrueFSMSpikes),'FontName','Arial',...
   'FontSize',14,'Color','k','FontWeight','bold');
text(ax,TEXT_X(2),nFalseFSMSpikes+10,... % For the text offset
   sprintf('N = %g',nFalseFSMSpikes),'FontName','Arial',...
   'FontSize',14,'Color','k','FontWeight','bold');

text(ax,TEXT_X(3),nTrueThresholdSpikes+800,... % For the text offset
   sprintf('N = %g',nTrueThresholdSpikes),'FontName','Arial',...
   'FontSize',14,'Color','k','FontWeight','bold');
text(ax,TEXT_X(4),nFalseThresholdSpikes+5000,... % For the text offset
   sprintf('N = %g',nFalseThresholdSpikes),'FontName','Arial',...
   'FontSize',14,'Color','k','FontWeight','bold');

xlabel('Detection Method','FontName','Arial','FontSize',14,'Color','k');
ylabel('Count','FontName','Arial','FontSize',14,'Color','k');
title('Method Comparison','FontName','Arial','FontSize',16,'Color','k');
colormap('winter');
legend({'True Spikes','False Spikes'});
