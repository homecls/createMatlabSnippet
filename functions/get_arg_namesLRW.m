function [inputNames, outputNames, defLine] = get_arg_namesLRW(filePath)

    % Open the file:
    strcell = fread2cell(filePath, 300);
    strs = strtrim(string(strcell));
    strs = strip_comment_block(strs);
    strs = strip_comment_afterDotDotDot(strs);
    strs = strip_comment_atlineBegin(strs);
    strs = strip_blanklines(strs);
    nLines = numel(strs);
    TFS = startsWith(strs, 'function');
    IDS = find(TFS);
    TFSmultiline = endsWith(strs, '...');
    % IDSmultiline = find(TFSmultiline);
    nFunDefine = sum(TFS);

    if nFunDefine > 0
        IDfun1 = IDS(1);
        if ~(IDS(1)==1)
            cprintf('error','no function definition at line 1,%s\n',filePath)
        end
        strFunDefine = strs(IDfun1);

        for iLine = IDfun1:nLines-1

            if TFSmultiline(iLine)
                chartmp = char(strFunDefine);
                strtmp = string(chartmp(1:end-3));
                strFunDefine = strtmp+strs(iLine + 1);
            else
                
                break;
            end

        end

    else
        strFunDefine = "";
    end

    defLine = char(strFunDefine);
%% parse the function items
%% Create the regular expression to match:
    matchStr = '\s*function\s+';

    if any(defLine == '=')
        matchStr = strcat(matchStr, '\[?(?<outArgs>[\w, ]*)\]?\s*=\s*');
    end

    matchStr = strcat(matchStr, '\w+\s*\(?(?<inArgs>[\w, ]*)\)?');

%% Parse the definition line (case insensitive):
    argStruct = regexpi(defLine, matchStr, 'names');

    if isempty(argStruct)% modified by linrenwen@gmail.com
        defLine = '';
        inputNames = '';
        outputNames = '';
        return;
    end

    % Format the input argument names:

    if isfield(argStruct, 'inArgs') &&~isempty(argStruct.inArgs)
        inputNames = strtrim(textscan(argStruct.inArgs, '%s', ...
            'Delimiter', ','));
    else
        inputNames = {};
    end

    % Format the output argument names:
    if isfield(argStruct, 'outArgs') &&~isempty(argStruct.outArgs)
        outputNames = strtrim(textscan(argStruct.outArgs, '%s', ...
            'Delimiter', ','));
    else
        outputNames = {};
    end

%% Nested functions:

    function str = strip_comments(str)

        if strcmp(strtrim(str), '%{')
            strip_comment_block;
            str = strip_comments(fgets(fid));
        else
            str = strtok([' ' str], '%');
        end

    end

    function strRaw = strip_comment_block(strRaw)
        TFBegin = startsWith(strRaw, '%{');
        TFEnd = endsWith(strRaw, '%}');
        IDBegin = flipud(find(TFBegin));
        IDEnd = flipud(find(TFEnd));

        Id = [];

        if numel(IDBegin) == numel(IDEnd)

            for iID = 1:numel(IDBegin)
                idx = IDBegin(iID):IDEnd(iID);
                Id = [Id, idx];
            end

            strRaw(Id) = [];
        end

    end % function strRaw

    function strRaw = strip_comment_afterDotDotDot(strRaw)
        strRaw = regexprep(strRaw, '\.\.\..*%.*', '...');
    end % function strRaw

    function strRaw = strip_comment_atlineBegin(strRaw)
        TFBegin = startsWith(strRaw, '%');
        strRaw(TFBegin) = [];
    end % function strRaw

    function strRaw = strip_blanklines(strRaw)
        TFBegin = strlength(strRaw)==0;
        strRaw(TFBegin) = [];
    end % function strRaw

end
