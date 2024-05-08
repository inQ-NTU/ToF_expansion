clear all
close all
addpath('../../classes')
addpath('../../input')
addpath('../phase_extraction_bank')

load('ext_phase_noise_level_500samples_with_processing.mat')

corr_noise = class_1d_correlation(ext_phase_wp_wc);
fourier_noise = diag(corr_noise.fourier_correlation());

load('ext_phase_500samples_7ms_75nK_with_processing.mat')

rel_phase_7ms = rel_phase; 
ext_phase_wop_woc_7ms = ext_phase_wop_woc;
ext_phase_wop_wc_7ms = ext_phase_wop_wc;
ext_phase_wp_woc_7ms = ext_phase_wp_woc;
ext_phase_wp_wc_7ms = ext_phase_wp_wc;

corr_in_7ms = class_1d_correlation(rel_phase_7ms);
corr_wop_woc_7ms = class_1d_correlation(ext_phase_wop_woc_7ms);
corr_wp_woc_7ms = class_1d_correlation(ext_phase_wp_woc_7ms);
corr_wop_wc_7ms = class_1d_correlation(ext_phase_wop_wc_7ms);
corr_wp_wc_7ms = class_1d_correlation(ext_phase_wp_wc_7ms);

fourier_corr_in_7ms = diag(corr_in_7ms.fourier_correlation());
fourier_corr_wop_woc_7ms = diag(corr_wop_woc_7ms.fourier_correlation());
fourier_corr_wop_wc_7ms = diag(corr_wop_wc_7ms.fourier_correlation());
fourier_corr_wp_woc_7ms = diag(corr_wp_woc_7ms.fourier_correlation());
fourier_corr_wp_wc_7ms = diag(corr_wp_wc_7ms.fourier_correlation());

load('ext_phase_500samples_15ms_75nK_with_processing.mat')

rel_phase_15ms = rel_phase; 
ext_phase_wop_woc_15ms = ext_phase_wop_woc;
ext_phase_wop_wc_15ms = ext_phase_wop_wc;
ext_phase_wp_woc_15ms = ext_phase_wp_woc;
ext_phase_wp_wc_15ms = ext_phase_wp_wc;

corr_in_15ms = class_1d_correlation(rel_phase_15ms);
corr_wop_woc_15ms = class_1d_correlation(ext_phase_wop_woc_15ms);
corr_wp_woc_15ms = class_1d_correlation(ext_phase_wp_woc_15ms);
corr_wop_wc_15ms = class_1d_correlation(ext_phase_wop_wc_15ms);
corr_wp_wc_15ms = class_1d_correlation(ext_phase_wp_wc_15ms);

fourier_corr_in_15ms = diag(corr_in_15ms.fourier_correlation());
fourier_corr_wop_woc_15ms = diag(corr_wop_woc_15ms.fourier_correlation());
fourier_corr_wop_wc_15ms = diag(corr_wop_wc_15ms.fourier_correlation());
fourier_corr_wp_woc_15ms = diag(corr_wp_woc_15ms.fourier_correlation());
fourier_corr_wp_wc_15ms = diag(corr_wp_wc_15ms.fourier_correlation());

load('ext_phase_500samples_10ms_75nK_with_processing.mat')

rel_phase_10ms = rel_phase; 
ext_phase_wop_woc_10ms = ext_phase_wop_woc;
ext_phase_wop_wc_10ms = ext_phase_wop_wc;
ext_phase_wp_woc_10ms = ext_phase_wp_woc;
ext_phase_wp_wc_10ms = ext_phase_wp_wc;

corr_in_10ms = class_1d_correlation(rel_phase_10ms);
corr_wop_woc_10ms = class_1d_correlation(ext_phase_wop_woc_10ms);
corr_wp_woc_10ms = class_1d_correlation(ext_phase_wp_woc_10ms);
corr_wop_wc_10ms = class_1d_correlation(ext_phase_wop_wc_10ms);
corr_wp_wc_10ms = class_1d_correlation(ext_phase_wp_wc_10ms);

fourier_corr_in_10ms = diag(corr_in_10ms.fourier_correlation());
fourier_corr_wop_woc_10ms = diag(corr_wop_woc_10ms.fourier_correlation());
fourier_corr_wop_wc_10ms = diag(corr_wop_wc_10ms.fourier_correlation());
fourier_corr_wp_woc_10ms = diag(corr_wp_woc_10ms.fourier_correlation());
fourier_corr_wp_wc_10ms = diag(corr_wp_wc_10ms.fourier_correlation());

load('ext_phase_500samples_13ms_75nK_with_processing.mat')

rel_phase_13ms = rel_phase; 
ext_phase_wop_woc_13ms = ext_phase_wop_woc;
ext_phase_wop_wc_13ms = ext_phase_wop_wc;
ext_phase_wp_woc_13ms = ext_phase_wp_woc;
ext_phase_wp_wc_13ms = ext_phase_wp_wc;

