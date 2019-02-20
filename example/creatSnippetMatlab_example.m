% OBJECTIVE: demo of creating matlab snippet for self-defined toolbox
% function JSON file of matlab snippet = main(path of tool box, path of JSON file)
%
%% OUTPUT
% JSON file of matlab snippet = 
%
%% INPUT
% path of tool box = 
%  path of JSON file = 
% 
%% REQUIRMENT
% 
% 
%% EXMAPLE
% 
% 
%% SEE ALSO
%
% 
%% AUTHOR: linrenwen@gmail.com
%% VERSION: v1.0 2019/02/20

clc; clear; close all; % fclose all;
P.prj = addpathprj('createMatlabSnippet');

%% Part 1, Data
P.functions = 'folder_for_test_example';
F.matlabJson = 'matlabSnippet_created.json';

%% Part 2 calculation
createSnippetMatlab(P.functions, F.matlabJson);

%% Part 3, Output of result
strJson = fread2cell(F.matlabJson,100);
celldisp(strJson);

%% Part 4, Demo of result


