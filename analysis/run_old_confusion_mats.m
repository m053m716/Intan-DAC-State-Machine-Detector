%% RUN_OLD_CONFUSION_MATS  Run confusion matrices the old way
clear; clc; close all force

%% SET INFO
NAME = {'R18-159_2019_02_01_2'};
TOL = 4;
% TOL = 10;
FS = 30000; % Hz
TYPE = {'True Spike';'False Artifact';'False Spike';'True Artifact'};
% CLUS = [2,4,5,6];
CLUS = 2;
SORTNAME = 'Sorted32';

POS = [28      850      500      500;
      535      850      500      500;
      1044     850      500      500;
      1550     850      500      500;
      2045     850      500      500;
      29       300      500      500;
      533      300      500      500;
      1046     300      500      500;
      1554     300      500      500];

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
t = cell(numel(NAME),numel(TOL));
y = cell(size(t));
type = cell(size(y));

for ii = 1:numel(NAME)
   for iT = 1:numel(TOL)
      [t{ii,iT},y{ii,iT},type{ii,iT}] = ...
         getFSMperformance(NAME{ii},FS,TOL(iT),CLUS,SORTNAME);
      
      figure('Color','w');
      str = sprintf('%s - TOL = %d',...
         strrep(NAME{ii},'_','-'),TOL(iT));
      plotconfusion(t{ii,iT},y{ii,iT},str);

      set(gcf,'Name',str);
   end
end