corr_in_13ms = class_1d_correlation(rel_phase_13ms);
corr_wop_woc_13ms = class_1d_correlation(ext_phase_wop_woc_13ms);
corr_wp_woc_13ms = class_1d_correlation(ext_phase_wp_woc_13ms);
corr_wop_wc_13ms = class_1d_correlation(ext_phase_wop_wc_13ms);
corr_wp_wc_13ms = class_1d_correlation(ext_phase_wp_wc_13ms);

fourier_corr_in_13ms = diag(corr_in_13ms.fourier_correlation());
fourier_corr_wop_woc_13ms = diag(corr_wop_woc_13ms.fourier_correlation());
fourier_corr_wop_wc_13ms = diag(corr_wop_wc_13ms.fourier_correlation());
fourier_corr_wp_woc_13ms = diag(corr_wp_woc_13ms.fourier_correlation());
fourier_corr_wp_wc_13ms = diag(corr_wp_wc_13ms.fourier_correlation());



load('ext_phase_500samples_18ms_75nK_with_processing.mat')

rel_phase_18ms = rel_phase; 
ext_phase_wop_woc_18ms = ext_phase_wop_woc;
ext_phase_wop_wc_18ms = ext_phase_wop_wc;
ext_phase_wp_woc_18ms = ext_phase_wp_woc;
ext_phase_wp_wc_18ms = ext_phase_wp_wc;

corr_in_18ms = class_1d_correlation(rel_phase_18ms);
corr_wop_woc_18ms = class_1d_correlation(ext_phase_wop_woc_18ms);
corr_wp_woc_18ms = class_1d_correlation(ext_phase_wp_woc_18ms);
corr_wop_wc_18ms = class_1d_correlation(ext_phase_wop_wc_18ms);
corr_wp_wc_18ms = class_1d_correlation(ext_phase_wp_wc_18ms);

fourier_corr_in_18ms = diag(corr_in_18ms.fourier_correlation());
fourier_corr_wop_woc_18ms = diag(corr_wop_woc_18ms.fourier_correlation());
fourier_corr_wop_wc_18ms = diag(corr_wop_wc_18ms.fourier_correlation());
fourier_corr_wp_woc_18ms = diag(corr_wp_woc_18ms.fourier_correlation());
fourier_corr_wp_wc_18ms = diag(corr_wp_wc_18ms.fourier_correlation());

load('ext_phase_500samples_21ms_75nK_with_processing.mat')

rel_phase_21ms = rel_phase; 
ext_phase_wop_woc_21ms = ext_phase_wop_woc;
ext_phase_wop_wc_21ms = ext_phase_wop_wc;
ext_phase_wp_woc_21ms = ext_phase_wp_woc;
ext_phase_wp_wc_21ms = ext_phase_wp_wc;

corr_in_21ms = class_1d_correlation(rel_phase_21ms);
corr_wop_woc_21ms = class_1d_correlation(ext_phase_wop_woc_21ms);
corr_wp_woc_21ms = class_1d_correlation(ext_phase_wp_woc_21ms);
corr_wop_wc_21ms = class_1d_correlation(ext_phase_wop_wc_21ms);
corr_wp_wc_21ms = class_1d_correlation(ext_phase_wp_wc_21ms);

fourier_corr_in_21ms = diag(corr_in_21ms.fourier_correlation());
fourier_corr_wop_woc_21ms = diag(corr_wop_woc_21ms.fourier_correlation());
fourier_corr_wop_wc_21ms = diag(corr_wop_wc_21ms.fourier_correlation());
fourier_corr_wp_woc_21ms = diag(corr_wp_woc_21ms.fourier_correlation());
fourier_corr_wp_wc_21ms = diag(corr_wp_wc_21ms.fourier_correlation());

load('ext_phase_500samples_24ms_75nK_with_processing.mat')

rel_phase_24ms = rel_phase; 
ext_phase_wop_woc_24ms = ext_phase_wop_woc;
ext_phase_wop_wc_24ms = ext_phase_wop_wc;
ext_phase_wp_woc_24ms = ext_phase_wp_woc;
ext_phase_wp_wc_24ms = ext_phase_wp_wc;

corr_in_24ms = class_1d_correlation(rel_phase_24ms);
corr_wop_woc_24ms = class_1d_correlation(ext_phase_wop_woc_24ms);
corr_wp_woc_24ms = class_1d_correlation(ext_phase_wp_woc_24ms);
corr_wop_wc_24ms = class_1d_correlation(ext_phase_wop_wc_24ms);
corr_wp_wc_24ms = class_1d_correlation(ext_phase_wp_wc_24ms);

