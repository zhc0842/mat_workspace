function [] = MM(fileName)
    if(nargin < 1)
        % 默认打开当前目录 前一天的txt 如 20150205.txt
        fileName = [datestr(addtodate(datenum(date),-1,'day'),'yyyymmdd'),'.txt'];
    end
    if ~regexpi(fileName,'txt','end') ,
        throw('FileFormatException:only .txt is allowed');
    end
    fidin = fopen(fileName,'r');
    srcData0 = textscan(fidin,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','BufSize',102400,'HeaderLines',3,'Delimiter',' ','MultipleDelimsAsOne',1);
    fclose(fidin);
    srcData = {};
    for i = 1:size(srcData0,2) ,
        srcData = [srcData,srcData0{i}];
    end
    
    zqmr = srcData(ismember(srcData(:,4),'证券买入'),:);
    zqmc = srcData(ismember(srcData(:,4),'证券卖出'),:);
    zyhgcc = srcData(ismember(srcData(:,4),'质押回购拆出'),:);
    cczygh = srcData(ismember(srcData(:,4),'拆出质押购回'),:);
   
    gpmr = regexprep(zqmr,'证券','股票');
    gpmc = regexprep(zqmc,'证券','股票');
    rqhg = regexprep(zyhgcc,'质押回购拆出','融券回购');
    rqgh = regexprep(cczygh,'拆出质押购回','融券购回');
    
    nGpmrR = size(gpmr,1);
    nGpmcR = size(gpmc,1);
    jy = cell(nGpmrR+nGpmcR,46);
    nRqhgR = size(rqhg,1);
    nRqghR = size(rqgh,1);
    hg = cell(nRqhgR+nRqghR,41);
    
    
    jy(:,2) = cellstr('9001');
    jy(1:nGpmrR,4) = gpmr(:,1);
    jy(nGpmrR+1:end,4) = gpmc(:,1);
    hg(:,2) = cellstr('9001');
    hg(1:nRqhgR,4) = rqhg(:,1);
    hg(nRqghR+1:end,4) = rqgh(:,1);
    
    hg(1:nRqhgR,4) = cellstr('40006');
    hg(nRqghR+1:end,4) = cellstr('40009');
    hg(1:nRqhgR,5) = rqhg(:,4);
    hg(nRqghR+1:end,5) = rqgh(:,4);
    hg(1:nRqhgR,6) = rqhg(:,18);
    hg(nRqghR+1:end,6) = rqgh(:,18);
    hg(:,7) = cellstr('D890767292');
    hg(:,10) = cellstr('D890767292');
    hg(1:nRqhgR,13) = rqhg(:,2);
    hg(nRqghR+1:end,13) = rqgh(:,2);
    hg(1:nRqhgR,14) = rqhg(:,6);
    hg(nRqghR+1:end,14) = regexprep(rqgh(:,6),'^-','');
    hg(1:nRqhgR,15) = rqhg(:,7);
    hg(nRqghR+1:end,15) = rqgh(:,7);
    hg(1:nRqhgR,16) = rqhg(:,8);
    hg(nRqghR+1:end,16) = rqgh(:,8);
    hg(1:nRqhgR,20) = rqhg(:,13);
    hg(nRqghR+1:end,20) = rqgh(:,13);
    hg(1:nRqhgR,21) = rqhg(:,1);
    hg(nRqghR+1:end,21) = rqgh(:,1);
    hg(1:nRqhgR,21) = rqhg(:,1);
    hg(nRqghR+1:end,21) = rqgh(:,1);
    hg(1:nRqhgR,21) = rqhg(:,1);
    hg(nRqghR+1:end,21) = rqgh(:,1);
    
    
    hg(1:nRqhgR,25) = rqhg(:,1);
    hg(nRqghR+1:end,25) = rqgh(:,1);
    
    
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
    jy(1:nGpmrR,20) = gpmr(:,9);
    jy(nGpmrR+1:end,20) = gpmc(:,9);
    jy(1:nGpmrR,21) = gpmr(:,10);
    jy(nGpmrR+1:end,21) = gpmc(:,10);
    jy(1:nGpmrR,24) = gpmr(:,13);
    jy(nGpmrR+1:end,24) = gpmc(:,13);
    jy(1:nGpmrR,37) = gpmr(:,18);
    jy(nGpmrR+1:end,37) = gpmc(:,18);
    jy(:,46) = cellstr('101');
    
    bill_code = cell(nGpmrR+nGpmcR,1);
    gpmr_sh_flag = str2num(char(gpmr(:,2)))>=600000;
    gpmc_sh_flag = str2num(char(gpmc(:,2)))>=600000;
    gp_sh_falg = [gpmr_sh_flag;gpmc_sh_flag];
    bill_code(:) = cellstr('SZ');
    bill_code(gp_sh_falg) = cellstr('SH');
    delegate_code = [gpmr(:,15);gpmc(:,15)];
    tmp = strcat(jy(:,4),jy(:,2));
    bill_code = strcat(bill_code,tmp,delegate_code);
    jy(:,3) = bill_code;
    
    xlswrite(['jy',regexprep(fileName,'txt',''),'xls'],jy,1,'A2');
    
    
    
end