function [outClass,targClass] = getAllEvents(online,offline,tolerance)
%% GETALLEVENTS  Get all spike and artifact events for targets and outputs
%
%  [outClass,targClass] = GETALLEVENTS(online,offline);
%
%  --------
%   INPUTS
%  --------
%   online     :     Struct containing sample indices of events from FSM
%                       -> 'spikes'
%                       -> 'artifact'
%
%  offline     :     Struct containing sample indices of offline events
%                       -> 'spikes'
%                       -> 'artifact'
%
%  tolerance   :     Tolerance (in sample indices) for detection of a spike
%                       peak. This is non-zero, because the offline
%                       algorithm detects peaks and aligns spikes to them,
%                       while the online algorithm may assign the output
%                       sample index at an arbitrary sample relative to the
%                       peak. Recommended: at least the number of samples
%                       equivalent to the Max. Window Stop sample.
%
%  --------
%   OUTPUT
%  --------
%  outClass    :     1 x nEvent vector of output (observed) class indices.
%
%  targClass   :     1 x nEvent vector of target class indices.
%
% By: Max Murphy  v1.0  2019-02-05  Original version (R2017a)

%% PARSE INPUT
if nargin < 3
   tolerance = 5; % Conservative, could be set higher
end

%% INITIALIZE OBSERVED (OUTPUT) EVENTS AND TARGETS
outClass = [ones(1,numel(online.spikes)) ones(1,numel(online.artifact))*2];
targClass = nan(1,numel(online.spikes) + numel(online.artifact));

%% NEXT, ESTIMATE TARGETS FOR ONLINE OBSERVED SPIKES
i = 0; % indexer for targClass
k = 0; % indexer for offline.spikes
while k < numel(online.spikes)
   i = i + 1;
   k = k + 1;
   
%    [d_art,d_spk] = parseMinDistance(offline.spikes(k),online);
%    outClass(i) = parseClass(d_art,d_spk,tolerance);
   
   d_spk = parseMinDistance(online.spikes(k),offline);
   targClass(i) = parseClass(d_spk,tolerance);

end

%% LAST, ESTIMATE TARGETS FOR ONLINE OBSERVED ARTIFACT
k = 0; % indexer for offline.artifact
while k < numel(online.artifact)
   i = i + 1;
   k = k + 1;
   
%    [d_art,d_spk] = parseMinDistance(offline.artifact(k),online);
%    outClass(i) = parseClass(d_art,d_spk,tolerance);
   
   d_spk = parseMinDistance(online.artifact(k),offline);
   targClass(i) = parseClass(d_spk,tolerance);
   
end

%    function class = parseClass(d_art,d_spk,tolerance)
%       %% PARSECLASS  Get class based on distance to offline spike or art.
%       if d_spk <= tolerance
%          class = 1;
%       else
%          class = 2;
%       end
%       
% %       if d_art < d_spk % If closest thing is artifact, must be artifact
% %          class = 2;
% %       else
% %          % Otherwise, spike is closer
% %          if d_spk <= tolerance % If within tolerance, it is a spike
% %             class = 1;
% %             
% %          else % But if it's still far away, this is a "false positive"
% %             class = 2;
% %             
% %          end
% %       end
%    end
   function class = parseClass(d_spk,tolerance)
      %% PARSECLASS  Get class based on distance to offline spike or art.
      if d_spk <= tolerance
         class = 1;
      else
         class = 2;
      end
   end

%    function [d_art,d_spk] = parseMinDistance(offline_sample,online)
%       %% PARSEMINDISTANCE  Get minimum distance to "true" spike or art.
%       
%       % Should always be AFTER the OFFLINE spike
%       tmp = offline_sample - online.spikes;
% %       d_spk = min(tmp(tmp > 0));
%       d_spk = min(abs(tmp)); % *should*
%       if isempty(d_spk)
%          d_spk = inf;
%       end
%       tmp = offline_sample - online.artifact;
% %       d_art = min(tmp(tmp > 0));
%       d_art = min(abs(tmp));
%       if isempty(d_art)
%          d_art = inf;
%       end
%    end

   function d_spk = parseMinDistance(sample,targetData)
      %% PARSEMINDISTANCE  Get minimum distance to "true" spike or art.
      
      % Should always be AFTER the OFFLINE spike
      tmp = sample - targetData.spikes;

      d_spk = min(abs(tmp)); % *should*
      if isempty(d_spk)
         d_spk = inf;
      end

   end

end
