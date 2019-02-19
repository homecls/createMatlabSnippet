% function strip_comment_afterDotDotDot_test
strRaw = ["new%";"erer... .  %"];
TF = regexpcell(strRaw, '\.\.\..*%.*')
aa =regexprep(strRaw, '\.\.\..*%.*','...')
%     end % func