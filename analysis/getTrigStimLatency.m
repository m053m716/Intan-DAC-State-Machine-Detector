function offset = getTrigStimLatency(trigData,stimData)
%% GETTRIGSTIMLATENCY   Get the latency from trigger to stimulation
%
%  offset = GETTRIGSTIMLATENCY(trigData,stimData);
%
%  --------
%   INPUTS
%  --------
%  trigData    :     Trigger data (FSM-COMPLETE digital output)
%
%  stimData    :     Corresponding stim data (from stim channel)
%
%  --------
%   OUTPUT
%  --------
%    offset    :     Difference from each trigger to first stim sample.
%
% By: Max Murphy  v1.0  2019-02-09  Original version (R2017a)

%% 
BLANKING = 840; % # blanking samples

%%
ts = find(trigData);
offset = nan(size(ts));

for ii = 1:numel(ts)
   if (ts(ii)+1) > numel(stimData)
      offset(ii) = nan;
   elseif (any(abs(stimData(max(1,(ts(ii)-BLANKING)):(ts(ii)-2))) > 0))
      offset(ii) = nan; % it happened during blanking period
   else
      offset(ii) = find(abs(stimData((ts(ii)+1):end)) > 0,1,'first')+2;
   end
end
offset(isnan(offset)) = [];

end