function [screen, stimuli] = InitialiseExperiment()
    
    %% Randomisation
    rng('shuffle');
    
    %% Screen
    backgroundColour = [192 192 192];
    AssertOpenGL;
    
    % Get the screen number for displaying
    screenNumber = max(Screen('Screens'));
    
    % This can tell you what valid resolutions there are
    % resolutions = Screen('Resolutions', screenNumber);
    
    % This can tell you the current resolution (also can set the resolution
    % if you want a particular resolution
    % resolution = Screen('Resolution', screenNumber);
    
    % This is necessary when coding on a laptop...
    Screen('Preference', 'SkipSyncTests', 1);
    
    % Takes over the screen with a new window to display stimuli
    [winPtr,winRect] = Screen('OpenWindow', screenNumber, backgroundColour);
    HideCursor;
    
    % It's handy to remember the centre of the screen
    [ctrX,ctrY] = RectCenter(winRect);
    
    % Prepare output
    screen.centreX = ctrX;
    screen.centreY = ctrY;
    screen.ptr = winPtr;
    screen.rect = winRect;
    screen.number = screenNumber;
    screen.backgroundColour = backgroundColour;
    
    %% Stimuli
    % 1. Load a picture, which will be a matrix of black and white
    % 2. Add stripes as extra data
    % 3. Create at equivalent matrix with codes for each unique RGB value
    %
    % This way we can use that matrix to construct new pictures, by
    % substituting in the desired colours.  Any picture with just four
    % colours will do.
 
    % Load image:
    % must be monochrome bitmap, plus sign makes array of doubles rather
    % than logicals - 0s and 1s.
    picture = +imread('heartstimuli.bmp');
    [height, width] = size(picture);
    stripe_width = 5;
    skip = stripe_width * 2;
    for stripe_location = stripe_width : skip : width
        for vert = 1 : height
            for horiz = 1 : stripe_width
                picture(vert, stripe_location + horiz) = picture(vert, stripe_location + horiz) + 2;
            end
        end
    end
    
    picture = picture + 1;
    % Processing now leaves a matrix of indexes:
    % 1 = foreground colour a
    % 2 = background colour a
    % 3 = foreground colour b
    % 4 = background colour b
    
    % Calculate destination rectangles for location of stimuli on screen
    rect = [0,0,width,height];
    rect([2,4]) = rect([2,4]) + screen.centreY - (height / 2);
    leftRect = rect;
    rightRect = rect;
    leftRect([1,3]) = leftRect([1,3]) + screen.centreX - width - 50;
    rightRect([1,3]) = rightRect([1,3]) + screen.centreX + 50;
    
       
    % Prepare output
    stimuli.imageMatrix = picture;
    stimuli.leftDestinationRect = leftRect;
    stimuli.rightDestinationRect = rightRect;
    stimuli.stripeColourARGB = [ 0 0 0 ];
    stimuli.stripeColourBRGB = [ 255 255 255 ];

    
    %% Keyboard
    KbName('UnifyKeyNames');
    KbCheck;

    %% Timer
    GetSecs;
end
