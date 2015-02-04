function [] = FindLatestFinanceIndexByWindCodeAndDate(date_,w_,windField_)
    if nargin < 3,
        windField_ = 'eps_basic,bps,orps_ttm,surpluscapitalps,surplusreserveps';
    end
    windField = ['stm_issuingdate,',windField_];
    %ipo_date是否需要检查？
    %stm_predict_issingdate 预估财报发布日期
    %tradeCode = GetTradeCode(code_);
    
    %获取指定交易日中证800指数包含的所有股票代码 data的第二列
    %[w_wset_data,w_wset_codes,w_wset_fields,w_wset_times,w_wset_errorid,w_wset_reqid]=w_.wset('IndexConstituent','date=20150203;windcode=000906.SH');
    strDate_ = num2str(date_);
    %[w_wset_data,~,~,~,w_wset_errorid,~]=w_.wset('IndexConstituent',['date=',strDate_,';windcode=000906.SH']);
    [w_wset_data,~,~,~,w_wset_errorid,~]=w_.wset('IndexConstituent','date=20150204;windcode=000906.SH');
    assert(w_wset_errorid == 0, '#Error:FindLatestFinanceIndexByWindCodeAndDate:wset error.');
    tradeCode800 = w_wset_data(:,2);

    rptDate = GetLatestRptDate(date_);
    [Stm_IssuingDates,~,~,~,errorid,~] = w_.wss(tradeCode800,'stm_issuingdate',['rptDate=',rptDate]);
    assert(errorid == 0, '#Error:FindLatestFinanceIndexByWindCodeAndDate:wss error.');
    rowNum = size(Stm_IssuingDates,1);
    nDate = datenum(strDate_,'yyyymmdd');
    validRptDates = {};
    for i = 1 : rowNum
        rowData = Stm_IssuingDates(i,:);
        stm_issuingdate = rowData{1};
        nStm_issuingdate = 0;
        try
            nStm_issuingdate = datenum(stm_issuingdate,'yyyy/mm/dd');
        catch
            disp(['#Error:FindLatestFinanceIndexByWindCodeAndDate:',tradeCode800{i},'invalid stm_issuingdate,',stm_issuingdate]);
            validRptDates = [validRptDates;{strDate_,tradeCode800{i},NaN}];
            continue;
        end
        if nStm_issuingdate <= nDate ,
            validRptDates = [validRptDates;{strDate_,tradeCode800{i},rptDate}];
        else
            preRptDate = GetLatestRptDate(rptDate);
            [preFinanceData,~,~,~,preErrorid,~] = w_.wss(tradeCode800{i},'stm_issuingdate',['rptDate=',preRptDate]);
            assert(preErrorid == 0, '#Error:FindLatestFinanceIndexByWindCodeAndDate:wss error.');
            pre_stm_issuingdate = preFinanceData{1};
            try
                preNStm_issuingdate = datenum(pre_stm_issuingdate,'yyyy/mm/dd');
            catch
                disp(['#Error:FindLatestFinanceIndexByWindCodeAndDate:invalid format pre_stm_issuingdate,',pre_stm_issuingdate]);
                validRptDates = [validRptDates;{strDate_,tradeCode800{i},NaN}];
                continue;
            end
            if preNStm_issuingdate <= nDate ,
                validRptDates = [validRptDates;{strDate_,tradeCode800{i},preRptDate}];
            else
                disp(['#Error:FindLatestFinanceIndexByWindCodeAndDate:invalid preNStm_issuingdate,',pre_stm_issuingdate]);
                validRptDates = [validRptDates;{strDate_,tradeCode800{i},GetLatestRptDate(preRptDate)}];
                
            end
        end
    end
    save('validRptDates.mat','validRptDates');
end

function flag = IsValidIssuingDate(stm_issuingdate,rptDate)
%校验实际财报发布日期是否 在截止日期前发布
% 一季报0331：4月30日前
% 半年报0630：8月31日前
% 三季报0930：10月31日前
% 年报  1231：次年4月30日前
    flag = 0;
    y = year(stm_issuingdate);
    m = month(rptDate);
    if m == 3 ,
        if stm_issuingdate <= (rptDate + 30),
            flag = 1;
        end
    elseif m == 6 ,
        if stm_issuingdate <= (rptDate + 62) ,
            flag = 1;
        end
    elseif m == 9 ,
        if stm_issuingdate <= (rptDate + 31) ,
            flag = 1;
        end
    elseif m == 12 ,
        if stm_issuingdate <= (rptDate + 120 + IsLeapYear(y)) ,
            flag = 1;
        end
    end
end

function isLeap = IsLeapYear(y)
    isLeap = 0;
    if mod(y,400) == 0 ,
        isLeap = 1;
    elseif mod(y,4) == 0
        if mod(y,100) ~= 0 ,
            isLeap = 1;
        end
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

function tradeCode = GetTradeCode(code_)
    if code_ >= 600000,
        tradeCode = [num2str(code_), '.SH'];
    else
        nLen = length(num2str(code_));
        if nLen < 6,
            sCode = '000000';
            sCode(end-nLen+1:end) = num2str(code_);
            tradeCode = [sCode, '.SZ'];
        else
            tradeCode = [num2str(code_), '.SZ'];
        end
    end
end
