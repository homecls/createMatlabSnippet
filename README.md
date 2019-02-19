@import "C:\Dropbox\YY_LL\PROJECTS\Tools_Markdown\style2.less"

# createMatlabSnippet

>Author: linrenwen@gmail.com

## Objective
create a matlab-snippet JSON file for your ower matlab toolbox.

## Usage
1. Refer to `createSnippetMatlab_example.m`, clone it, then modify it with `the path of yourown toolbox`. and `the JSON file name for matlab snippet`, for example `matlab_snippet.json`. run `createSnippetMatlab_example.m`, and it generate the json file: `matlab_snippet.json`.
2. Copy the contend in `matlab_snippet.json`, delete the `{`and`}`at the begin and the end of file. paste it into the user's `matlab.json` file located in `C:\Users\lin\AppData\Roaming\Code\User\snippets\matlab.json`.
3. restart the VS Code.



