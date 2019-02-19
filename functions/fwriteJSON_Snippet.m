function fwriteJSON_Snippet(fileJSON, filenameTable)
% write Matlab snippet Json of 
rootname = """"+ filenameTable.name+""": {";
prefix = """prefix"": """ + filenameTable.prefix + """,";
body = """body"": """ + filenameTable.body + """,";
description = """description"": """ + filenameTable.description + """ ";

strs = strjoin(rootname+NL+prefix+NL+body+NL+description+NL+"},",NL);
strsJSON = "{" + NL + strs + NL + "}";
fwriteUTF8(fileJSON,strsJSON);
end