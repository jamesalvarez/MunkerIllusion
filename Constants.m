classdef Constants
    %CONSTANTS Contains adjustable parameters for the experiment
    

   properties (Constant)
      % Starting colours to use
      startingColoursRGB = [ 10, 10, 10;...
                             20, 50, 60;...
                             70, 130, 20;...
                             255, 0, 23;...
                             89, 100, 0;...
                             0, 250, 46;...
                             34, 12, 120;...
                             60, 0, 200 ];
       
       
      % General stimulus properties
      backgroundColour = [192 192 192];
      picture = +imread('heartstimuli.bmp');
      distanceBetweenPics = 100;
      stripeColourARGB = [ 255 0 0 ];
      stripeColourBRGB = [ 255 0 255 ];
      
      % Keys
      keyHueUp = KbName('q');
      keyHueDown = KbName('a');
      keySatUp = KbName('w');
      keySatDown = KbName('s');
      keyValUp = KbName('e');
      keyValDown = KbName('d');
      keyDone = KbName('space');
      
      % Key timing
      minKeyTime = 0.5 %time to hold key before continuous change
      changeIncrementMin = 1 / 255; %small adjustments when tapping
      changeIncrementPerSec = 0.5; % 1 is entire gamut (e.g. 0 - 255)
   
      % ISI
      ISI = 1; %seconds
   end
    
end

