function [tradeCode800,rtnValidReportDate] = FindLatestReportDateByWindCodeAndDate(date_,w_)
    strDate_ = num2str(date_);
    [w_wset_data,~,~,~,w_wset_errorid,~]=w_.wset('IndexConstituent',['date=',strDate_,';windcode=000906.SH']);
    
    assert(w_wset_errorid == 0, '#Error:FindLatestFinanceIndexByWindCodeAndDate:wset error.');
    tradeCode800 = w_wset_data(:,2);

    rptDate = GetLatestRptDate(date_);
    [Stm_IssuingDates,~,~,~,errorid,~] = w_.wss(tradeCode800,'stm_issuingdate',['rptDate=',rptDate]);
    assert(errorid == 0, '#Error:FindLatestFinanceIndexByWindCodeAndDate:wss error.');
    rowNum = size(Stm_IssuingDates,1);
    nDate = datenum(strDate_,'yyyymmdd');
    validRptDates = {};
    
    rtnValidReportDate      = nan(size(Stm_IssuingDates));
    J                       = ismember(Stm_IssuingDates, '0:00:00');
    nonZeroIssuingFlag      = ~J;
    %originalInfo            = [tradeCode800, Stm_IssuingDates];
    %validInfo               = originalInfo(~I, :);
    
    stmIssuingDatesNum      = datenum(Stm_IssuingDates);
    
    %check the first possible report date
    validIssuingDatesFlag   = stmIssuingDatesNum <= datenum(num2str(date_), 'yyyymmdd');
    invalIssuingDatesFlag   = ~validIssuingDatesFlag & nonZeroIssuingFlag;
    rtnValidReportDate(nonZeroIssuingFlag & validIssuingDatesFlag) = str2num(rptDate);
    %check the second possible report date
    if strcmpi(rptDate(end - 3: end), '0331'),
        yRptDate                = GetLatestRptDate(rptDate);
        %invalidCodes            = tradeCode800(invalIssuingDatesFlag);
        [yRptStmIssuingDates,~,~,~,errorid,~] = w_.wss(tradeCode800,'stm_issuingdate',['rptDate=',yRptDate]);
        assert(errorid == 0, '#Error:FindLatestFinanceIndexByWindCodeAndDate:wss error.');
        zeroRptStmIssuingDates  = ismember(yRptStmIssuingDates, '0:00:00');
        yRptStmIssuingNum       = datenum(yRptStmIssuingDates);
        validYRptDatesFlag      = ~zeroRptStmIssuingDates & yRptStmIssuingNum <= datenum(num2str(date_), 'yyyymmdd') & invalIssuingDatesFlag;
        rtnValidReportDate(validYRptDatesFlag) = str2num(yRptDate);
        invalidYRptDatesFlag    = ~zeroRptStmIssuingDates & yRptStmIssuingNum > datenum(num2str(date_), 'yyyymmdd') & invalIssuingDatesFlag;
        rtnValidReportDate(invalidYRptDatesFlag) = str2num(GetLatestRptDate(yRptDate));
    else
        rtnValidReportDate(nonZeroIssuingFlag & invalIssuingDatesFlag) = str2num(GetLatestRptDate(rptDate));
        % need to do more check
    end
    
end


function rptDate = GetLatestRptDate(date_)
    strDate_ = num2str(date_);
    y_ = str2num(strDate_(1:4));
    m_ = str2num(strDate_(5:6));
    y = ''; m = ''; d = '';
    if m_ <= 3,
        y = num2str(y_-1); m = '12'; d = '31';
    elseif m_ <= 6,
        y = num2str(y_); m = '03'; d = '31';
    elseif m_ <= 9,
        y = num2str(y_); m = '06'; d = '30';
    elseif m_ <= 12,
        y = num2str(y_); m = '09'; d = '30';
    end
    rptDate = [y,m,d];       
end
