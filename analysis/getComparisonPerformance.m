function [threshSpk,fsmSpk] = getComparisonPerformance(name,fs,nameStruct)
%% GETCOMPARISONPERFORMANCE  Characterize ROC for FSM detection performance
%
%  [threshSpk,fsmSpk] = GETCOMPARISONPERFORMANCE(name,fs);
%
%     or
%
%  nameStruct = struct('sortName','Sorted',...
%                      'threshName','thresh-generated-spikes',...
%                      'windowName','window-generated-spikes');
%  [threshSpk,fsmSpk] = GETCOMPARISONPERFORMANCE(name,fs,nameStruct);
%
%  --------
%   INPUTS
%  --------
%    name      :     Name of recording block (e.g. 'R18-159_2019_02_01_2')
%
%     fs       :     Sample rate (Hz)
%
%   nameStruct :     (Optional) struct with fields corresponding to names
%                       of the sortcode ('sortName'), thresholded spikes
%                       prefix folder ('threshName'), and FSM spikes prefix
%                       folder ('windowName').
%
%  --------
%   OUTPUT
%  --------
%  threshSpk   :     Struct with data about threshold crossing spikes
%
%   fsmSpk     :     Struct with data about state machine detector spikes
%
% By: Max Murphy  v1.0  2019-02-11  Original version (R2017a)

%% DEFAULTS
sortName = 'Sorted';
threshName = 'thresh-spikes';
windowName = 'online-spikes-art';
if nargin > 3
   if isfield(nameStruct,'sortName')
      sortName = nameStruct.sortName;
   end
   
   if isfield(nameStruct,'threshName')
      sortName = nameStruct.threshName;
   end
   
   if isfield(nameStruct,'windowName')
      windowName = nameStruct.windowName;
   end
end

%% USE RECURSION IF CELL INPUT
if iscell(name)
   threshSpk = cell(size(name));
   fsmSpk = cell(size(name));
   for ii = 1:numel(name)
      [threshSpk,fsmSpk] = getComparisonPerformance(name{ii},fs,sortName);
   end
   return;
end

%% LOAD THRESHOLD SPIKE DATA
load(fullfile(pwd,threshName,name,[name '_wav-sneo_CAR_Spikes'],...
   [name '_ptrain_P0_Ch_000.mat']),'peak_train');
detected = load(fullfile(pwd,threshName,name,[name '_wav-sneo_SPC_CAR_Clusters'],...
   [name '_clus_P0_Ch_000.mat']),'class');
sorted = load(fullfile(pwd,threshName,name,[name '_wav-sneo_SPC_CAR_' sortName],...
   [name '_sort_P0_Ch_000.mat']),'class');

threshSpk = makeSpikeStruct(peak_train,sorted.class,detected.class,fs);

%% GET SPIKE TIMES ACCORDING TO FSM
load(fullfile(pwd,windowName,name,[name '_wav-sneo_CAR_Spikes'],...
   [name '_ptrain_P0_Ch_000.mat']),'peak_train');
detected = load(fullfile(pwd,windowName,name,[name '_wav-sneo_SPC_CAR_Clusters'],...
   [name '_clus_P0_Ch_000.mat']),'class');
sorted = load(fullfile(pwd,windowName,name,[name '_wav-sneo_SPC_CAR_' sortName],...
   [name '_sort_P0_Ch_000.mat']),'class');
fsmSpk = makeSpikeStruct(peak_train,sorted.class,detected.class,fs);

%% PARSE ALL OBSERVED "EVENTS" AND FORMAT FOR OUTPUT
threshSpk.confusion = makeDummyArray(threshSpk.output,threshSpk.target);
fsmSpk.confusion = makeDummyArray(fsmSpk.output,fsmSpk.target);

%% FUNCTION TO TRANSLATE ARRAY
   function confusionStruct = makeDummyArray(outputClass,targetClass)
      % Here, code is: 1 --> spike; 2 --> artifact
      n = max(numel(unique(outputClass)),numel(unique(targetClass)));
      
      outputs = zeros(n,numel(outputClass));
      targets = zeros(n,numel(targetClass));
      
      for i = 1:n
         idxOut = outputClass==i;
         idxTar = targetClass==i;
         
         outputs(i,idxOut) = 1;
         targets(i,idxTar) = 1;
      end
      confusionStruct.outputs = outputs;
      confusionStruct.targets = targets;
   end

   function spikeStruct = makeSpikeStruct(peak_train,sortedClass,detectedClass,fs)
      spikeStruct = struct;
      N = numel(peak_train);
      spikeStruct.idx = peak_train;
      spikeStruct.ts = spikeStruct.idx / fs;
      spikeStruct.target = nan(size(sortedClass)); % switch so spike is "1" (for matrix)
      spikeStruct.target(sortedClass == 2) = 1;
      spikeStruct.target(sortedClass ~= 2) = 2;
      tmp = double(detectedClass == 2);
      tmp(detectedClass ~=2) = 2;
      spikeStruct.output = tmp; % switch so spike is "1"
      spikeStruct.output = reshape(spikeStruct.output,N,1);
      spikeStruct.target = reshape(spikeStruct.target,N,1);
   end
  

end
