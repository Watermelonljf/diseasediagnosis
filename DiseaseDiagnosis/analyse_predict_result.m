% 结果分析，进行结果统计
function [predict_result] = analyse_predict_result(predict_label)

M = size(predict_label, 1);
N = size(predict_label, 2);

% 统计有病1和没病2的个数，并保存到数组中
predict_result = zeros(M, 1);
for i = 1 : M
%     predict_result(i) = 0;
    for j = 1 : N
        if predict_label(i, j) == 1
            predict_result(i) = predict_result(i) + 1;
        end
    end
end

% 确定每个病例是否有病，并保存到数组中
for i = 1 : M
    if predict_result(i) >= N/2
        predict_result(i) = 1;
    else
        predict_result(i) = 2;
    end
end
