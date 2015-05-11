function MunkerExperiment()
%MUNKEREXPERIMENT Main function, to run the experiment
%   
    subID = input('Please enter subject ID:','s');
    results_filename = ['Munker-',subID,'.csv'];
    
    if ~isempty(dir(results_filename))
        disp(['The file ',results_filename,' exists!']);
        return;
    end

    %% Setting up
    % Setup hardware, loading pictures, setup psychtoolbox etc...
    [environment, stimuliInfo] = InitialiseExperiment();

    %% Setting up trial

    % The eight starting colours
    starting_colours_rgb = Constants.startingColoursRGB;

    %normalise them for the rgb2hsv function, and convert
    normalised_starting_colours = rgb2hsv(starting_colours_rgb / 255);

    %get the number of colours to compute the number of trials etc
    num_colours = size(normalised_starting_colours,1);

    %number of trials is twice number of colours
    num_trials = num_colours * 2;

    %compose trial structs
    for i = 1:num_trials

        %mod getsr remainder, it is useful
        %for cycling through a fixed number of things e.g. mod(1,8) = 1, and
        %mod(9,8) = 1 too...  Beware of indexes which are 0 though, always have
        %to add one.
        colour_index = 1 + mod(i - 1, num_colours); 

        %fill an struct array with the colour and stripe type
        trials(i).colour = normalised_starting_colours(colour_index, :);

        %first half are 0, second half is 1
        trials(i).stripeType = i > num_colours;
    end

    %shuffle them for the random order
    shuffled_trials = trials(randperm(length(trials)));

    %now run the experiment
    for trial_number = 1:num_trials

        current_trial = shuffled_trials(trial_number);
        current_colour = current_trial.colour;

        % Colour is the same at start
        trialInfo.adjustFigureColourHSV = current_colour;
        trialInfo.fixedFigureColourHSV = current_colour;

        % Decide on the stripe index
        if current_trial.stripeType == 1 
            trialInfo.adjustStripeIndex = 3;
            trialInfo.fixedStripeIndex = 2;
        else
            trialInfo.adjustStripeIndex = 3;
            trialInfo.fixedStripeIndex = 1;
        end

        % Always adjusting left
        trialInfo.adjustSide = 1; %(1 or 2)

        % Show trial and store result
        hsv_result = DoMunkerTrial(trialInfo,stimuliInfo,environment);
        
        % Populate results
        colourChosen = hsv2rgb(hsv_result) * 255;
        colourShown = hsv2rgb(current_colour) * 255;
        
        results.trialNumber(trial_number) = trial_number;
        results.stripeType(trial_number) = current_trial.stripeType;
        results.chosenR(trial_number) = colourChosen(1);
        results.chosenG(trial_number) = colourChosen(2);
        results.chosenB(trial_number) = colourChosen(3);
        results.shownR(trial_number) = colourShown(1);
        results.shownG(trial_number) = colourShown(2);
        results.shownB(trial_number) = colourShown(3);
        
        % Wait one second
        WaitSecs(Constants.ISI);
    end

    % Save results                 
    results2csv(results, results_filename);
    
    ShutdownExperiment();
end






