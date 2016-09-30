function [bestCVaccuarcy, bestc, bestg] = FOA_SVM(train_label, trainsample, foa_option, handles)
%% 数据初始化
[row,col] = size(trainsample);

%***内部不再分组
tr = trainsample;
t = train_label;

%% 果蝇优化spread参数
%初始果蝇群体位置
X_axis = foa_option.sx*rands(1,2);
Y_axis = foa_option.sy*rands(1,2);
maxgen = foa_option.maxgen;  %迭代次数
sizepop = foa_option.sizepop;  %种群规模

%% 果蝇寻优开始
%利用嗅觉寻找食物
for i = 1:sizepop
    %初始果蝇个体飞行距离
    X(i,:) = X_axis + foa_option.ax*rand() - foa_option.bx;
    Y(i,:) = Y_axis + foa_option.ay*rand() - foa_option.by;
    
    %求出与原点之距离
    D(i,1) = (X(i,1)^2+Y(i,1)^2)^0.5;
    D(i,2) = (X(i,2)^2+Y(i,2)^2)^0.5;
    
    %味道浓度为距离之倒数,先求出味道浓度判定值
    S(i,1) = 1/D(i,1);
    S(i,2) = 1/D(i,2);
    
    %***设定SVM参数值
    c = S(i,1);  %利用FOA调整参数c
    g = S(i,2);  %利用FOA调整参数g
    
    %***计算初始适应度
    cmd = ['-v ', num2str(5), ' -c ', num2str(c), ' -g ', num2str(g)];
    accuracy = svmtrain(t, tr, cmd);
    Smell(i) = accuracy;
    
end

%***根據初始味道濃度值尋找初始極值
[bestSmell, bestindex] = max(Smell);

%利用視覺尋找夥伴聚集味道濃度最高之處
%做法是保留最佳值初始位置及初始味道濃度
X_axis = X(bestindex,:);
Y_axis = Y(bestindex,:);
bestc = S(bestindex,1);
bestg = S(bestindex,2);
bestCVaccuarcy = bestSmell;

%% 果蠅迭代尋優
%  fprintf('Enter iterative fruit fly searching ....\n')
for gen = 1:maxgen   %迭代次数
    for i = 1:sizepop
        %初始果蝇个体飞行距离
        X(i,:) = X_axis + foa_option.ax*rand() - foa_option.bx;
        Y(i,:) = Y_axis + foa_option.ay*rand() - foa_option.by;
        
        %求出与原点之距离
        D(i,1) = (X(i,1)^2+Y(i,1)^2)^0.5;
        D(i,2) = (X(i,2)^2+Y(i,2)^2)^0.5;
        
        %味道浓度为距离之倒数,先求出味道浓度判定值
        S(i,1) = 1/D(i,1);
        S(i,2) = 1/D(i,2);
        
        %***设定SVR参数值
        c = S(i,1); %利用FOA调整参数c
        g = S(i,2);  %利用FOA调整参数g
        
        %***计算初始适应度
        cmd = ['-v ', num2str(5), ' -c ', num2str(c), ' -g ', num2str(g)];
        accuracy = svmtrain(t, tr, cmd);
        Smell(i) = accuracy;
    end
    
    %***根據味道濃度值尋找極值
    [bestSmell, bestindex] = max(Smell);
    
    %***迭代保留最佳值位置與味道濃度
    if bestSmell > bestCVaccuarcy
        X_axis = X(bestindex,:);
        Y_axis = Y(bestindex,:);
        bestc = S(bestindex,1);
        bestg = S(bestindex,2);
        bestCVaccuarcy = bestSmell;
    end
    
    %***每代最优值纪录到yy数组中
    yy(gen) = bestCVaccuarcy;
    Xbest(gen,:) = X_axis;
    Ybest(gen,:) = Y_axis;
    avgfitness_gen(gen) = sum(Smell)/foa_option.sizepop;
        
end

%% 绘制优化趋势图
draw_fitness(handles, yy, avgfitness_gen);

% figure
% hold on
% plot(yy, 'g', 'LineWidth', 1.5)
% plot(avgfitness_gen, 'r', 'LineWidth', 1.5)
% title('Fitness curve', 'fontsize', 12)
% xlabel('Number of iterations', 'fontsize', 12);
% ylabel('Classification accuracy (%)', 'fontsize', 12);


% toc % record end time