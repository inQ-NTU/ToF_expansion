clear all
close all
addpath('../../classes')
addpath('../../input')
addpath('../phase_extraction_bank/')
load('ext_phase_500samples_with_processing.mat')

corr_in = class_1d_correlation(rel_phase);
corr_wop_woc = class_1d_correlation(ext_phase_wop_woc);
corr_wp_woc = class_1d_correlation(ext_phase_wp_woc);
corr_wop_wc = class_1d_correlation(ext_phase_wop_wc);
corr_wp_wc = class_1d_correlation(ext_phase_wp_wc);

fourier_corr_in = diag(corr_in.fourier_correlation());
fourier_corr_wop_woc = diag(corr_wop_woc.fourier_correlation());
fourier_corr_wop_wc = diag(corr_wop_wc.fourier_correlation());
fourier_corr_wp_woc = diag(corr_wp_woc.fourier_correlation());
fourier_corr_wp_wc = diag(corr_wp_wc.fourier_correlation());

k1 = 2*pi*linspace(5,20,16)/100;
k2 = 2*pi*linspace(10,20,11)/100;

figure
f = tight_subplot(1,2,[.05 .05],[.15 .1],[.1 .1]);

axes(f(1))
plot(k1, fourier_corr_in(5:20),'o--','Color','Black')
hold on
plot(k1, fourier_corr_wop_woc(5:20),'x-', 'Color', 'Blue')
plot(k1, fourier_corr_wp_woc(5:20),'^-', 'Color','Red')
ax = gca;
ax.YAxis.Exponent= -2;
xlabel('$k\; (\mu m^{-1})$', 'Interpreter', 'latex')
ylabel('$\langle |\Phi_k|^2\rangle$', 'Interpreter','latex')
title('\textbf{a}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.9])

g(1) = axes('Position',[.24 .55 .2 .25]);
box on
plot(k2,fourier_corr_in(10:20) - fourier_corr_wop_woc(10:20) ,'x--', 'Color', 'Blue')
hold on
plot(k2, fourier_corr_in(10:20) - fourier_corr_wp_woc(10:20), '^--', 'Color','Red')
xlim([0.6,1.3])
xlabel('$k\; (\mu m^{-1})$', 'Interpreter', 'latex')
ylabel('$\Delta_k$', 'Interpreter','latex')

axes(f(2))
plot(k1, fourier_corr_in(5:20),'o--','Color','Black')
hold on
plot(k1, fourier_corr_wop_wc(5:20),'x-','Color','Blue')
plot(k1, fourier_corr_wp_wc(5:20),'^-', 'Color', 'Red')
yticks([])
xlabel('$k\; (\mu m^{-1})$', 'Interpreter', 'latex')
title('\textbf{b}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.9,0.9])

g(2) = axes('Position',[.67 .55 .2 .25]);
box on
plot(fourier_corr_in(3:20) - fourier_corr_wop_wc(3:20) ,'x--','Color','Blue')
hold on
plot(fourier_corr_in(3:20) - fourier_corr_wp_wc(3:20), '^--','Color', 'Red')
%xlim([0.6,1.3])
xlabel('$k\; (\mu m^{-1})$', 'Interpreter', 'latex')
ylabel('$\Delta_k$', 'Interpreter','latex')

set(f, 'FontName', 'Times', 'FontSize', 16)
set(g, 'FontName', 'Times', 'FontSize', 12)






