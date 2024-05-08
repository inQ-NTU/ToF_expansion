clear all; close all;
addpath('../../classes')
addpath('../../input')

load('ext_phase_500samples_7ms_25nK_with_processing.mat')
rel_phase_7ms_25nk = rel_phase; 
ext_phase_wop_7ms_25nk = ext_phase_wop_wc;
ext_phase_wp_7ms_25nk = ext_phase_wp_wc;

load('ext_phase_500samples_15ms_25nK_with_processing.mat')
rel_phase_15ms_25nk = rel_phase; 
ext_phase_wop_15ms_25nk = ext_phase_wop_wc;
ext_phase_wp_15ms_25nk = ext_phase_wp_wc;

load('ext_phase_500samples_7ms_75nK_with_processing.mat')
rel_phase_7ms_75nk = rel_phase; 
ext_phase_wop_7ms_75nk = ext_phase_wop_wc;
ext_phase_wp_7ms_75nk = ext_phase_wp_wc;

load('ext_phase_500samples_15ms_75nK_with_processing.mat')
rel_phase_15ms_75nk = rel_phase; 
ext_phase_wop_15ms_75nk = ext_phase_wop_wc;
ext_phase_wp_15ms_75nk = ext_phase_wp_wc;

%7 ms TOF, 25 nK
corr_in_7ms_25nK = class_1d_correlation(rel_phase_7ms_25nk);
g2_in_7ms_25nK = corr_in_7ms_25nK.g2_corr();

corr_wop_7ms_25nK = class_1d_correlation(ext_phase_wop_7ms_25nk);
g2_wop_7ms_25nK = corr_wop_7ms_25nK.g2_corr();

corr_wp_7ms_25nK = class_1d_correlation(ext_phase_wp_7ms_25nk);
g2_wp_7ms_25nK = corr_wp_7ms_25nK.g2_corr();


%15 ms TOF, 25 nK
corr_in_15ms_25nK = class_1d_correlation(rel_phase_15ms_25nk);
g2_in_15ms_25nK = corr_in_15ms_25nK.g2_corr();

corr_wop_15ms_25nK = class_1d_correlation(ext_phase_wop_15ms_25nk);
g2_wop_15ms_25nK = corr_wop_15ms_25nK.g2_corr();

corr_wp_15ms_25nK = class_1d_correlation(ext_phase_wp_15ms_25nk);
g2_wp_15ms_25nK = corr_wp_15ms_25nK.g2_corr();

%7 ms TOF, 75 nK
corr_in_7ms_75nK = class_1d_correlation(rel_phase_7ms_75nk);
g2_in_7ms_75nK = corr_in_7ms_75nK.g2_corr();

corr_wop_7ms_75nK = class_1d_correlation(ext_phase_wop_7ms_75nk);
g2_wop_7ms_75nK = corr_wop_7ms_75nK.g2_corr();

corr_wp_7ms_75nK = class_1d_correlation(ext_phase_wp_7ms_75nk);
g2_wp_7ms_75nK = corr_wp_7ms_75nK.g2_corr();


%15 ms TOF, 75 nK
corr_in_15ms_75nK = class_1d_correlation(rel_phase_15ms_75nk);
g2_in_15ms_75nK = corr_in_15ms_75nK.g2_corr();

corr_wop_15ms_75nK = class_1d_correlation(ext_phase_wop_15ms_75nk);
g2_wop_15ms_75nK = corr_wop_15ms_75nK.g2_corr();

corr_wp_15ms_75nK = class_1d_correlation(ext_phase_wp_15ms_75nk);
g2_wp_15ms_75nK = corr_wp_15ms_75nK.g2_corr();

figure
f = tight_subplot(2,2,[.07 .05],[.15 .1],[.1 .1]);

axes(f(1))
plot(fine_grid, g2_in_7ms_25nK(50,:),'LineStyle','--', 'Color','Black')
hold on
plot(fine_grid, g2_wop_7ms_25nK(50,:), 'ob', 'MarkerSize',4)
plot(coarse_grid, g2_wp_7ms_25nK(26,:), 'x', 'MarkerSize',6, 'Color', 'red')
xticks([])
ylim([0.4,1])
title('\textbf{a}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])
ylabel('$C_\phi(z,0)$', 'Interpreter', 'latex')

axes(f(2))
plot(fine_grid, g2_in_15ms_25nK(50,:), 'LineStyle','--', 'Color','Black')
hold on
plot(fine_grid, g2_wop_15ms_25nK(50,:), 'ob', 'MarkerSize',4)
plot(coarse_grid, g2_wp_15ms_25nK(26,:), 'x', 'MarkerSize',6, 'Color', 'red')
xticks([])
yticks([])
ylim([0.4,1])
title('\textbf{b}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])

axes(f(3))
plot(fine_grid, g2_in_7ms_75nK(50,:), 'LineStyle','--', 'Color','Black')
hold on
plot(fine_grid, g2_wop_7ms_75nK(50,:), 'ob', 'MarkerSize',4)
plot(coarse_grid, g2_wp_7ms_75nK(26,:), 'x', 'MarkerSize',6, 'Color', 'red')
ylim([0,1])
title('\textbf{c}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])
ylabel('$C_\phi(z,0)$', 'Interpreter', 'latex')
xlabel('$z\; (\mu m)$', 'Interpreter','latex')

axes(f(4))
plot(fine_grid, g2_in_15ms_75nK(50,:), 'LineStyle','--', 'Color', 'Black')
hold on
plot(fine_grid, g2_wop_15ms_75nK(50,:), 'ob', 'MarkerSize', 4)
plot(coarse_grid, g2_wp_15ms_75nK(26,:), 'x', 'MarkerSize',6, 'Color', 'red')
yticks([])
ylim([0,1])
title('\textbf{d}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])
xlabel('$z\; (\mu m)$', 'Interpreter','latex')


set(f, 'FontName', 'Times', 'FontSize', 16)

