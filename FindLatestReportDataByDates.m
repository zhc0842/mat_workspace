function [] = FindLatestReportDataByDates(w_,windField_)
    if nargin < 2 ,
        windField_ = 'west_netprofit_FY1,west_netprofit_FY2,west_netprofit_FY3,west_netprofit_FTM,west_netprofit_YOY,west_netprofit_CAGR,west_nproc_1w,west_nproc_4w,west_nproc_13w,west_nproc_26w,west_eps_FY1,west_eps_FY2,west_eps_FY3,west_eps_FTM,west_avgroe_FY1,west_avgroe_FY2,west_avgroe_YOY,west_avgroe_FY3,west_sales_FY1,west_sales_FY2,west_sales_FY3,west_sales_FTM,west_sales_YOY,west_sales_CAGR,west_avgcps_FY1,west_avgcps_FY3,west_avgcps_FY2,west_avgcps_FTM,west_avgdps_FY1,west_avgdps_FY2,west_avgdps_FY3,west_avgbps_FY1,west_avgbps_FY2,west_avgbps_FY3,west_avgebit_FY1,west_avgebit_FY2,west_avgebit_FY3,west_avgebit_FTM,west_avgebit_YOY,west_avgebit_CAGR,west_avgebitda_FY1,west_avgebitda_FY2,west_avgebitda_FY3,west_avgebitda_FTM,west_avgebitda_YOY,west_avgebitda_CAGR,west_avgebt_FY1,west_avgebt_FY2,west_avgebt_FY3,west_avgebt_FTM,west_avgebt_YOY,west_avgebt_CAGR,west_avgoperatingprofit_FY1,west_avgoperatingprofit_FY2,west_avgoperatingprofit_FY3,west_avgoperatingprofit_FTM,west_avgoperatingprofit_YOY,west_avgoperatingprofit_CAGR,west_avgoc_FY1,west_avgoc_FY2,west_avgoc_FY3,west_avgoc_FTM,west_avgoc_YOY,west_avgoc_CAGR'
    end
    load('buzDays.mat');
    rtnData = [];
    for i = 1:length(buzDays)
        thisDay = buzDays(i);
        disp(i);
        rtnData = [rtnData;FindLatestReportDataByDate(thisDay,w_,windField_,64)];
        save(['./a/',thisDay,'.mat'],'rtnData');
    end
end