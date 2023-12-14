clear all
close all

load('fourier_vs_tof_n10_50nk.mat')

load('fft_stats_25nk_15ms.mat')
mean_fourier_amp_woc_25nk = mean_fourier_amp_woc(2:end);
mean_fourier_amp_wc_25nk = mean_fourier_amp_wc(2:end);
mean_fourier_amp_woc_ref_25nk = mean_fourier_amp_woc_ref(2:end);
mean_fourier_amp_wc_ref_25nk = mean_fourier_amp_wc_ref(2:end);

load('fft_stats_50nk_15ms.mat')
mean_fourier_amp_woc_50nk = mean_fourier_amp_woc(2:end);
mean_fourier_amp_wc_50nk = mean_fourier_amp_wc(2:end);
mean_fourier_amp_woc_ref_50nk = mean_fourier_amp_woc_ref(2:end);
mean_fourier_amp_wc_ref_50nk = mean_fourier_amp_wc_ref(2:end);

load('fft_stats_75nk_15ms.mat')
mean_fourier_amp_woc_75nk = mean_fourier_amp_woc(2:end);
mean_fourier_amp_wc_75nk = mean_fourier_amp_wc(2:end);
mean_fourier_amp_woc_ref_75nk = mean_fourier_amp_woc_ref(2:end);
mean_fourier_amp_wc_ref_75nk = mean_fourier_amp_wc_ref(2:end);


load('fft_stats_100nk_15ms.mat')
mean_fourier_amp_woc_100nk = mean_fourier_amp_woc(2:end);
mean_fourier_amp_wc_100nk = mean_fourier_amp_wc(2:end);
mean_fourier_amp_woc_ref_100nk = mean_fourier_amp_woc_ref(2:end);
mean_fourier_amp_wc_ref_100nk = mean_fourier_amp_wc_ref(2:end);

k = 2*pi*(1:25)/100;
fitfun = fittype( @(a,x) a./(x.^2));
linear_fit = fittype( @(a,b,x) a+b*x);
fitted_curve_woc_25nk = fit(k',mean_fourier_amp_woc_25nk',fitfun);
fitted_curve_woc_50nk = fit(k',mean_fourier_amp_woc_50nk',fitfun);
fitted_curve_woc_75nk = fit(k',mean_fourier_amp_woc_75nk',fitfun);
fitted_curve_woc_100nk = fit(k',mean_fourier_amp_woc_100nk',fitfun);

fitted_curve_woc_ref_25nk = fit(k',mean_fourier_amp_woc_ref_25nk',fitfun);
fitted_curve_woc_ref_50nk = fit(k',mean_fourier_amp_woc_ref_50nk',fitfun);
fitted_curve_woc_ref_75nk = fit(k',mean_fourier_amp_woc_ref_75nk',fitfun);
fitted_curve_woc_ref_100nk = fit(k',mean_fourier_amp_woc_ref_100nk',fitfun);

fitted_curve_wc_25nk = fit(k',mean_fourier_amp_wc_25nk',fitfun);
fitted_curve_wc_50nk = fit(k',mean_fourier_amp_wc_50nk',fitfun);
fitted_curve_wc_75nk = fit(k',mean_fourier_amp_wc_75nk',fitfun);
fitted_curve_wc_100nk = fit(k',mean_fourier_amp_wc_100nk',fitfun);

fitted_curve_wc_ref_25nk = fit(k',mean_fourier_amp_wc_ref_25nk',fitfun);
fitted_curve_wc_ref_50nk = fit(k',mean_fourier_amp_wc_ref_50nk',fitfun);
fitted_curve_wc_ref_75nk = fit(k',mean_fourier_amp_wc_ref_75nk',fitfun);
fitted_curve_wc_ref_100nk = fit(k',mean_fourier_amp_wc_ref_100nk',fitfun);