fourier_corr_in_24ms = diag(corr_in_24ms.fourier_correlation());
fourier_corr_wop_woc_24ms = diag(corr_wop_woc_24ms.fourier_correlation());
fourier_corr_wop_wc_24ms = diag(corr_wop_wc_24ms.fourier_correlation());
fourier_corr_wp_woc_24ms = diag(corr_wp_woc_24ms.fourier_correlation());
fourier_corr_wp_wc_24ms = diag(corr_wp_wc_24ms.fourier_correlation());

t_tof = [7,10,13,15,18,21,24];

fix_k_data_in = [fourier_corr_in_7ms(12), fourier_corr_in_10ms(12), ...
    fourier_corr_in_13ms(12), fourier_corr_in_15ms(12), fourier_corr_in_18ms(12),...
    fourier_corr_in_21ms(12), fourier_corr_in_24ms(12)];

fix_k_data_wop_woc = [fourier_corr_wop_woc_7ms(12), fourier_corr_wop_woc_10ms(12), ...
    fourier_corr_wop_woc_13ms(12), fourier_corr_wop_woc_15ms(12), fourier_corr_wop_woc_18ms(12),...
    fourier_corr_wop_woc_21ms(12), fourier_corr_wop_woc_24ms(12)];
fix_k_data_wp_woc = [fourier_corr_wp_woc_7ms(12), fourier_corr_wp_woc_10ms(12), ...
    fourier_corr_wp_woc_13ms(12), fourier_corr_wp_woc_15ms(12), fourier_corr_wp_woc_18ms(12),...
    fourier_corr_wp_woc_21ms(12), fourier_corr_wp_woc_24ms(12)];

fix_k_data_wop_wc = [fourier_corr_wop_wc_7ms(12), fourier_corr_wop_wc_10ms(12), ...
    fourier_corr_wop_wc_13ms(12), fourier_corr_wop_wc_15ms(12), fourier_corr_wop_wc_18ms(12),...
    fourier_corr_wop_wc_21ms(12), fourier_corr_wop_wc_24ms(12)];
fix_k_data_wp_wc = [fourier_corr_wp_wc_7ms(12), fourier_corr_wp_wc_10ms(12), ...
    fourier_corr_wp_wc_13ms(12), fourier_corr_wp_wc_15ms(12), fourier_corr_wp_wc_18ms(12),...
    fourier_corr_wp_wc_21ms(12), fourier_corr_wp_wc_24ms(12)];


figure
f = tight_subplot(2,2,[.12 .05],[.15 .1],[.1 .1]);
k1 = 2*pi*linspace(6,20,15)/100;
k2 = 2*pi*linspace(10,2,11)/100;

axes(f(1))
plot(t_tof, fix_k_data_wop_woc, 'o-','Color', 'blue')
hold on
plot(t_tof, fix_k_data_wp_woc, 'x-', 'Color', 'red')
yline(mean(fix_k_data_in))
ylim([0.002, 0.01])
xlabel('$t\; \rm (ms)$', 'Interpreter', 'latex')
ylabel('$\langle |\Phi_k|^2\rangle$', 'Interpreter','latex')
title('\textbf{a}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])

axes(f(2))
plot(t_tof, fix_k_data_wop_wc, 'o-', 'Color','blue')
hold on
plot(t_tof, fix_k_data_wp_wc, 'x-', 'Color', 'red')
yline(mean(fix_k_data_in))
ylim([0.002, 0.01])
yticks([])
xlabel('$t\; \rm (ms)$', 'Interpreter', 'latex')
title('\textbf{b}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])

axes(f(3))
plot(k1, fourier_corr_in_15ms(6:20),'-','Color','Black')
hold on
plot(k1, fourier_corr_wop_woc_15ms(6:20),'o-', 'Color', 'Blue')
plot(k1, fourier_corr_wp_woc_15ms(6:20),'x-', 'Color','Red')
plot(k1, fourier_noise(6:20), '-.','Color', 'Black')
xlim([0.35,1.2])
ax = gca;
ax.YAxis.Exponent= -2;
xlabel('$k\; \rm (\mu m^{-1})$', 'Interpreter', 'latex')
ylabel('$\langle |\Phi_k|^2\rangle$', 'Interpreter','latex')
title('\textbf{c}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])
xline(0.44 ,'--')
ylim([0,0.04])


axes(f(4))
plot(k1, fourier_corr_in_15ms(6:20),'-','Color','Black')
hold on
plot(k1, fourier_corr_wop_wc_15ms(6:20),'o-','Color','Blue')
plot(k1, fourier_corr_wp_wc_15ms(6:20),'x-', 'Color', 'Red')
yticks([])
ylim([0,0.04])
xlim([0.35,1.2])
xlabel('$k\; (\mu m^{-1})$', 'Interpreter', 'latex')
title('\textbf{d}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.8])
plot(k1, fourier_noise(6:20), '-.','Color', 'Black')
xline(0.44, '--')

set(f, 'FontName', 'Times', 'FontSize', 16)