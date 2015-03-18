function MunkerExperiment()
%MUNKEREXPERIMENT Main function, to run the experiment
%   MATLAB is a functional programming language, this not only means that
%   you will write functions, but it requires a certain programming style.
%   A function takes variables, processes them and outputs another set of 
%   variables.  Functions can also do things, like tell the screen to
%   display something, or get some input.

%   As much as possible, a function should be it's own entity, which
%   reliably produces the same thing if given the same input.  Much bad
%   MATLAB programming comes from over use of global variables - the reason
%   global variables are bad is because when you are designing the
%   function, it could behave differently if given different global values,
%   and the more global variables you have, the more difficult it is to
%   keep track of all the possibilities a function has to deal with.  The
%   secret is to never use global variables, but instead to pass all
%   necessary variables to and from functions.
%
%   When passing variables to and from functions, you can either pass them
%   seperately in a long list, or better in a struct.  Structs are useful
%   because then you don't have to change the list of variables for each
%   function call throughout the program
%
%   When to write a function and when not?  A key idea is that (within
%   reason) you should never write similar code more than once.  If you
%   have to copy and paste something similar, you could instead write a
%   function.  Having said that, there is something to be said for keeping
%   the number of functions down, as it makes it easier to come back to, if
%   you have forgotten what all the functions do.  There is often a
%   decision to be made between using a loop, or creating a new function.
%   The computer doesn't care, really creating a function is just a way to
%   make it easier to focus on a few small thing at a time things, and to
%   not have to deal with complexity.  Therefore its often best if functions
%   reflect how you would mentally categorise different parts of the whole 
%   code.

%   In the first stage of programming experiment it's best to focus on
%   creating a function which represents a trial (or just a stimuli).  As
%   you progress you add more complexity.  The first thing I am going to do
%   is to get the function MunkerStimuli working, which will display the
%   stimuli on the screen, given the colours


%% Setting up
% Before displaying stimuli, a number of things need to be done, for
% example randomising, setting up hardware, loading pictures, setting up 
% psychtoolbox etc...
% I would just put everything in a single function (which can later go in
% its own seperate file, if you prefer.  It returns information about the
% screen which will be needed throughout the experiment, and things to
% construct the stimuli.  Note: Matlab works by loading functions as and 
% when they are needed - which takes up time.  To avoid this time upsetting
% the flow of the experiment, you can call functions in the startup (e.g.
% GetSecs) so they are already loaded.
[screen, stimuli_info] = InitialiseExperiment();

%% Displaying a stimuli
% You need to send everything the stimuli needs in order to work.  This
% includes the screen information.  You could put it all in one big struct,
% but I decided to leave the screen parameters seperate, so as to less
% likely confuse them

% Step 1: Create some dummy stimuli to test with (see DrawMunkerStimulus):

leftstimulus.stripeColourA = [ 0, 0, 0];
leftstimulus.stripeColourB = [ 255,255,255];
leftstimulus.figureColour = [155,0,0];
leftstimulus.stripeIndex = 1;
leftstimulus.imageMatrix = stimuli_info.picture;
leftstimulus.destinationRect = stimuli_info.leftRect;

rightstimulus.stripeColourA = [ 0, 0, 0];
rightstimulus.stripeColourB = [ 255,255,255];
rightstimulus.figureColour = [0,155,0];
rightstimulus.stripeIndex = 2;
rightstimulus.imageMatrix = stimuli_info.picture;
rightstimulus.destinationRect = stimuli_info.rightRect;

% Step 2: Draw the stimuli to the screen buffer
DrawMunkerStimulus(leftstimulus, screen);
DrawMunkerStimulus(rightstimulus, screen);

% Step 3: Flip the buffers (e.g. show what you just drew)
Screen('Flip',screen.ptr);

% Wait for a while...
WaitSecs(5); 

ShutDownExperiment();
end

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
    stimuli.picture = picture;
    stimuli.leftRect = leftRect;
    stimuli.rightRect = rightRect;
    
    %% Keyboard
    KbName('UnifyKeyNames');
    KbCheck;

    %% Timer
    GetSecs;
end

function ShutDownExperiment() 
    fclose('all');
    FlushEvents('keyDown');
    ListenChar(0);
    PsychPortAudio('Close');
    sca;
end

