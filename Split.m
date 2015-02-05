    function rtnCell = Split(srcStr, delimiter)
    rtnCell = [];
    tmpStr = [];
    for i = 1:length(srcStr)
        if strcmpi(srcStr(i), delimiter),
            rtnCell = [rtnCell, {tmpStr}];
            tmpStr = [];
        elseif strcmpi(srcStr(i), ' ')
            continue;
        else
            tmpStr = [tmpStr, srcStr(i)];
        end
    end
    rtnCell     = [rtnCell, tmpStr];
end