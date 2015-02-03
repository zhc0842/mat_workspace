function rtnFinanceData = FindLatestFinanceIndexByWindCodeAndDate(date_,code_,w_,windField_)
    if nargin < 4,
        windField_ = 'eps_basic,bps,orps_ttm,surpluscapitalps,surplusreserveps';
    end
    windField = ['stm_issuingdate,',windField_];
    %ipo_date是否需要检查？
    %stm_predict_issingdate 预估财报发布日期
    tradeCode = GetTradeCode(code_);
    
    %%
    %获取指定交易日中证800指数包含的所有股票代码 data的第二列
    %[w_wset_data,w_wset_codes,w_wset_fields,w_wset_times,w_wset_errorid,w_wset_reqid]=w.wset('IndexConstituent','date=20150203;windcode=000906.SH');
    %tradeCode800 = w_wset_data(2);
    %%
%   disp(tradeCode); 

    rptDate = GetLatestRptDate(date_);
    disp(rptDate);
    [financeData,~,~,~,errorid,~] = w_.wss(tradeCode,windField,['rptDate=',rptDate]);
    assert(errorid == 0, '#Error:FindLatestFinanceIndexByWindCodeAndDate:wind error.');
    rowNum = size(financeData,1);
    nDate = datenum(num2str(date_),'yyyymmdd');
    for i = 1 : rowNum
        rowData = financeData(i,:);
        stm_issuingdate = rowData{1};
        nStm_issuingdate = 0;
        try
            nStm_issuingdate = datenum(stm_issuingdate,'yyyy/mm/dd');
        catch
            disp('#Error:FindLatestFinanceIndexByWindCodeAndDate:invalid stm_issuingdate,ipo_date maybe later than it.');
            continue;
        end
        if nStm_issuingdate <= nDate ,
            %insert the rowdata into db MultiFactors800
            conn = database('DB','user','pwd','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://127.0.0.1:1433;databaseName=DB');
            if isconnection(conn) == 1 ,%若返回1则认为连接成功
                exdata = {'San Diego', 88;'Smith Jhon',99};%插入一个数组，可以考虑插入之前一直可用的数据，提前设置一个flag
                colnames = {'City', 'Avg_Temp'};
                fastinsert(conn, 'Temperatures', colnames, exdata);
            end
            close(conn);
     
        else
            %this rowdata is invalid which should not be seen on that date_
            %so use the previous rptDate to get the latest Financedata
            preRptDate = GetLatestRptDate(rptDate);
            [preFinanceData,~,~,~,preErrorid,~] = w_.wss(tradeCode{i},windField,['rptDate=',preRptDate]);
            assert(preErrorid == 0, '#Error:FindLatestFinanceIndexByWindCodeAndDate:wind error.');
            preRowData = preFinanceData(1,:);
            pre_stm_issuingdate = preRowData{1};
            try
                preNStm_issuingdate = datenum(pre_stm_issuingdate,'yyyy/mm/dd');
            catch
                disp('#Error:FindLatestFinanceIndexByWindCodeAndDate:invalid stm_issuingdate,ipo_date maybe later than it.');
                continue;
            end
            if preNStm_issuingdate <= nDate ,
                %insert the rowdata into db MultiFactors800
                %
            else
                
            end
        end
        
        
    end
    
    
end

function flag = IsValidIssuingDate(stm_issuingdate,rptDate)
%校验实际财报发布日期是否 在截止日期前发布
% 一季报0331：4月30日前
% 半年报0630：8月31日前
% 三季报0930：10月31日前
% 年报  1231：次年4月30日前

end

function rptDate = GetLatestRptDate(date_)
        date_ = num2str(date_);
        y_ = str2num(date_(1:4));
        m_ = str2num(date_(5:6));
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
