    function TFBegin = strip_comment_afterDotDotDot(strRaw)
        TFBegin = regexp(strRaw, '\.\.\..+%.+');

    end % function strRaw