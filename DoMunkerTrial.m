function [ result ] = DoMunkerTrial( trialInfo, stimuliInfo, screen )
%DOMUNKERTRIAL Runs a single adjustment trial
    %Inputs:
    %trialInfo.leftFigureColourHSV
    %trialInfo.rightFigureColourHSV
    %trialInfo.leftStripeIndex
    %trialInfo.rightStripeIndex
    %trialInfo.adjustSide

    %stimuliInfo.stripeColourARGB
    %stimuliInfo.stripeColourBRGB
    %stimuliInfo.imageMatrix
    %stimuliInfo.leftDestinationRect
    %stimuliInfo.rightDestinationRect


    % Fill the leftStimulus and rightStimulus structs for the
    % DrawMunkerStimulus function, with the initial colours etc.  RGB
    % values are in this case 0 - 255, whereas HSV are 0 - 1.  hsv2rgb
    % converts the HSV to RGB (0 - 1), but this then needs to be multiplied
    % by 255 to get to the correct RGB (0 - 255)
    leftStimulus.stripeColourA = stimuliInfo.stripeColourARGB;
    leftStimulus.stripeColourB = stimuliInfo.stripeColourBRGB;
    leftStimulus.figureColour = 255 * hsv2rgb(trialInfo.leftFigureColourHSV);
    leftStimulus.stripeIndex = trialInfo.leftStripeIndex;
    leftStimulus.imageMatrix = stimuliInfo.imageMatrix;
    leftStimulus.destinationRect = stimuliInfo.leftDestinationRect;

    rightStimulus.stripeColourA = stimuliInfo.stripeColourARGB;
    rightStimulus.stripeColourB = stimuliInfo.stripeColourBRGB;
    rightStimulus.figureColour = 255 * hsv2rgb(trialInfo.rightFigureColourHSV);
    rightStimulus.stripeIndex = trialInfo.rightStripeIndex;
    rightStimulus.imageMatrix = stimuliInfo.imageMatrix;
    rightStimulus.destinationRect = stimuliInfo.rightDestinationRect;

    % Depending on this variable (trialInfo.adjustSide), the participant
    % can adjust the colours of either the left or right, with the other
    % being fixed
    if trialInfo.adjustSide == 1
        fixedStimulus = rightStimulus;
        adjustStimulus = leftStimulus; %adjust left stimulus
        adjustFigureHSV = trialInfo.leftFigureColourHSV;
    else
        fixedStimulus = leftStimulus;
        adjustStimulus = rightStimulus; %adjust right stimulus
        adjustFigureHSV = trialInfo.rightFigureColourHSV;
    end

    % These store codes for each key in a variable, probably worth moving
    % these to the Initialise experiment routine, and passing them here in
    % one of the structs
    
    keyHueUp = KbName('q');
    keyHueDown = KbName('a');
    keySatUp = KbName('w');
    keySatDown = KbName('s');
    keyValUp = KbName('e');
    keyValDown = KbName('d');
    keyDone = KbName('space');
    
    %A list of keys to check
    keysToCheck = [keyHueUp, keyHueDown, keySatUp,... 
                   keySatDown, keyValUp, keyValDown,...
                   keyDone];


    %flag to determine when trial is done
    chosingColour = true;
    
    %how much to adjust HSV parameter on press of a key
    change_increment = 1 / 255;

    while (chosingColour)
        % Set the colour from the adjustFigureHSV value
        adjustStimulus.figureColour = 255 * hsv2rgb(adjustFigureHSV);
        
        % Clear the screen and draw the stimuli
        Screen('FillRect',screen.ptr,screen.backgroundColour);
        DrawMunkerStimulus(adjustStimulus, screen);
        DrawMunkerStimulus(fixedStimulus, screen);
        Screen('Flip',screen.ptr);
        
        % Wait for a key press from one of the keysToCheck
        keyPressed = GetPressedKey(keysToCheck);
        
        % Adjust the adjustFigureHSV colour, dependent on what key pressed
        % using min and max to prevent the colour from going above 1 or
        % below 1.
        switch(keyPressed)
            case keyHueUp
                adjustFigureHSV(1) = min(1,adjustFigureHSV(1) + change_increment);
            case keyHueDown
                adjustFigureHSV(1) = max(0,adjustFigureHSV(1) - change_increment);
            case keySatUp
                adjustFigureHSV(2) = min(1,adjustFigureHSV(2) + change_increment);
            case keySatDown
                adjustFigureHSV(2) = max(0,adjustFigureHSV(2) - change_increment);
            case keyValUp
                adjustFigureHSV(3) = min(1,adjustFigureHSV(3) + change_increment);
            case keyValDown
                adjustFigureHSV(3) = max(0,adjustFigureHSV(3) - change_increment);
            case keyDone
                chosingColour = false; %now the while loop wont continue

        end
    end

    % Clear the screen to background colour
    Screen('FillRect',screen.ptr,screen.backgroundColour);
    Screen('Flip',screen.ptr);
    result = adjustFigureHSV;

end


