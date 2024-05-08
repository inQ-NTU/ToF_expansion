clear all; close all;
addpath('../../classes')
addpath('../../input')


%wop - without processing, wp - with processing
%woc - without common phase, wc - with common phase
load('ext_phase_500samples_7ms_25nK_with_processing.mat')
rel_phase_7ms_25nk = rel_phase; 
ext_phase_woc_7ms_25nk = ext_phase_wop_woc;
ext_phase_wc_7ms_25nk = ext_phase_wop_wc;

load('ext_phase_500samples_15ms_25nK_with_processing.mat')
rel_phase_15ms_25nk = rel_phase; 
ext_phase_woc_15ms_25nk = ext_phase_wop_woc;
ext_phase_wc_15ms_25nk = ext_phase_wop_wc;

load('ext_phase_500samples_7ms_75nK_with_processing.mat')
rel_phase_7ms_75nk = rel_phase; 
ext_phase_woc_7ms_75nk = ext_phase_wop_woc;
ext_phase_wc_7ms_75nk = ext_phase_wop_wc;

load('ext_phase_500samples_15ms_75nK_with_processing.mat')
rel_phase_15ms_75nk = rel_phase; 
ext_phase_woc_15ms_75nk = ext_phase_wop_woc;
ext_phase_wc_15ms_75nk = ext_phase_wop_wc;

%7 ms TOF, 25 nK
corr_in_7ms_25nK = class_1d_correlation(rel_phase_7ms_25nk);
g2_in_7ms_25nK = corr_in_7ms_25nK.g2_corr();

corr_woc_7ms_25nK = class_1d_correlation(ext_phase_woc_7ms_25nk);
g2_woc_7ms_25nK = corr_woc_7ms_25nK.g2_corr();

corr_wc_7ms_25nK = class_1d_correlation(ext_phase_wc_7ms_25nk);
g2_wc_7ms_25nK = corr_wc_7ms_25nK.g2_corr();


%15 ms TOF, 25 nK
corr_in_15ms_25nK = class_1d_correlation(rel_phase_15ms_25nk);
g2_in_15ms_25nK = corr_in_15ms_25nK.g2_corr();

corr_woc_15ms_25nK = class_1d_correlation(ext_phase_woc_15ms_25nk);
g2_woc_15ms_25nK = corr_woc_15ms_25nK.g2_corr();

corr_wc_15ms_25nK = class_1d_correlation(ext_phase_wc_15ms_25nk);
g2_wc_15ms_25nK = corr_wc_15ms_25nK.g2_corr();

%7 ms TOF, 75 nK
corr_in_7ms_75nK = class_1d_correlation(rel_phase_7ms_75nk);
g2_in_7ms_75nK = corr_in_7ms_75nK.g2_corr();

corr_woc_7ms_75nK = class_1d_correlation(ext_phase_woc_7ms_75nk);
g2_woc_7ms_75nK = corr_woc_7ms_75nK.g2_corr();

corr_wc_7ms_75nK = class_1d_correlation(ext_phase_wc_7ms_75nk);
g2_wc_7ms_75nK = corr_wc_7ms_75nK.g2_corr();


%15 ms TOF, 75 nK
corr_in_15ms_75nK = class_1d_correlation(rel_phase_15ms_75nk);
g2_in_15ms_75nK = corr_in_15ms_75nK.g2_corr();

corr_woc_15ms_75nK = class_1d_correlation(ext_phase_woc_15ms_75nk);
g2_woc_15ms_75nK = corr_woc_15ms_75nK.g2_corr();

corr_wc_15ms_75nK = class_1d_correlation(ext_phase_wc_15ms_75nk);
g2_wc_15ms_75nK = corr_wc_15ms_75nK.g2_corr();


%Plotting
figure
f = tight_subplot(2,2,[.07 .05],[.15 .1],[.1 .1]);

axes(f(1))
plot(fine_grid, g2_in_7ms_25nK(50,:),'LineStyle','--', 'Color','Black')
hold on
plot(fine_grid, g2_woc_7ms_25nK(50,:), 'or', 'MarkerSize',4)
plot(fine_grid, g2_wc_7ms_25nK(50,:), 'xb', 'MarkerSize',4)
xticks([])
ylim([0.4,1])
title('\textbf{a}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])
ylabel('$C_\phi(z,0)$', 'Interpreter', 'latex')

axes(f(2))
plot(fine_grid, g2_in_15ms_25nK(50,:), 'LineStyle','--', 'Color','Black')
hold on
plot(fine_grid, g2_woc_15ms_25nK(50,:), 'or', 'MarkerSize',4)
plot(fine_grid, g2_wc_15ms_25nK(50,:), 'xb', 'MarkerSize',4)
xticks([])
yticks([])
ylim([0.4,1])
title('\textbf{b}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])

axes(f(3))
plot(fine_grid, g2_in_7ms_75nK(50,:), 'LineStyle','--', 'Color','Black')
hold on
plot(fine_grid, g2_woc_7ms_75nK(50,:), 'or', 'MarkerSize',4)
plot(fine_grid, g2_wc_7ms_75nK(50,:), 'xb', 'MarkerSize',4)
ylim([0,1])
title('\textbf{c}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])
ylabel('$C_\phi(z,0)$', 'Interpreter', 'latex')
xlabel('$z\; (\mu m)$', 'Interpreter','latex')

axes(f(4))
plot(fine_grid, g2_in_15ms_75nK(50,:), 'LineStyle','--', 'Color', 'Black')
hold on
plot(fine_grid, g2_woc_15ms_75nK(50,:), 'or', 'MarkerSize', 4)
plot(fine_grid, g2_wc_15ms_75nK(50,:), 'xb', 'MarkerSize',4)
yticks([])
ylim([0,1])
title('\textbf{d}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])
xlabel('$z\; (\mu m)$', 'Interpreter','latex')


set(f, 'FontName', 'Times', 'FontSize', 16)

