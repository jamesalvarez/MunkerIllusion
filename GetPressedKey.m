function [keyPressed, sameKey, secs] = GetPressedKey(keysWanted, lastKeyPressed) 
% keysWanted is a matrix list of keys you are 
% waiting for e.g, [124 125 kbName('space')]
% keyPressed = the key pressed
% sameKey = same key as lastKeyPressed (without pause)
% secs = timestamp of key check
    FlushEvents('keydown');
    success = 0;
    pressed = 0;
    sameKey = 0;
        
    while success == 0
        % get key, if already pressed, then it is same key
        [pressed, secs, kbData] = KbCheck;
        if pressed == 1 
            if kbData(lastKeyPressed) == 1 
                % same as previous key, return
                sameKey = 1;
                keyPressed = lastKeyPressed;
                FlushEvents('keydown');
                return
            end
        else
            %no key pressed so continue checking
            while pressed == 0
            [pressed, secs, kbData] = KbCheck;
            end;
        end
        
        % a key was pressed, return 
        for i = 1:length(keysWanted)
            if kbData(keysWanted(i)) == 1
                success = 1;
                keyPressed = keysWanted(i);
                FlushEvents('keydown');
            break;
            end;
        end;    
    FlushEvents('keydown');
    end;
end
