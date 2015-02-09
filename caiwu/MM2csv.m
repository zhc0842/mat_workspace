function [] = MM2csv(fileName)
    if(nargin < 1)
        gap = 0;
        wkd = weekday(date);
        if wkd < 3 ,
            gap = wkd;
        end
        % 默认打开当前目录 前一交易日的txt 如 20150205.txt 处理周一和周日的情况
        fileName = [datestr(addtodate(datenum(date),-1-gap,'day'),'yyyymmdd'),'.txt'];
    else
        if ~regexpi(fileName,'txt','end') ,
            throw('FileFormatException:only .txt is allowed');
        end
    end
    [fidin,msg] = fopen(fileName,'r');
    assert(fidin~=-1,msg);
    srcData0 = textscan(fidin,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','BufSize',102400,'HeaderLines',2,'Delimiter',' ','MultipleDelimsAsOne',1);
    fclose(fidin);

    srcData1 = {};
    for i = 1:size(srcData0,2) ,
        srcData1 = [srcData1,srcData0{i}];
    end
    headline = srcData1(1,:);
    srcData = srcData1(2:end,:);
    smpl_fileName = char(srcData(1,1));
    
    delegateCode_rflag = str2num(char(srcData(:,15))) > 0;
    dealTime = datenum(char(srcData(:,16)),'HH:MM:SS');
    dealTime_rflag = (dealTime > datenum('09:15:00','HH:MM:SS')) & (dealTime < datenum('15:15:00','HH:MM:SS'));
    
    zqmr_rflag = ismember(srcData(:,4),'证券买入') & delegateCode_rflag & dealTime_rflag;
    zqmc_rflag = ismember(srcData(:,4),'证券卖出') & delegateCode_rflag & dealTime_rflag;
    
    zqmr = srcData(zqmr_rflag,:);
    zqmc = srcData(zqmc_rflag,:);
   
    gpmr = regexprep(zqmr,'证券','股票');
    gpmc = regexprep(zqmc,'证券','股票');
    
    nGpmrR = size(gpmr,1);
    nGpmcR = size(gpmc,1);
    jy = cell(nGpmrR+nGpmcR,46);
    
    jy(:,2) = cellstr('9001');
    jy(1:nGpmrR,4) = gpmr(:,1);
    jy(nGpmrR+1:end,4) = gpmc(:,1);
    
    jy(1:nGpmrR,5) = cellstr('40000');
    jy(nGpmrR+1:end,5) = cellstr('40001');
    jy(1:nGpmrR,6) = gpmr(:,4);
    jy(nGpmrR+1:end,6) = gpmc(:,4);
    jy(1:nGpmrR,7:8) = gpmr(:,2:3);
    jy(nGpmrR+1:end,7:8) = gpmc(:,2:3);
    jy(1:nGpmrR,11) = gpmr(:,18);
    jy(nGpmrR+1:end,11) = gpmc(:,18);
    jy(1:nGpmrR,16) = gpmr(:,6);
    jy(nGpmrR+1:end,16) = regexprep(gpmc(:,6),'^-','');
    jy(1:nGpmrR,17) = gpmr(:,7);
    jy(nGpmrR+1:end,17) = gpmc(:,7);
    jy(1:nGpmrR,18) = gpmr(:,8);
    jy(nGpmrR+1:end,18) = gpmc(:,8);
    jy(:,19) = cellstr('0');
    jy(1:nGpmrR,20) = gpmr(:,9);
    jy(nGpmrR+1:end,20) = gpmc(:,9);
    jy(1:nGpmrR,21) = gpmr(:,10);
    jy(nGpmrR+1:end,21) = gpmc(:,10);
    jy(:,22) = cellstr('0');
    jy(:,23) = cellstr('0');
    jy(1:nGpmrR,24) = gpmr(:,13);
    jy(nGpmrR+1:end,24) = gpmc(:,13);
    jy(1:nGpmrR,37) = gpmr(:,18);
    jy(nGpmrR+1:end,37) = gpmc(:,18);
    
    bill_code = cell(nGpmrR+nGpmcR,1);
    gpmr_sh_flag = str2num(char(gpmr(:,2)))>=600000;
    gpmc_sh_flag = str2num(char(gpmc(:,2)))>=600000;
    gp_sh_flag = [gpmr_sh_flag;gpmc_sh_flag];
    bill_code(:) = cellstr('SZ');
    bill_code(gp_sh_flag) = cellstr('SH');
    delegate_code = [gpmr(:,15);gpmc(:,15)];
    tmp = strcat(jy(:,4),jy(:,2));
    bill_code = strcat(bill_code,tmp,delegate_code);
    jy(:,3) = bill_code;
    
    boursecode = cell(nGpmrR+nGpmcR,1); 
    boursecode(:) = cellstr('102');
    boursecode(gp_sh_flag) = cellstr('101');
    jy(:,46) = boursecode;
     
    jy_headline = {
        'pk_selfstrade','pk_corp','bill_code','trade_date',...
        'pk_operationcode','pk_operationname','pk_securitiescode',...
        'pk_securitiesname','pk_selfsgroup','pk_partner','pk_account',...
        'pk_cumando','pk_operatesite','pk_seat','pk_econtract',...
        'bargain_num','bargain_sum','commision','handle_fee','stamp_tax',...
        'transfer_fee','liquidate_fee','other_fee','fact_sum','operator',...
        'operate_date','if_voucher','if_audit','assessor','audit_date',...
        'state','ndef1','ndef2','ndef3','ndef4','ndef5','vdef1','vdef2',...
        'vdef3','vdef4','vdef5','ts','dr','begin_date','end_date','boursecode'
    };
    jy_finalData = [jy_headline;jy];
%   xlswrite(['jy',smpl_fileName,'.xls'],jy_finalData,1,'A1');
    fwCell2CSVfmt(jy_finalData,['jy',smpl_fileName,'.csv']);
    
% -------------------------------------------------------------------------
    zyhgcc_rflag = ismember(srcData(:,4),'质押回购拆出');
    cczygh_rflag = ismember(srcData(:,4),'拆出质押购回');

    zyhgcc = srcData(zyhgcc_rflag,:);
    cczygh = srcData(cczygh_rflag,:);
    rqhg = regexprep(zyhgcc,'质押回购拆出','融券回购');
    rqgh = regexprep(cczygh,'拆出质押购回','融券购回');
    
    nRqhgR = size(rqhg,1);
    nRqghR = size(rqgh,1);
    hg = cell(nRqhgR+nRqghR,41);
    
    hg(:,2) = cellstr('9001');
    hg(1:nRqhgR,3) = rqhg(:,1);
    hg(nRqhgR+1:end,3) = rqgh(:,1);
    
    hg(1:nRqhgR,4) = cellstr('40006');
    hg(nRqhgR+1:end,4) = cellstr('40009');
    hg(1:nRqhgR,5) = rqhg(:,4);
    hg(nRqhgR+1:end,5) = rqgh(:,4);
    hg(1:nRqhgR,6) = rqhg(:,18);
    hg(nRqhgR+1:end,6) = rqgh(:,18);
    hg(:,7) = cellstr('D890767292');
    hg(:,10) = cellstr('D890767292');
    hg(1:nRqhgR,13) = rqhg(:,2);
    hg(nRqhgR+1:end,13) = rqgh(:,2);
    hg(1:nRqhgR,14) = rqhg(:,6);
    hg(nRqhgR+1:end,14) = regexprep(rqgh(:,6),'^-','');
    hg(1:nRqhgR,15) = rqhg(:,7);
    hg(nRqhgR+1:end,15) = rqgh(:,7);
    hg(1:nRqhgR,16) = rqhg(:,8);
    hg(nRqhgR+1:end,16) = rqgh(:,8);
    hg(:,17:19) = cellstr('0');
    hg(1:nRqhgR,20) = rqhg(:,13);
    hg(nRqhgR+1:end,20) = rqgh(:,13);
    hg(1:nRqhgR,21) = rqhg(:,1);
    hg(nRqhgR+1:end,21) = rqgh(:,1);
    backBuyRate = regexprep([rqhg(:,20);rqgh(:,20)],'^融\S+:','');
    backBuyRate = regexprep(backBuyRate,'-\d+$','');
    hg(:,23) = backBuyRate;
    nBargain_su = str2num(char(hg(:,15)));
    nBackbuy_rate = str2num(char(hg(:,23)));

    hg(:,24) = cellstr(num2str(nBargain_su+nBackbuy_rate));
    hg(1:nRqhgR,25) = rqhg(:,1);
    hg(nRqhgR+1:end,25) = rqgh(:,1);
    
    hg(1:nRqhgR,36) = rqhg(:,18);
    hg(nRqhgR+1:end,36) = rqgh(:,18);
    
    hg_bill_code = cell(nRqhgR+nRqghR,1);
    
    hg_bill_code(:) = cellstr('SH');
    hg_delegate_code = [rqhg(:,15);rqgh(:,15)];
    hg_bill_code = strcat(hg_bill_code,hg(:,3),hg_delegate_code);
    hg(:,1) = hg_bill_code;
    
%     hg_boursecode = cell(nRqhgR+nRqghR,1);
%     hg_boursecode(:) = cellstr('102');
%     hg_boursecode(gp_sh_flag) = cellstr('101');
    hg(:,41) = cellstr('101');
    
    hg_headline = {
        'bill_code','pk_corp','trade_date','pk_operationcode',...
        'pk_operationname','pk_account','pk_partner','pk_selfsgroup',...
        'pk_operatesite','pk_cumando','pk_seat','pk_econtra','pk_securities',...
        'bargain_nu','bargain_su','commision','handle_fee','stamp_tax',...
        'other_fee','fact_sum','end_date','pk_repurchase','backbuy_rate',...
        'backbuy_sum','outtrade_date','pk_operator','operate_date',...
        'pk_assessor','audit_date','state','ndef1','ndef2','ndef3','ndef4',...
        'ndef5','vdef1','vdef2','vdef3','vdef4','vdef5','boursecode'
        };
    hg_finalData = [hg_headline;hg];
% 	xlswrite(['hg',smpl_fileName,'.xls'],hg_finalData,1,'A1');
    fwCell2CSVfmt(hg_finalData,['hg',smpl_fileName,'.csv']);
    
% -------------------------------------------------------------------------

    other_flag = ~(zqmr_rflag | zqmc_rflag | zyhgcc_rflag | cczygh_rflag);
    if any(other_flag) ,
        other_data = srcData(other_flag,:);
        other_finalData = [headline;other_data];
%       xlswrite(['other',smpl_fileName,'.xls'],other_finalData,1,'A1');
        fwCell2CSVfmt(other_finalData,['other',smpl_fileName,'.csv']);
    end
end

function [] = fwCell2CSVfmt(data,fileName)
% write cell data to txt in csv format, like aa,123,中国
% a row is a line
    
    [r,c] = size(data);
    [fidout,msg] = fopen(fileName,'w','n','GBK');
    assert(fidout~=-1,msg);
    for i = 1:r ,
        strLine = data{i,1};
        for j = 2:c ,
            strLine = [strLine,',',data{i,j}];
        end
        fprintf(fidout,'%s\r\n',strLine);
    end
    fclose(fidout);
end
