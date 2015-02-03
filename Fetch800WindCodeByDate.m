function rtnCodes = Fetch800WindCodeByDate(date_,w_)
    tradeDate                   = num2str(date_);
    [strCodes,~,~,~,errorid,~]=w_.wset('IndexConstituent',['date=',tradeDate,';windcode=000906.SH']);
    assert(errorid == 0, '#Error:Fetch800WindCodeByDate:wind error.');
    strCodes = strCodes(:,2); 
    nCodes   = length(strCodes);
    rtnCodes = nan(size(strCodes));
    for i = 1: nCodes
        thisCode = strCodes{i};
        rtnCodes(i) = str2num(thisCode(1:6));
    end
    assert(all(~isnan(rtnCodes)), '#Error:Fetch800WindCodeByDate:nan code.');
end
