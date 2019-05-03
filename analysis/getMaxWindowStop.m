function wlen = getMaxWindowStop(fsm_window_state)
%% GETMAXWINDOWSTOP  Get the max. window stop value from state machine

% Check for error
if sum(fsm_window_state == 2) < 1
   wlen = nan;
   warning('State machine never detected a spike.');
   return;
end

% Parse max. window length, which is number of "1's" prior to 2 (complete)
idx = find(fsm_window_state == 2,1,'first');
wlen = 0;
while (fsm_window_state(idx - wlen) > 0)
   wlen = wlen + 1;
end

end