% matlabpool local 4;
% 
% parfor ...
% 
% matlabpool close;
function TestParallel
% 并行
matlabpool local 4;

tic;
total=10^6;
parfor i=1:total
    ss(i)=inSum;
end
plot(ss);
toc;

matlabpool close;
end
%

% function TestNoParallel
% % 不并行
% 
% tic;
% total=10^6;
% for i=1:total
%     ss(i)=inSum;
% end
% plot(ss);
% toc;
% 
% end


function [s]=inSum
    x=abs(round(normrnd(50,40,1,1000)));
    s=sum(x);
end