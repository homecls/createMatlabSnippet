@import "C:\Dropbox\YY_LL\PROJECTS\Tools_Markdown\style2.less"

# createMatlabSnippet

>Author: linrenwen@gmail.com

## Objective
For VScode user, create a matlab-snippet JSON file for your ower matlab toolbox.

## Usage

All required functions and example are included in `creatSnippetMatlab_example.zip`. 

1. Find `createSnippetMatlab_example.m`, clone it, then replace `the path of yourown toolbox`. and `the JSON file name for matlab snippet` with your own ones like: `matlab_snippet.json`. run `createSnippetMatlab_example.m`, and it generate the json file: `matlab_snippet.json`.
   ``` matlab
   createSnippetMatlab(Path.functions, Path.matlabJson);
   ```
2. Copy the contend in `matlab_snippet.json`, delete the `{`and`}`at the begin and the end of file. Then paste it into the user's `matlab.json` file located in `C:\Users\lin\AppData\Roaming\Code\User\snippets\matlab.json`.
3. restart the VS Code. enjoy self-defined matlab snippet.