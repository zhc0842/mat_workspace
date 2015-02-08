function [str] = MM1()
	fidin = fopen('20150202-2.txt','r');
    str = '';
    while ~feof(fidin) ,
        tline = fgetl(fidin);
        disp(tline);
        str = strcat(str,tline);
    end
    fclose(fidin);
%     pat = '([\w\u4e00-\u9fa5])(?:\s{1,4})([\w\u4e00-\u9fa5])';
%     str = regexprep(str,pat,'$1$2');
    pat2 = '(?<=[\w\u4e00-\u9fa5])(?:\s{1,4})(?=[\w\u4e00-\u9fa5])';
    str = regexprep(str,pat2,'','emptymatch');

    
%     fgetl(fidin);
%     fgetl(fidin);
%     fgetl(fidin);
%     while ~feof(fidin) ,
%         tline = fgetl(fidin);
% %         disp(tline);
% %         str = strcat(str,tline,char(13));
%         tline = sprintf('%s\r\n',tline);
%         str = strcat(str,tline);
%     end
%     fclose(fidin);
%     pat = '(?<=[\w\u4e00-\u9fa5])(?:\s{1,4})(?=[\w\u4e00-\u9fa5])';
%     str = regexprep(str,pat,'','emptymatch');
    
end
