% 绘制优化趋势图
function draw_fitness(handles, yy, avgfitness_gen)
axes(handles.axesA);
cla reset;
hold on
plot(yy, 'g', 'LineWidth', 1.5)
plot(avgfitness_gen, 'r', 'LineWidth', 1.5)
title('Fitness curve', 'fontsize', 12)
xlabel('Number of iterations', 'fontsize', 12);
ylabel('Classification accuracy (%)', 'fontsize', 12);
