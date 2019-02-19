function Acell = fread2cell(f1, nlines)
    % read a txt to a cell str
    fid = fopen(f1);
    
    tline = fgetl(fid);

    kk = 1;
    HASarg2 = false;
    if nargin == 2
        HASarg2 = true;
        Acell = cell(nlines, 1);
    end

    while ischar(tline)
        Acell{kk, 1} = tline;
        kk = kk + 1;

        if HASarg2 && kk > nlines
            break;
        end

        tline = fgetl(fid);
    end

%     nlinesReal = numel(Acell);

    if HASarg2 && kk-1 < nlines
        Acell(kk:end) = [];
    end

    fclose(fid);

    %
    % data = textread(f1,'%s','delimiter','\n','whitespace','');

end