coeff_list_woc = [coeffvalues(fitted_curve_woc_25nk), coeffvalues(fitted_curve_woc_50nk), coeffvalues(fitted_curve_woc_75nk), coeffvalues(fitted_curve_woc_100nk)];
coeff_list_wc = [coeffvalues(fitted_curve_wc_25nk), coeffvalues(fitted_curve_wc_50nk), coeffvalues(fitted_curve_wc_75nk), coeffvalues(fitted_curve_wc_100nk)];

coeff_list_woc_ref = [coeffvalues(fitted_curve_woc_ref_25nk), coeffvalues(fitted_curve_woc_ref_50nk), coeffvalues(fitted_curve_woc_ref_75nk), coeffvalues(fitted_curve_woc_ref_100nk)];
coeff_list_wc_ref = [coeffvalues(fitted_curve_wc_ref_25nk), coeffvalues(fitted_curve_wc_ref_50nk), coeffvalues(fitted_curve_wc_ref_75nk), coeffvalues(fitted_curve_wc_ref_100nk)];

T_list = [25, 50, 75, 100];
T_refine = linspace(25,100);
%Linear fitting
lin_fit_woc = fit(T_list', coeff_list_woc',linear_fit);
lin_fit_woc_ref = fit(T_list', coeff_list_woc_ref',linear_fit);
lin_fit_wc = fit(T_list', coeff_list_wc',linear_fit);
lin_fit_wc_ref = fit(T_list', coeff_list_wc_ref',linear_fit);


f = tight_subplot(2,3,[.08 .06],[.15 .1],[.1 .05]);

axes(f(1))
plot(t_tof*1e3, mean_amp_woc, 'x-','Color','red')
hold on
plot(t_tof*1e3, mean_amp_woc_ref, 'o-','Color','Blue')
ylim([0,1e-2])
ylabel('$\langle |\Phi_k|^2\rangle$', 'Interpreter', 'latex')
ax = gca;
ax.YAxis.Exponent = -2;
xticks([])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(2))
plot(k(5:end), mean_fourier_amp_woc_75nk(5:end), 'x-','Color','red')
hold on
plot(k(5:end), mean_fourier_amp_woc_ref_75nk(5:end), 'o-','Color', 'Blue')
xticks([])
ylim([0,4e-2])
ax = gca;
ax.YAxis.Exponent = -2;
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);


axes(f(3))
plot(T_list, coeff_list_woc, 'x','Color', 'red')
hold on
plot(T_list, coeff_list_woc_ref, 'o','Color','blue')
plot(T_refine, lin_fit_woc(T_refine),'Color','red')
plot(T_refine, lin_fit_woc_ref(T_refine), 'Color','blue')
ylim([0,3e-3])
xticks([])
ylabel('$\alpha_T$', 'Interpreter', 'latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);


axes(f(4))
plot(t_tof*1e3, mean_amp_wc, 'x-','Color','red')
hold on
plot(t_tof*1e3, mean_amp_wc_ref, 'o-','Color','Blue')
ylim([0,1e-2])
ax = gca;
ax.YAxis.Exponent = -2;
ylabel('$\langle |\Phi_k|^2\rangle$', 'Interpreter', 'latex')
xlabel('$t \; \rm (ms)$', 'Interpreter', 'latex')
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);


axes(f(5))
plot(k(5:end), mean_fourier_amp_wc_75nk(5:end), 'x-','Color','red')
hold on
plot(k(5:end), mean_fourier_amp_wc_ref_75nk(5:end), 'o-','Color', 'Blue')
xlabel('$k \; \rm (\mu m^{-1})$', 'Interpreter', 'latex')
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
ax = gca;
ax.YAxis.Exponent = -2;

axes(f(6))
plot(T_list, coeff_list_wc, 'x','Color','red')
hold on
plot(T_list, coeff_list_wc_ref, 'o','Color','blue')
plot(T_refine, lin_fit_wc(T_refine),'Color','red')
plot(T_refine, lin_fit_wc_ref(T_refine), 'Color','blue')
ylim([0,3e-3])
xlabel('$T_-\; \rm (nK)$', 'Interpreter', 'latex')
ylabel('$\alpha_T$', 'Interpreter', 'latex')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

set(f, 'FontName', 'Times', 'FontSize', 16)