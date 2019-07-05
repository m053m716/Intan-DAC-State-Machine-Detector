function doOfflineDACdetect(name,fsm_window_state,params)
%% DOOFFLINEDACDETECT   Do simple threshold comparison on DAC
%
%  DOOFFLINEDACDETECT(name,fsm_window_state)
%
%  --------
%   INPUTS
%  --------
%    name      :     Name of recording block (or cell array)
%
%  --------
%   OUTPUT
%  --------
%  Makes a block in this directory where offline sorting can be done on the
%  threshold detection results from DAC.
%
% By: Max Murphy  v1.0  2019-02-05  Original version (R2017a)
%                 v1.1  2019-02-08  Modify how detection is performed (uses
%                                   fsm_window_state now)

%% DEFAULTS
COUNT_ARTIFACT = true;

if nargin < 3
   params = struct;
end

%% PARSE INPUT
if iscell(name)
   for ii = 1:numel(name)
      doOfflineDACdetect(name{ii},fsm_window_state{ii},params);
   end
   return;
end

f = fieldnames(params);
for iF = 1:numel(f)
   eval([f{iF} ' = params.(f{iF});']);
end

%% LOAD DATA
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

dac = load(fullfile(in_dir,[name data_suffix]));
data = dac.data * dac_ratio_gain;

%% DO DETECTION ON THIS CHANNEL

wlen = getMaxWindowStop(fsm_window_state);
[peak_train,class] = getSpikePeakSamples(fsm_window_state,wlen,COUNT_ARTIFACT);
[spikes,iRemove] = getSpikesFromIndex(peak_train,data,wlen);
peak_train(iRemove) = [];
class(iRemove) = [];
features = getSpikeFeatures(spikes);


pars = struct;
pars.FS = 30000;
pars.FEAT_NAMES = {'PC-1','PC-2','PC-3'}; %#ok<STRNU>


%% MAKE OUTPUT
block = fullfile(pwd,params.data_prefix,name);
if exist(block,'dir')==0
   mkdir(block);
end

spkdir = fullfile(block,[name '_wav-sneo_CAR_Spikes']);
if exist(spkdir,'dir')==0
   mkdir(spkdir);
end
save(fullfile(spkdir,[name '_ptrain_P0_Ch_000.mat']),...
   'pars','spikes','features','peak_train','-v7.3');

cludir = fullfile(block,[name '_wav-sneo_SPC_CAR_Clusters']);
if exist(cludir,'dir')==0
   mkdir(cludir);
end
save(fullfile(cludir,[name '_clus_P0_Ch_000.mat']),...
   'pars','class','-v7.3');


%% IF GROUND TRUTH IS KNOWN, MAKE "SORTED" FOLDER AS WELL
switch params.data_suffix
   case '_GeneratedGroundTruthData.mat' % Ground truth spikes are KNOWN
      load(fullfile('..','data',[name params.data_suffix]),'iPeak');
      if isfield(params,'peak_offset')
         peak_offset = params.peak_offset;
      else
         peak_offset = 25;
      end
      
      true_peaks = iPeak - peak_offset + wlen;
      pkDist = nan(size(peak_train));
      for ii = 1:numel(peak_train)
         pkDist(ii) = min(abs(true_peaks - peak_train(ii)));
         if pkDist(ii) > peak_offset
            class(ii) = 1; % "non-trigger" --> artifact --> incorrect
         else
            class(ii) = 2; % "trigger" --> spike --> correct
         end
      end
      
      sortdir = fullfile(block,[name '_wav-sneo_SPC_CAR_Sorted']);
      if exist(sortdir,'dir')==0
         mkdir(sortdir);
      end
      
      save(fullfile(sortdir,[name '_sort_P0_Ch_000.mat']),...
         'pars','class','pkDist','-v7.3');
      fprintf(1,'Finished offline detect for %s. Ground truth is known.\n',name);
   otherwise % Need to detect peak train etc.
      fprintf(1,'Finished offline detect for %s. Still needs manual sorting.\n',name);
end

end
