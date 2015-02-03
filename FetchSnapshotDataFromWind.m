function [code_, date_, w_wss_data] = FetchSnapshotDataFromWind(code_, date_, w_, windField_)
%1����wind��ȡָ����Ʊ��ָ�������յľ������ʽ�
%2��ת��Ϊ�ɲ���DB��data
%3��matlab����DB������data����
%4���ر������Դ
    if nargin < 4,
        windField_ = 'mf_amt';
    end
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
    tradeDate   = num2str(date_);
    %[w_wss_data,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(tradeCode,'mf_amt',strcat('tradeDate=',tradeDate));
    w_wss_data  = w_.wss(tradeCode,windField_,strcat('tradeDate=',tradeDate));
    
end