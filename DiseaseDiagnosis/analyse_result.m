function [acc,sens,spec]=analyse_result(T,Y) % 返回 准确率 敏感度 特异度
if max(T) >2
    t_correct=0;      %正确的个数
    [m n] = size(T);
    for j=1:m
        if T(j,1) == Y(j,1);  %统计对测试样本分类正确的个数
            t_correct = t_correct+1;
        end
    end
    acc = t_correct/m;%计算正确率
    sens = 0; 
    spec = 0;
else
    Y(Y==1)=1; Y(Y==2)=-1;  % target class (positive) is 1 阳性(有病患者)设为1
    T(T==1)=1; T(T==2)=-1;
    TP=sum( ( (Y==1) + (T==1) )==2 );
    FN=sum( ( (Y==-1) + (T==1) )==2 );
    FP=sum( ( (Y==1) + (T==-1) )==2 );
    TN=sum( ( (Y==-1) + (T==-1) )==2 );
    acc = (TP+TN)/(TP+FN+FP+TN);
    sens = TP/(TP+FN);
    spec = TN/(FP+TN);
    %    TP=TP/(TP+FN); TPR
    %    FP=FP/(FP+TN); FPR
end

% function [correct,sensitivity,specificity] = analyse_result(T,Y)
% %分析测试结果，计算正确率，错误率，敏感度，特异度，误判率，漏判率
% %输入参数：experiment_test：测试样本,第一列为标签
% %          Result：测试结果，是m*1 列向量，包含分类结果
% %输出参数：correct 正确率
% %         error 错误率
% %         ROC 1*4 行向量  ROC（1）敏感度 ROC（2）特异度 ROC（3）误判率 ROC（4）漏判率
%
% t_correct=0;      %正确的个数
% sensitivity=0;    % 敏感度
% differential=0;   %特异度
% misjustice=0;     %误判率
% escape_diagnose=0;%漏判率
% [m n] = size(TrueLable);
% %计算敏感度，特异度，误判率，漏诊率
%  for j=1:m
%      if TrueLable(j,1) == PredicLable(j,1);  %统计对测试样本分类正确的个数
%          t_correct=t_correct+1;
%      end
%       if (TrueLable(j,1)==2 && Result(j,1)==2)
%           sensitivity=sensitivity+1;
%       else if(experiment_test(j,1)==1 && Result(j,1)==1)
%            differential=differential+1;
%       else if(experiment_test(j,1)==2 && Result(j,1)==1)
%            misjustice=misjustice+1;
%       else if(experiment_test(j,1)==1 && Result(j,1)==2)
%            escape_diagnose=escape_diagnose+1;
%           end
%           end
%           end
%       end
%  end
% correct=t_correct/m;%计算正确率
% error=1-correct; %计算错误率
% sensitivity=sensitivity/size(find(experiment_test(:,1)==2),1);% 敏感度
% specificity=differential/size(find(experiment_test(:,1)==1),1); %特异度

% ROC(1)=sensitivity/size(find(experiment_test(:,1)==1),1);% 敏感度
% ROC(2)=differential/size(find(experiment_test(:,1)==2),1); %特异度
% ROC(3)=misjustice/size(find(experiment_test(:,1)==2),1);%误判率
% ROC(4)=escape_diagnose/size(find(experiment_test(:,1)==1),1);%漏判率
