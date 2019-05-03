function [peak_train,class] = getSpikePeakSamples(fsm_window_state,wlen,countArt)
%% GETSPIKEPEAKSAMPLES  Get spike peaks as detected on DAC
%
%  [peak_train,class] = GETSPIKEPEAKSAMPLES(fsm_window_state);
%
%  --------
%   INPUTS
%  --------
%  fsm_window_state  :  State vector (0 1 2) that is duration of data.
%
%  wlen              :  (Optional) Max window stop (samples)
%
%  countArt          :  (Optional) default is true; if false only look at
%                          spikes detected
%
%  --------
%   OUTPUT
%  --------
%  peak_train     :     Detected peak sample indices.
%
%    class        :     Class for detected spikes
%
% By: Max Murphy  v1.0  2019-02-05  Original version (R2017a)

%% PARSE INPUT
if nargin < 2
   wlen = 24;
end

if nargin < 3
   countArt = true;
end

%% GET PEAKS DEPENDING ON WINDOW STATE
fsmActive = fsm_window_state == 1;
fsmComplete = fsm_window_state == 2;

if (logical(countArt))
   idx = find(fsmActive);
   idx = reshape(idx,numel(idx),1);
   idx = idx([true;diff(idx) > 1]); % Want points of "entry"
   idx = idx + wlen - 1;
else
   idx = find(fsmComplete);
end
idx(idx > numel(fsm_window_state)) = [];
class = fsm_window_state(idx);  

[peak_train,idx] = unique(idx);
class = class(idx);

end