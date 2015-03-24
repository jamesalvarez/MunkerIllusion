function MunkerExperiment()
%MUNKEREXPERIMENT Main function, to run the experiment
%   


%% Setting up
% Setup hardware, loading pictures, setup psychtoolbox etc...
[environment, stimuliInfo] = InitialiseExperiment();

%% Displaying a trial

% Create a dummy trial:
trialInfo.adjustFigureColourHSV = rgb2hsv([1,0,0]);
trialInfo.fixedFigureColourHSV = rgb2hsv([0,0,1]);
trialInfo.adjustStripeIndex = 1;
trialInfo.fixedStripeIndex = 2;
trialInfo.adjustSide = 1; %(1 or 2)

result = DoMunkerTrial(trialInfo,stimuliInfo,environment);

disp(result);


ShutdownExperiment();
end






