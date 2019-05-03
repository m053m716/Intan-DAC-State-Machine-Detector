function [spikes,iRemove] = getSpikesFromIndex(peak_train,data,wlen)
%% GETSPIKESFROMINDEX   Get spikes from sample indices
%
%  spikes = GETSPIKESFROMINDEX(detSamples,data);
%
%  --------
%   INPUTS
%  --------
%  peak_train  :     Detected spike peak sample indices.
%
%  data        :     Data vector for spike waveform snippets.
%
%  --------
%   OUTPUT
%  --------
%    spikes    :     Matrix of spike waveforms. Rows correspond to elements
%                       of detSamples.
%
% By: Max Murphy  v1.0  2019-02-05  Original version (R2017a)

%%
if nargin < 3
   wlen = 24;
end

samples_prior = wlen + 12;
samples = 30;

%%
peak_train = reshape(peak_train,numel(peak_train),1);
vec = (-samples_prior) : (-samples_prior + samples);

vec = vec + peak_train;

exc = (vec < 1) | (vec > numel(data));
iRemove = any(exc,2);
vec(iRemove,:) = [];
spikes = data(vec);

end