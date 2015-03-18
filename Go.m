% When your making the experiment, you have to run it to test, but
% loads of times it will crash.  This func solves two things a) instead of
% typing the whole name to start the experiment, you just type Go. b) if
% there is a crash, it closes the psychtoolbox windows so you don't get
% stuck.  This is a problem with debugging psychtoolbox - if you want to
% set a break point to go through some code, put 'sca' temporarily before
% the breakpoint, otherwise you can't actually step through or do anything
% - however this will mean you can't draw to the screen.

function Go()
    try
        MunkerExperiment();
    catch err
        sca;
        
        rethrow(err);
    end
end

