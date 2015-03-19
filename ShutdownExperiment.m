function ShutdownExperiment() 
    fclose('all');
    FlushEvents('keyDown');
    ListenChar(0);
    PsychPortAudio('Close');
    sca;
end