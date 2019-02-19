%%  OBJECTIVE:  demo create matlab snippet for your owern toolbox in a path

% Author: linrenwen@gmail.com, SUIBE
% Version: 2019/02/18
// OBJECTIVE:  demo objective

Author: linrenwen@gmail.com, SUIBE
Version: 2019/02/18




clear; clc; close all;

%% 1. Prepare the function file list
% the path including self-define function mfiles
P(1) = 'C:\Dropbox\YY_LL\PROJECTS\Tools_Matlab_Dropbox';
P1 = strcat(P(1), '\**\*.m');
Fm = rdir(P1);
FmTab = struct2table(Fm);

FmTab.name = string(FmTab.name);
FmTab.name = strrep(FmTab.name, '.M','.m');
FmTab.nameShort = filepartsname(FmTab.name);
FmTab.nameShort = strrep(FmTab.nameShort,'.m','');

%% 2. Get the function definition arguments from function files
nFile = height(FmTab);
defLine = cell(nFile,1);
inputs = cell(nFile,1);
outputs = cell(nFile,1);
ISEmpty = false(nFile,1);
for ifile=1:nFile
    if mod(ifile,20)==0
        fclose all; 
    end
    %     try
    [inputs{ifile},outputs{ifile},defLine{ifile}] = get_arg_namesLRW(char(FmTab.name(ifile)));
    if isempty(defLine{ifile})
        ISEmpty(ifile) = true;
        continue;
    end
    %     catch
    %        fprintf('%g\t%s\t%s\n',ifile,defLine{ifile},char(FmTab.name(ifile))) 
    %     end
end
%%

FmTab.ISEmpty = ISEmpty;
FmTab.body = strtrim(string(defLine));
FmTab.nameShort = (string(FmTab.nameShort));
FmTab.iprefix = FmTab.nameShort;
FmTab.body(ISEmpty) = FmTab.nameShort(ISEmpty);
FmTab.description = FmTab.body;
FmTab.body = strtrim(regexprep(FmTab.body,'^function',''));

FmTab.inputs = inputs;
FmTab.outputs = outputs;
FmTab.functionsname = FmTab.nameShort;


%% 3. Dataclean: remove duplications and rename conflicts snippet items
% identify the duplications functions' name
[~,~,~,~,~,IDDuplicate] = uniqueCount(FmTab.nameShort+(FmTab.body));
FmTab(IDDuplicate,:) = [];
[uniques,ia,ic,Tvarnamesunique,TvarnamesDuplicate,IDDuplicate] = uniqueCount(FmTab.nameShort);

% rename conflicts snippet items
% by appendding order number to duplicate filenames
% TODO: the following code can be speeded up by using groupby function
FmTabDuplicate=FmTab(IDDuplicate,:);
nDup = height(TvarnamesDuplicate);

for ifile = 1:nDup%1:nDup
    %fprintf('%g ',ifile);
    ifilename = TvarnamesDuplicate.uniques(ifile);
    iDupTimes = TvarnamesDuplicate.numUnique(ifile);
    iID = FmTabDuplicate.nameShort == ifilename;
    iDupTimes2 = sum(iID);
    if ~(iDupTimes==iDupTimes2)
        iIDraw = FmTab.nameShort == ifilename;
        FmTab(iIDraw,:)
        FmTabDuplicate(iID,:)
        cprintf('error','%g, %g==%g \n',ifile,iDupTimes,iDupTimes2);
    end
    iprefix = ifilename+"_V"+(1:iDupTimes2)';
    FmTabDuplicate.iprefix(iID) = iprefix;
end
FmTab(IDDuplicate,:) = FmTabDuplicate;
% the the string for snippet
nFmTab = height(FmTab);
for ifile=1:nFmTab
    iInputs = FmTab.inputs(ifile);
    iOutputs = FmTab.outputs(ifile);
    iFunname = FmTab.functionsname(ifile);
    FmTab.strSnippet(ifile) = getSnippet(iInputs,iOutputs,iFunname);
end

%% 4. outport json file form filenametable
% TODO: merge the result JOSN file with the user defined matlab.json in vscode
%  automatically

filenameTable = table();
filenameTable.name = cellstr(FmTab.iprefix);

filenameTable.prefix = cellstr(FmTab.iprefix);
filenameTable.body = cellstr(FmTab.strSnippet);
filenameTable.description = cellstr(FmTab.description);
filenameStruct = table2struct( filenameTable);
% outport json for matlab snippet file
fileJSON = 'matlabSnippetLRW.json';
fwriteJSON_Snippet(fileJSON, filenameTable)
% Note: savejson donot work here and is queit slow
% Note: json jsonencode dont work here
% savejson('',filenameStruct(1:50),'ForceRootName',1,'JSONP',{filenameStruct(1:50).name})
% savejson('astruct',filenameStruct(1:50),struct('ParseLogical',1),'FileName','matlabSnippetLRW.json');
% uu = jsonencode(filenameTable);
% fwriteUTF8('matlabSnippetLRW.json',uu);

%% 5. nested function
function strSnippet = getSnippet(inputs,outputs,funname)
    inputs = makeitcell( makeitnotcell(inputs));
    outputs = makeitcell( makeitnotcell(outputs));
    ninput = numel(inputs);
    noutput = numel(outputs);
    
    %%  SET THE CODE FOR SINPPET
    % [${1:n1}, ${2:n2}]= fun(${3:n3},$(4:n4))
    % OUTPUT
    outs = outputs;%["out1","out2"];
    if noutput >1
        %     ss = "["+strjoin("${"+(1:(noutput))'+":"+outs+"}",", ")+"] = ";
        ss = "${1:["+strjoin(outs,", ")+"] = }"; % for case of y = ...
    elseif noutput == 1
        ss = "${"+(1:(noutput))+":"+outs(1:noutput)+" = }";
        if isempty(outs{1})
            ss = ""; 
        end
    else 
        ss ="";
    end
    ssout = ss;
    
    
    % INPUT
    ins = inputs;
    if ninput >0
        ss = "(" + strjoin("${"+ (2:(ninput+1))'+":"+ins(1:ninput) +"}",", ") + ")";
        if ninput ==1 && isempty(ins{1})
            ss = "";
        end
    else
        ss = "";
    end
    ssin = ss;
    iprefix = ssout + funname + ssin + "$0";
    
    strSnippet= iprefix;
    
end
%% end of m-file
