function [t,y,type] = plotConfusionMatrices(~,keyEvent,fig)
%% PLOTCONFUSIONMATRICES  Function for generating confusion matrices
%
%  [t,y,type] = PLOTCONFUSIONMATRICES;
%
%  --------
%   OUTPUT
%  --------
%     t        :     Cell array of target event classes
%
%     y        :     Cell array of observed classes
%
%    type      :     Cell array of classification types for each event
%
% By: Max Murphy  v1.0  2019-02-09 Original version (R2017a)

%% SET INFO
NAME = 'R18-159_2019_02_01_2';
TOL = 10;   % n Samples
FS = 30000; % Hz
TYPE = {'True Spike';'False Artifact';'False Spike';'True Artifact'};
% CLUS = 1:9;
SORTNAME = 'SortedsubClust';
POS = [100     900      400      400;
   550     900      400      400;
   1000     900      400      400;
   100     475      400      400;
   550     475      400      400;
   1000     475      400      400;
   100      50      400      400;
   550      50      400      400;
   1000      50      400      400];

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
% t = cell(size(CLUS));
% y = cell(size(CLUS));
% type = cell(size(CLUS));

% for iC = 1:numel(CLUS)
%    [t{iC},y{iC},type{iC}] = ...
%       getFSMperformance(NAME,FS,TOL,CLUS(iC),SORTNAME);
%
%    figure(fig{iC});
%    str = sprintf('%s - CLUS %d',...
%       strrep(NAME,'_','-'),CLUS(iC)-1);
%    plotconfusion(t{iC},y{iC},str);
%
%    set(gcf,'Name',str);
%    set(gcf,'Color','w');
%    set(gcf,'Position',POS(iC,:));
% end

switch keyEvent.Key
   case {'1','numpad1'}
      CLUS = 1;
   case {'2','numpad2'}
      CLUS = 2;
   case {'3','numpad3'}
      CLUS = 3;
   case {'4','numpad4'}
      CLUS = 4;
   case {'5','numpad5'}
      CLUS = 5;
   case {'6','numpad6'}
      CLUS = 6;
   case {'7','numpad7'}
      CLUS = 7;
   case {'8','numpad8'}
      CLUS = 8;
   case {'9','numpad9'}
      CLUS = 9;
   otherwise
      CLUS = 1:9;
end

for iC = 1:numel(CLUS)
   [t,y,type] = ...
      getFSMperformance(NAME,FS,TOL,CLUS(iC),SORTNAME);

   figure(fig{CLUS(iC)});
   str = sprintf('%s - CLUS %d',...
      strrep(NAME,'_','-'),CLUS(iC)-1);
   plotconfusion(t,y,str);

   set(gcf,'Name',str);
   set(gcf,'Color','w');
   set(gcf,'Position',POS(CLUS(iC),:));
end

% Assign to figure via:
% >> set(gcf,'WindowKeyPressFcn',@{plotConfusionMatrices,fig});
%

end