function data = FetchSnapshotDataFromWindByDate(date_,w_, windField_)
%获取指定交易日下 所有上市股票的 （日）净流入资金
% code date val
    if nargin < 3,
        windField_ = 'mf_amt';
    end
    
    tradeDate                       = num2str(date_);
    [strCodes, ~, ~, ~, errorid,~]  = w_.wset('SectorConstituent', ['date=', tradeDate, ';sector=全部A股']); assert(errorid == 0, '#Error:FetchSnapshotDataFromWindByDate:wind error.');
    strCodes                        = strCodes(:,2); 
    [val, ~, ~, ~, errorid2,~]      = w_.wss(strCodes, windField_, ['tradeDate=', tradeDate]);  assert(errorid2 == 0, '#Error:FetchSnapshotDataFromWindByDate:wind error.');
    intCodes                        = nan(size(strCodes));
    for i = 1: length(intCodes)
        thisCode    = strCodes{i};
        intCodes(i) = str2num(thisCode(1:6));
    end
    
    data = [intCodes, date_ * ones(size(intCodes)), val];
end