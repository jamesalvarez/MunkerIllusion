function [ result ] = DoMunkerTrial( trialInfo, stimuliInfo, environment )
%DOMUNKERTRIAL Runs a single adjustment trial
    %Inputs:
    %trialInfo.adjustFigureColourHSV
    %trialInfo.fixedFigureColourHSV
    %trialInfo.adjustStripeIndex
    %trialInfo.fixedStripeIndex
    %trialInfo.adjustSide

    %stimuliInfo.stripeColourARGB
    %stimuliInfo.stripeColourBRGB
    %stimuliInfo.imageMatrix
    %stimuliInfo.leftDestinationRect
    %stimuliInfo.rightDestinationRect
    
    
    % Unpackage this struct to local variables, to make it easier to use.
    screen = environment.screen;
    keys = environment.keys;


    % Fill the adjustStimulus and fixedStimulus structs for the
    % DrawMunkerStimulus function, with the initial colours etc.  RGB
    % values are in this case 0 - 255, whereas HSV are 0 - 1.  hsv2rgb
    % converts the HSV to RGB (0 - 1), but this then needs to be multiplied
    % by 255 to get to the correct RGB (0 - 255)
    adjustStimulus.stripeColourA = stimuliInfo.stripeColourARGB;
    adjustStimulus.stripeColourB = stimuliInfo.stripeColourBRGB;
    adjustStimulus.figureColour = 255 * hsv2rgb(trialInfo.adjustFigureColourHSV);
    adjustStimulus.stripeIndex = trialInfo.adjustStripeIndex;
    adjustStimulus.imageMatrix = stimuliInfo.imageMatrix;
    
    fixedStimulus.stripeColourA = stimuliInfo.stripeColourARGB;
    fixedStimulus.stripeColourB = stimuliInfo.stripeColourBRGB;
    fixedStimulus.figureColour = 255 * hsv2rgb(trialInfo.fixedFigureColourHSV);
    fixedStimulus.stripeIndex = trialInfo.fixedStripeIndex;
    fixedStimulus.imageMatrix = stimuliInfo.imageMatrix;
    
   
    % Depending on this variable (trialInfo.adjustSide), the participant
    % can adjust the colours of either the left or right, with the other
    % being fixed
    if trialInfo.adjustSide == 1
        adjustStimulus.destinationRect = stimuliInfo.leftDestinationRect;
        fixedStimulus.destinationRect = stimuliInfo.rightDestinationRect;
    else
        adjustStimulus.destinationRect = stimuliInfo.rightDestinationRect;
        fixedStimulus.destinationRect = stimuliInfo.leftDestinationRect;
    end
 
    adjustFigureHSV = trialInfo.adjustFigureColourHSV; 

    %flag to determine when trial is done
    chosingColour = true;
    
    %how much to adjust HSV parameter on press of a key
    change_increment_min = Constants.changeIncrementMin; %small adjustments when tapping
    change_increment_per_sec = Constants.changeIncrementPerSec; %larger adjustments when holding
    change_increment = 0; %variable to hold current change increment
    
    %variable to store last pressed key and time
    lastKeyPressed = 0;
    lastSecs = GetSecs;
    keyDownSecs = GetSecs;
    minKeyTime = Constants.minKeyTime; %you have to hold key for half second before it scrolls fast

    while (chosingColour)
        % Set the colour from the adjustFigureHSV value
        adjustStimulus.figureColour = 255 * hsv2rgb(adjustFigureHSV);
        
        % Clear the screen and draw the stimuli
        Screen('FillRect',screen.ptr,screen.backgroundColour);
        DrawMunkerStimulus(adjustStimulus, screen);
        DrawMunkerStimulus(fixedStimulus, screen);
        Screen('Flip',screen.ptr);
        
        % Wait for a key press from one of the keysToCheck
        [keyPressed, sameKey, secs] = GetPressedKey(keys.keysToCheck, lastKeyPressed);
        
        
        % This section of code deals with the logic for ensuring taps
        % produce a small change where, holding producing a large change. 
        % Basically if a new key is pressed, it does a small change, but if
        % that key is held over minKeyTime, then it does continuos large 
        % changes according to the time difference from the returned
        % function, which will mean that the speed of change will be roughly the
        % same on any computer.
        %
        % The beep command is useful for debugging so you can hear when a 
        % section of code is reached, I have commented it out, but if you
        % reinstate the beeps, you can here when the program changes colour
        if sameKey
            keyTime = secs - keyDownSecs;
            if keyTime > minKeyTime %only increment if key held enough
                %beep
                change_increment = (secs - lastSecs) * change_increment_per_sec;
            else
                change_increment = 0;
            end
        else
            keyDownSecs = secs;
            change_increment = change_increment_min;
            %beep  
        end
        
        lastSecs = secs;
        lastKeyPressed = keyPressed;
        
        
        % Adjust the adjustFigureHSV colour, dependent on what key pressed
        % using min and max to prevent the colour from going above 1 or
        % below 1. If change_increment is 0, then no change occurs.
        switch(keyPressed)
            case keys.keyHueUp
                adjustFigureHSV(1) = min(1,adjustFigureHSV(1) + change_increment);
            case keys.keyHueDown
                adjustFigureHSV(1) = max(0,adjustFigureHSV(1) - change_increment);
            case keys.keySatUp
                adjustFigureHSV(2) = min(1,adjustFigureHSV(2) + change_increment);
            case keys.keySatDown
                adjustFigureHSV(2) = max(0,adjustFigureHSV(2) - change_increment);
            case keys.keyValUp
                adjustFigureHSV(3) = min(1,adjustFigureHSV(3) + change_increment);
            case keys.keyValDown
                adjustFigureHSV(3) = max(0,adjustFigureHSV(3) - change_increment);
            case keys.keyDone
                chosingColour = false; %now the while loop wont continue

        end
    end

    % Clear the screen to background colour
    Screen('FillRect',screen.ptr,screen.backgroundColour);
    Screen('Flip',screen.ptr);
    result = adjustFigureHSV;

end


