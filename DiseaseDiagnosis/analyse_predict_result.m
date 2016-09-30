% ������������н��ͳ��
function [predict_result] = analyse_predict_result(predict_label)

M = size(predict_label, 1);
N = size(predict_label, 2);

% ͳ���в�1��û��2�ĸ����������浽������
predict_result = zeros(M, 1);
for i = 1 : M
%     predict_result(i) = 0;
    for j = 1 : N
        if predict_label(i, j) == 1
            predict_result(i) = predict_result(i) + 1;
        end
    end
end

% ȷ��ÿ�������Ƿ��в��������浽������
for i = 1 : M
    if predict_result(i) >= N/2
        predict_result(i) = 1;
    else
        predict_result(i) = 2;
    end
end
