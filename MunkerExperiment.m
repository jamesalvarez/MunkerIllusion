function MunkerExperiment()
%MUNKEREXPERIMENT Main function, to run the experiment
%   


%% Setting up
% Setup hardware, loading pictures, setup psychtoolbox etc...
[screen, stimuliInfo] = InitialiseExperiment();

%% Displaying a trial

% Create a dummy trial:
trialInfo.leftFigureColourHSV = rgb2hsv([1,0,0]);
trialInfo.rightFigureColourHSV = rgb2hsv([0,0,1]);
trialInfo.leftStripeIndex = 1;
trialInfo.rightStripeIndex = 2;
trialInfo.adjustSide = 1; %(1 or 2)

result = DoMunkerTrial(trialInfo,stimuliInfo,screen);

disp(result);


ShutdownExperiment();
end






