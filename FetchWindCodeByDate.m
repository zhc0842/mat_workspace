function rtnCodes = FetchWindCodeByDate(date_,w_)
    tradeDate                   = num2str(date_);
    [strCodes,~,~,~,errorid,~]  = w_.wset('SectorConstituent',['date=',tradeDate,';sector=È«²¿A¹É']);
    assert(errorid == 0, '#Error:FetchWindCodeByDate:wind error.');
    strCodes = strCodes(:,2); 
    nCodes   = length(strCodes);
    rtnCodes = nan(size(strCodes));
    for i = 1: nCodes
        thisCode = strCodes{i};
        rtnCodes(i) = str2num(thisCode(1:6));
    end
    assert(all(~isnan(rtnCodes)), '#Error:FetchWindCodeByDate:nan code.');
end
