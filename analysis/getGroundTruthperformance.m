function [t,y,type] = getGroundTruthperformance(name,fs,tolerance,clus,data_prefix)
%% GETGROUNDTRUTHPERFORMANCE  Characterize ROC for known (generated) spikes
%
%  [t,y] = GETGROUNDTRUTHPERFORMANCE(name,fs,tolerance);
%
%  --------
%   INPUTS
%  --------
%    name      :     Name of recording block (e.g. 'R18-159_2019_02_01_2')
%
%     fs       :     Sample rate (Hz)
%
%  tolerance   :     Tolerance (samples) for matching a spike or artifact
%                       detected offline.
%
%    clus      :     Index of cluster that contains spikes to match.
%
%  --------
%   OUTPUT
%  --------
%    t         :     Target (Offline) class for each spike or artifact
%
%    y         :     Observed (FSM) output class for each spike or artifact
%
%   type       :     4 --> True positive (spike)
%                    3 --> False negative (spike called as artifact)
%                    2 --> False positive (artifact called as spike)
%                    1 --> True negative (artifact)
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% DEFAULTS
if nargin < 5   
   data_prefix = 'window-generated-spikes';
end

if nargin < 4
   clus = 2; % Spike = 2, Art = 1
end

%% USE RECURSION IF CELL INPUT
if iscell(name)
   roc = cell(size(name));
   y = cell(size(name));
   t = cell(size(name));
   for ii = 1:numel(name)
      [t{ii},y{ii}] = getGroundTruthperformance(name{ii},fs,tolerance);
   end
   return;
end

%% LOAD DATA
spk = load(fullfile(pwd,data_prefix,name,[name '_wav-sneo_CAR_Spikes'],...
   [name '_ptrain_P0_Ch_000.mat']),'peak_train');
sorting = load(fullfile(pwd,data_prefix,name,[name '_wav-sneo_SPC_CAR_Sorted'],...
   [name '_sort_P0_Ch_000.mat']),'class');

%% GET SPIKE TIMES ACCORDING TO FSM
% Between the online detected times and the reject times, 
online = struct;

in = load(fullfile(pwd,data_prefix,name,[name '_wav-sneo_CAR_Spikes'],...
   [name '_ptrain_P0_Ch_000.mat']),'peak_train');
ts = in.peak_train;
in = load(fullfile(pwd,data_prefix,name,[name '_wav-sneo_SPC_CAR_Clusters'],...
   [name '_clus_P0_Ch_000.mat']),'class');
clu_online = in.class;

online.spikes = ts(clu_online == 2);
online.artifact = ts(clu_online == 1);

%% GET SPIKE TIMES ACCORDING TO OFFLINE SORTING
if issparse(spk.peak_train)
   all_spikes = find(spk.peak_train);
else
   all_spikes = spk.peak_train;
end

clu_offline = sorting.class;
offline = struct;
offline.spikes = all_spikes(ismember(clu_offline,clus));
offline.artifact = all_spikes(~ismember(clu_offline,clus));

%% PARSE ALL OBSERVED "EVENTS" AND FORMAT FOR OUTPUT
[outClass,targClass] = getAllEvents(online,offline,tolerance);
[y,t] = makeDummyArray(outClass,targClass);

type = nan(numel(outClass),1);
for ii = 1:numel(outClass)
   switch num2str([outClass(ii),targClass(ii)])
      case '1  1' % True positive
         type(ii) = 2;
      case '1  2' % False positive
         type(ii) = 3;
      case '2  1' % False negative
         type(ii) = 4;
      case '2  2' % True negative
         type(ii) = 1;
   end
end

%% FUNCTION TO TRANSLATE ARRAY
   function [outputs,targets] = makeDummyArray(outputClass,targetClass)
      % Here, code is: 1 --> spike; 2 --> artifact
      n = max(numel(unique(outputClass)),numel(unique(targetClass)));
      
      outputs = zeros(n,numel(outputClass));
      targets = zeros(n,numel(targetClass));
      
      for i = 1:n
         idxOut = outputClass==i;
         idxTar = targetClass==i;
         
         outputs(i,idxOut) = ones(1,sum(idxOut));
         targets(i,idxTar) = ones(1,sum(idxTar));
      end
   end
  

end
