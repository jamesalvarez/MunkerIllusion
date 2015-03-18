function DrawMunkerStimulus( stimulus, screen )
%Draws a Munker stimulus to the screen
    %
    %   stimulus is struct containing fields:
    %       stripeColourA
    %       stripeColourB
    %       figureColour
    %       stripeIndex (1 for drawing foreground on A, 2 for B)
    %       destinationRect (location to draw)
    %       imageMatrix (matrix of indexes 1 to 4)
    %
    %   screen is a struct containing
    %       centreX
    %       centreY
    %       ptr
    %       rect
    %       number

    % Step 1: Get seperate matrices for red / green / blue for all four colour
    % indexes, set them to stripe colours a and b.
    red     = [stimulus.stripeColourA(1),...
               stimulus.stripeColourA(1),...
               stimulus.stripeColourB(1),...
               stimulus.stripeColourB(1)];

    green   = [stimulus.stripeColourA(2),...
               stimulus.stripeColourA(2),...
               stimulus.stripeColourB(2),...
               stimulus.stripeColourB(2)];

    blue    = [stimulus.stripeColourA(3),...
               stimulus.stripeColourA(3),...
               stimulus.stripeColourB(3),...
               stimulus.stripeColourB(3)];


    % Step 2: depending on value (1 or 2) set the foreground index of either a
    % stripes or b stripes to the correct colour
    if stimulus.stripeIndex == 1
        red(1) = stimulus.figureColour(1);
        green(1) = stimulus.figureColour(2);
        blue(1) = stimulus.figureColour(3);
    else
        red(3) = stimulus.figureColour(1);
        green(3) = stimulus.figureColour(2);
        blue(3) = stimulus.figureColour(3);
    end

    % Step 3: construct the images, by using the imageMatrix as indexes to
    % the individual colour arrays
    image = red(stimulus.imageMatrix);
    image(:,:,2) = green(stimulus.imageMatrix);
    image(:,:,3) = blue(stimulus.imageMatrix);


    % Step 4: copy the texture to the graphics display
    texture = Screen('MakeTexture', screen.ptr, image);

    % Step 5: Draw the texture (and release texture from memory)
    Screen('DrawTexture', screen.ptr, texture, [], stimulus.destinationRect);
    Screen('Close', texture);

end

