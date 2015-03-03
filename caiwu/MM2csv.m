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
   
    zqmr(:,4) = regexprep(zqmr(:,4),'证券','股票');
    zqmc(:,4) = regexprep(zqmc(:,4),'证券','股票');
    gpmr = zqmr;
    gpmc = zqmc;
    
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
    jy(1:nGpmrR,16) = regexprep(gpmr(:,6),'\.00$','');
    jy(nGpmrR+1:end,16) = regexprep(gpmc(:,6),'(?:^-)(\d+)(?:\.00$)','$1');
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
    gpmr_sh_flag = str2num(char(gpmr(:,2))) >= 500000;
    gpmc_sh_flag = str2num(char(gpmc(:,2))) >= 500000;
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
    bjhgcc_rflag = ismember(srcData(:,4),'报价回购拆出');
    ccbjgh_rflag = ismember(srcData(:,4),'拆出报价购回');
    
    zyhgcc = srcData(zyhgcc_rflag,:);
    cczygh = srcData(cczygh_rflag,:);
    bjhgcc = srcData(bjhgcc_rflag,:);
    ccbjgh = srcData(ccbjgh_rflag,:);
    
    zyhg = regexprep(zyhgcc,'质押回购拆出','融券回购');
    zygh = regexprep(cczygh,'拆出质押购回','融券购回');
    bjhg = regexprep(bjhgcc,'报价回购拆出','融券回购');
    bjgh = regexprep(ccbjgh,'拆出报价购回','融券购回');
    
    nRqhgR = size(zyhg,1);
    nRqghR = size(zygh,1);
    nBjhgR = size(bjhg,1);
    nBjghR = size(bjgh,1);
    
    hg = cell(nRqhgR+nRqghR+nBjhgR+nBjghR,41);
    nRqhg_RqghR = nRqhgR+nRqghR;
    nRqhg_Rqgh_BjhgR = nRqhgR+nRqghR+nBjhgR;
    
    hg(:,2) = cellstr('9001');
    hg(1:nRqhgR,3) = zyhg(:,1);
    hg(nRqhgR+1:nRqhg_RqghR,3) = zygh(:,1);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,3) = bjhg(:,1);
    hg(nRqhg_Rqgh_BjhgR+1:end,3) = bjgh(:,1);
    
    hg(1:nRqhgR,4) = cellstr('40006');
    hg(nRqhgR+1:nRqhg_RqghR,4) = cellstr('40009');
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,4) = cellstr('40006');
    hg(nRqhg_Rqgh_BjhgR+1:end,4) = cellstr('40009');
    
    hg(1:nRqhgR,5) = zyhg(:,4);
    hg(nRqhgR+1:nRqhg_RqghR,5) = zygh(:,4);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,5) = bjhg(:,4);
    hg(nRqhg_Rqgh_BjhgR+1:end,5) = bjgh(:,4);
    
    hg(1:nRqhgR,6) = zyhg(:,18);
    hg(nRqhgR+1:nRqhg_RqghR,6) = zygh(:,18);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,6) = bjhg(:,18);
    hg(nRqhg_Rqgh_BjhgR+1:end,6) = bjgh(:,18);
    
    hg(:,7) = cellstr('D890767292');
    hg(:,10) = cellstr('D890767292');
    
    hg(1:nRqhgR,13) = zyhg(:,2);
    hg(nRqhgR+1:nRqhg_RqghR,13) = zygh(:,2);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,13) = bjhg(:,2);
    hg(nRqhg_Rqgh_BjhgR+1:end,13) = bjgh(:,2);
    
    hg(1:nRqhgR,14) = regexprep(zyhg(:,6),'\.00$','');
    hg(nRqhgR+1:nRqhg_RqghR,14) = regexprep(zygh(:,6),'(?:^-)(\d+)(?:\.00$)','$1');
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,14) = regexprep(bjhg(:,6),'\.00$','');
    hg(nRqhg_Rqgh_BjhgR+1:end,14) = regexprep(bjgh(:,6),'(?:^-)(\d+)(?:\.00$)','$1');
    
    hg(1:nRqhgR,15) = zyhg(:,7);
    hg(nRqhgR+1:nRqhg_RqghR,15) = zygh(:,7);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,15) = bjhg(:,7);
    hg(nRqhg_Rqgh_BjhgR+1:end,15) = deleteBlankInDoubles(str2num(char(hg(nRqhg_Rqgh_BjhgR+1:end,14)))*100);
    
    hg(1:nRqhgR,16) = zyhg(:,8);
    hg(nRqhgR+1:nRqhg_RqghR,16) = zygh(:,8);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,16) = bjhg(:,8);
    hg(nRqhg_Rqgh_BjhgR+1:end,16) = bjgh(:,8);
    
    hg(:,17:19) = cellstr('0');
    
    hg(1:nRqhgR,20) = zyhg(:,13);
    hg(nRqhgR+1:nRqhg_RqghR,20) = zygh(:,13);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,20) = bjhg(:,13);
    hg(nRqhg_Rqgh_BjhgR+1:end,20) = bjgh(:,13);
    
    hg(1:nRqhgR,21) = zyhg(:,1);
    hg(nRqhgR+1:nRqhg_RqghR,21) = zygh(:,1);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,21) = bjhg(:,1);
    hg(nRqhg_Rqgh_BjhgR+1:end,21) = bjgh(:,1);
    
    rqhg_rqgh_backBuyInterest = regexprep([zyhg(:,20);zygh(:,20)],'^融\S+:','');
    rqhg_rqgh_backBuyInterest = regexprep(rqhg_rqgh_backBuyInterest,'-\d+$','');
    bjhg_backBuyInterest = regexprep(bjhg(:,20),'^\S+正常购回利息：','');
    bjhg_backBuyInterest = regexprep(bjhg_backBuyInterest,'，\S+$','');
    hg(1:nRqhg_RqghR,23) = rqhg_rqgh_backBuyInterest;
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,23) = bjhg_backBuyInterest;
    hg(nRqhg_Rqgh_BjhgR+1:end,23) = deleteBlankInDoubles(str2num(char(hg(nRqhg_Rqgh_BjhgR+1:end,20)))-str2num(char(hg(nRqhg_Rqgh_BjhgR+1:end,15))));
            
    hg(:,24) = deleteBlankInDoubles(str2num(char(hg(:,15)))+str2num(char(hg(:,23))));
    
    hg(1:nRqhgR,25) = zyhg(:,1);
    hg(nRqhgR+1:nRqhg_RqghR,25) = zygh(:,1);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,25) = bjhg(:,1);
    hg(nRqhg_Rqgh_BjhgR+1:end,25) = bjgh(:,1);
    
    hg(1:nRqhgR,36) = zyhg(:,18);
    hg(nRqhgR+1:nRqhg_RqghR,36) = zygh(:,18);
    hg(nRqhg_RqghR+1:nRqhg_Rqgh_BjhgR,36) = bjhg(:,18);
    hg(nRqhg_Rqgh_BjhgR+1:end,36) = bjgh(:,18);
    
    hg_bill_code = cell(nRqhgR+nRqghR+nBjhgR+nBjghR,1);
    
    hg_sh_flag = ismember(hg(:,13),'204001');
    
    hg_bill_code(:) = cellstr('SZ');
    hg_bill_code(hg_sh_flag) = cellstr('SH');
    hg_delegate_code = [zyhg(:,15);zygh(:,15);bjhg(:,15);bjgh(:,15)];
    hg_bill_code = strcat(hg_bill_code,hg(:,3),hg_delegate_code);
    hg(:,1) = hg_bill_code;
    
    hg(:,41) = cellstr('102');
    hg(hg_sh_flag,41) = cellstr('101');
    
    
    
    
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
    hg_fwCell2CSVfmt(hg_finalData,['hg',smpl_fileName,'.csv']);
    
