function rtnData = FindLatestReportDataByDate(date_,w_,windField_,nField_)
    
    [tradeCodes800,validRptDates]= FindLatestReportDateByWindCodeAndDate(date_,w_);
    rptDatesList  = unique(validRptDates);
    rtnData  = nan(length(tradeCodes800), 3 + nField_);
    rtnData(:, 1) = date_;
    rtnData(:, 2) = str2num(cell2mat(regexprep(tradeCodes800, '.S[ZH]','')));
    rtnData(:, 3) = validRptDates;
    for i = 1: length(rptDatesList)
        thisRptDate = rptDatesList(i);
        if isnan(thisRptDate),
            continue;
        else
            thisCodesFlag   = validRptDates == thisRptDate;
            [thisReportData,thisCodes,~,~,errorid,~] = w_.wss(tradeCodes800(thisCodesFlag),windField_,['rptDate=',num2str(thisRptDate)]);
            if(errorid ~= 0) ,
                disp(['#Error:FindLatestReportDataByDate:wss',thisReportData]);
            end
            assert(errorid == 0, '#Error:FindLatestReportDataByDate:wss error.');
            
            assert(isequal(thisCodes,tradeCodes800(thisCodesFlag)), '#Error:FindLatestReportDataByDate:codes error, not matched.');
            if isnumeric(thisReportData) ,
                rtnData(thisCodesFlag, 4:end) = thisReportData;
            end
        end
    end
end