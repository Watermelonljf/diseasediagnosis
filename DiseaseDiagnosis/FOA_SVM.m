function [bestCVaccuarcy, bestc, bestg] = FOA_SVM(train_label, trainsample, foa_option, handles)
%% ���ݳ�ʼ��
[row,col] = size(trainsample);

%***�ڲ����ٷ���
tr = trainsample;
t = train_label;

%% ��Ӭ�Ż�spread����
%��ʼ��ӬȺ��λ��
X_axis = foa_option.sx*rands(1,2);
Y_axis = foa_option.sy*rands(1,2);
maxgen = foa_option.maxgen;  %��������
sizepop = foa_option.sizepop;  %��Ⱥ��ģ

%% ��ӬѰ�ſ�ʼ
%�������Ѱ��ʳ��
for i = 1:sizepop
    %��ʼ��Ӭ������о���
    X(i,:) = X_axis + foa_option.ax*rand() - foa_option.bx;
    Y(i,:) = Y_axis + foa_option.ay*rand() - foa_option.by;
    
    %�����ԭ��֮����
    D(i,1) = (X(i,1)^2+Y(i,1)^2)^0.5;
    D(i,2) = (X(i,2)^2+Y(i,2)^2)^0.5;
    
    %ζ��Ũ��Ϊ����֮����,�����ζ��Ũ���ж�ֵ
    S(i,1) = 1/D(i,1);
    S(i,2) = 1/D(i,2);
    
    %***�趨SVM����ֵ
    c = S(i,1);  %����FOA��������c
    g = S(i,2);  %����FOA��������g
    
    %***�����ʼ��Ӧ��
    cmd = ['-v ', num2str(5), ' -c ', num2str(c), ' -g ', num2str(g)];
    accuracy = svmtrain(t, tr, cmd);
    Smell(i) = accuracy;
    
end

%***������ʼζ�����ֵ���ҳ�ʼ�Oֵ
[bestSmell, bestindex] = max(Smell);

%����ҕ�X����ⷰ�ۼ�ζ��������֮̎
%�����Ǳ������ֵ��ʼλ�ü���ʼζ�����
X_axis = X(bestindex,:);
Y_axis = Y(bestindex,:);
bestc = S(bestindex,1);
bestg = S(bestindex,2);
bestCVaccuarcy = bestSmell;

%% ��ω��������
%  fprintf('Enter iterative fruit fly searching ....\n')
for gen = 1:maxgen   %��������
    for i = 1:sizepop
        %��ʼ��Ӭ������о���
        X(i,:) = X_axis + foa_option.ax*rand() - foa_option.bx;
        Y(i,:) = Y_axis + foa_option.ay*rand() - foa_option.by;
        
        %�����ԭ��֮����
        D(i,1) = (X(i,1)^2+Y(i,1)^2)^0.5;
        D(i,2) = (X(i,2)^2+Y(i,2)^2)^0.5;
        
        %ζ��Ũ��Ϊ����֮����,�����ζ��Ũ���ж�ֵ
        S(i,1) = 1/D(i,1);
        S(i,2) = 1/D(i,2);
        
        %***�趨SVR����ֵ
        c = S(i,1); %����FOA��������c
        g = S(i,2);  %����FOA��������g
        
        %***�����ʼ��Ӧ��
        cmd = ['-v ', num2str(5), ' -c ', num2str(c), ' -g ', num2str(g)];
        accuracy = svmtrain(t, tr, cmd);
        Smell(i) = accuracy;
    end
    
    %***����ζ�����ֵ���ҘOֵ
    [bestSmell, bestindex] = max(Smell);
    
    %***�����������ֵλ���cζ�����
    if bestSmell > bestCVaccuarcy
        X_axis = X(bestindex,:);
        Y_axis = Y(bestindex,:);
        bestc = S(bestindex,1);
        bestg = S(bestindex,2);
        bestCVaccuarcy = bestSmell;
    end
    
    %***ÿ������ֵ��¼��yy������
    yy(gen) = bestCVaccuarcy;
    Xbest(gen,:) = X_axis;
    Ybest(gen,:) = Y_axis;
    avgfitness_gen(gen) = sum(Smell)/foa_option.sizepop;
        
end

%% �����Ż�����ͼ
draw_fitness(handles, yy, avgfitness_gen);

% figure
% hold on
% plot(yy, 'g', 'LineWidth', 1.5)
% plot(avgfitness_gen, 'r', 'LineWidth', 1.5)
% title('Fitness curve', 'fontsize', 12)
% xlabel('Number of iterations', 'fontsize', 12);
% ylabel('Classification accuracy (%)', 'fontsize', 12);


% toc % record end time