% -------------------------------------------------------------------------

    other_flag = ~(zqmr_rflag | zqmc_rflag | zyhgcc_rflag | cczygh_rflag | bjhgcc_rflag | ccbjgh_rflag);
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


function [] = hg_fwCell2CSVfmt(data,fileName)
% write cell data to txt in csv format, like aa,123,中国
% a row is a line
    
    [r,c] = size(data);
    [fidout,msg] = fopen(fileName,'w','n','GBK');
    assert(fidout~=-1,msg);
    
    strLine = data{1,1};
    for j = 2:c ,
        strLine = [strLine,',',data{1,j}];
    end
    fprintf(fidout,'%s\r\n',strLine);
    
    for i = 2:r ,
        strLine = data{i,1};
        for j = 2:c ,
            %if j == 24 ,
            %    sum = sprintf('%0.2f',str2num(char(data{i,j})));
            %    strLine = [strLine,',',sum];
            %else
                strLine = [strLine,',',data{i,j}];
            %end
        end
        fprintf(fidout,'%s\r\n',strLine);
    end
    fclose(fidout);
end

function cellOut = deleteBlankInDoubles(doubleIn)
    [r,c] = size(doubleIn);
    cellOut = cellstr(sprintf('%0.2f',doubleIn(1,1)));
    for j = 2:c ,
        cellOut = [cellOut,cellstr(sprintf('%0.2f',doubleIn(1,j)))];
    end
    if r<2 ,
        return ;
    end
    for i=2:r ,
        cellLine = cellstr(sprintf('%0.2f',doubleIn(i,1)));
        for j=2:c ,
            cellLine = [cellLine,cellstr(sprintf('%0.2f',doubleIn(i,j)))];
        end
        cellOut = [cellOut;cellLine];
    end
end