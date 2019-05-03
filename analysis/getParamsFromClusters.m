function out = getParamsFromClusters(name,clus)
%% GETPARAMSFROMCLUSTERS   Recover best window parameters given clustering
%
%  params = GETPARAMSFROMCLUSTERS(name);
%  params = GETPARAMSFROMCLUSTERS(name,clus);
%
%  --------
%   INPUTS
%  --------
%    name      :     Name of block (string/char) or cell array of block
%                       names.
%
%    clus      :     Index of cluster to match parameters for spike.
%
%  --------
%   OUTPUT
%  --------
%   params     :     Parameters struct as used in RUN_SIMULATIONS.
%
% By: Max Murphy  v1.0  2019-02-08  Original version (R2017a)

%% DEFAULTS
LOWER_BOUND = 0.05;
UPPER_BOUND = 0.095;

%% PARSE INPUT

if nargin < 2
   clus = 2;
end

if iscell(name)
   out = cell(size(name));
   for ii = 1:numel(name)
      out{ii} = getParamsFromClusters(name{ii},clus);
   end
   return;
end

%% LOAD SPIKES
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

spk = load(fullfile(in_dir,[name '_DAC_spikes.mat']));
sorting = load(fullfile(in_dir,[name '_DAC_sort.mat']));

%% GET PERCENTILE VALUES FOR EACH SAMPLE OF SPIKE
spikes = spk.spikes(sorting.class == clus,:);

out = nan(2,size(spikes,2));
iLowerBound = max(floor(size(spikes,1) * LOWER_BOUND),1);
iUpperBound = min(ceil(size(spikes,1) * UPPER_BOUND),size(spikes,1));

for ii = 1:size(spikes,2)
   tmp = sort(spikes(:,ii),'ascend');
   out(1,ii) = tmp(iUpperBound);
   out(2,ii) = tmp(iLowerBound);
end

end