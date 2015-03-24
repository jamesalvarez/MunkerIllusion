function results2csv(results,fn)
% Outputs results of a struct to a csv file

    FID = fopen(fn,'w');
    headers = fieldnames(results);
    nColumns = length(headers);

    header = headers{1};
    for col = 2:nColumns
        header = [header,', "',headers{col},'"'];
    end

    header = [header,'\n'];

    fprintf(FID,header);

    nRows = size(results.(headers{1}),2);

    for row = 1:nRows
        line = '';

        for col = 1:nColumns
            c = results.(headers{col})(row);
            if isnumeric(c)
                line = [line, num2str(c),','];
            elseif islogical(c)
                line = [line, num2str(double(c)),','];
            elseif ischar(c)
                line = [line, '"', c, '",'];
            end
        end
        line = line(1:end-1); %remove last comma
        line = [line,'\n'];
        fprintf(FID,line);
    end
    fprintf(FID,'\n');


    fclose(FID);
end
