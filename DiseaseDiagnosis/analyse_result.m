function [acc,sens,spec]=analyse_result(T,Y) % ���� ׼ȷ�� ���ж� �����
if max(T) >2
    t_correct=0;      %��ȷ�ĸ���
    [m n] = size(T);
    for j=1:m
        if T(j,1) == Y(j,1);  %ͳ�ƶԲ�������������ȷ�ĸ���
            t_correct = t_correct+1;
        end
    end
    acc = t_correct/m;%������ȷ��
    sens = 0; 
    spec = 0;
else
    Y(Y==1)=1; Y(Y==2)=-1;  % target class (positive) is 1 ����(�в�����)��Ϊ1
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
% %�������Խ����������ȷ�ʣ������ʣ����жȣ�����ȣ������ʣ�©����
% %���������experiment_test����������,��һ��Ϊ��ǩ
% %          Result�����Խ������m*1 ������������������
% %���������correct ��ȷ��
% %         error ������
% %         ROC 1*4 ������  ROC��1�����ж� ROC��2������� ROC��3�������� ROC��4��©����
%
% t_correct=0;      %��ȷ�ĸ���
% sensitivity=0;    % ���ж�
% differential=0;   %�����
% misjustice=0;     %������
% escape_diagnose=0;%©����
% [m n] = size(TrueLable);
% %�������жȣ�����ȣ������ʣ�©����
%  for j=1:m
%      if TrueLable(j,1) == PredicLable(j,1);  %ͳ�ƶԲ�������������ȷ�ĸ���
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
% correct=t_correct/m;%������ȷ��
% error=1-correct; %���������
% sensitivity=sensitivity/size(find(experiment_test(:,1)==2),1);% ���ж�
% specificity=differential/size(find(experiment_test(:,1)==1),1); %�����

% ROC(1)=sensitivity/size(find(experiment_test(:,1)==1),1);% ���ж�
% ROC(2)=differential/size(find(experiment_test(:,1)==2),1); %�����
% ROC(3)=misjustice/size(find(experiment_test(:,1)==2),1);%������
% ROC(4)=escape_diagnose/size(find(experiment_test(:,1)==1),1);%©����
