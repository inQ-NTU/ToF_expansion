clear all;
close all
addpath('../../input')
load('phase_extraction_and_fourier_spectrum_25nK_200samples.mat')
momentum_cutoff = 31;
img_res = 2*momentum_cutoff;

mean_fourier_amp_woc_1_25nk = zeros(1,img_res/2);
mean_fourier_amp_woc_2_25nk = zeros(1,img_res/2);
mean_fourier_amp_woc_3_25nk = zeros(1,img_res/2); 

mean_fourier_amp_wc_1_25nk = zeros(1,img_res/2);
mean_fourier_amp_wc_2_25nk = zeros(1,img_res/2);
mean_fourier_amp_wc_3_25nk = zeros(1,img_res/2);

mean_fourier_amp_input_25nk = zeros(1,img_res/2);
mean_fourier_amp_trans_25nk = zeros(1,img_res/2);

for i = 1:img_res/2
    mean_fourier_amp_woc_1_25nk(i) = mean(fourier_amp_woc_1(:,i));
    mean_fourier_amp_woc_2_25nk(i) = mean(fourier_amp_woc_2(:,i));
    mean_fourier_amp_woc_3_25nk(i) = mean(fourier_amp_woc_3(:,i));

    mean_fourier_amp_wc_1_25nk(i) = mean(fourier_amp_wc_1(:,i));
    mean_fourier_amp_wc_2_25nk(i) = mean(fourier_amp_wc_2(:,i));
    mean_fourier_amp_wc_3_25nk(i) = mean(fourier_amp_wc_3(:,i));

    mean_fourier_amp_input_25nk(i) = mean(fourier_amp_in(:,i));
    mean_fourier_amp_trans_25nk(i) = mean(fourier_amp_trans(:,i));
end

load('phase_extraction_and_fourier_spectrum_35nK_200samples.mat')

mean_fourier_amp_woc_1_35nk = zeros(1,img_res/2);
mean_fourier_amp_woc_2_35nk = zeros(1,img_res/2);
mean_fourier_amp_woc_3_35nk = zeros(1,img_res/2);

mean_fourier_amp_wc_1_35nk = zeros(1,img_res/2);
mean_fourier_amp_wc_2_35nk = zeros(1,img_res/2);
mean_fourier_amp_wc_3_35nk = zeros(1,img_res/2);

mean_fourier_amp_input_35nk = zeros(1,img_res/2);
mean_fourier_amp_trans_35nk = zeros(1,img_res/2);

for i = 1:img_res/2
    mean_fourier_amp_woc_1_35nk(i) = mean(fourier_amp_woc_1(:,i));
    mean_fourier_amp_woc_2_35nk(i) = mean(fourier_amp_woc_2(:,i));
    mean_fourier_amp_woc_3_35nk(i) = mean(fourier_amp_woc_3(:,i));

    mean_fourier_amp_wc_1_35nk(i) = mean(fourier_amp_wc_1(:,i));
    mean_fourier_amp_wc_2_35nk(i) = mean(fourier_amp_wc_2(:,i));
    mean_fourier_amp_wc_3_35nk(i) = mean(fourier_amp_wc_3(:,i));

    mean_fourier_amp_input_35nk(i) = mean(fourier_amp_in(:,i));
    mean_fourier_amp_trans_35nk(i) = mean(fourier_amp_trans(:,i));
end


load('phase_extraction_and_fourier_spectrum_50nK_200samples.mat')

mean_fourier_amp_woc_1_50nk = zeros(1,img_res/2);
mean_fourier_amp_woc_2_50nk = zeros(1,img_res/2);
mean_fourier_amp_woc_3_50nk = zeros(1,img_res/2);

mean_fourier_amp_wc_1_50nk = zeros(1,img_res/2);
mean_fourier_amp_wc_2_50nk = zeros(1,img_res/2);
mean_fourier_amp_wc_3_50nk = zeros(1,img_res/2);

mean_fourier_amp_input_50nk = zeros(1,img_res/2);
mean_fourier_amp_trans_50nk = zeros(1,img_res/2);

for i = 1:img_res/2
    mean_fourier_amp_woc_1_50nk(i) = mean(fourier_amp_woc_1(:,i));
    mean_fourier_amp_woc_2_50nk(i) = mean(fourier_amp_woc_2(:,i));
    mean_fourier_amp_woc_3_50nk(i) = mean(fourier_amp_woc_3(:,i));

    mean_fourier_amp_wc_1_50nk(i) = mean(fourier_amp_wc_1(:,i));
    mean_fourier_amp_wc_2_50nk(i) = mean(fourier_amp_wc_2(:,i));
    mean_fourier_amp_wc_3_50nk(i) = mean(fourier_amp_wc_3(:,i));

    mean_fourier_amp_input_50nk(i) = mean(fourier_amp_in(:,i));
    mean_fourier_amp_trans_50nk(i) = mean(fourier_amp_trans(:,i));
end

load('phase_extraction_and_fourier_spectrum_75nK_200samples.mat')

mean_fourier_amp_woc_1_75nk = zeros(1,img_res/2);
mean_fourier_amp_woc_2_75nk = zeros(1,img_res/2);
mean_fourier_amp_woc_3_75nk = zeros(1,img_res/2);

mean_fourier_amp_wc_1_75nk = zeros(1,img_res/2);
mean_fourier_amp_wc_2_75nk = zeros(1,img_res/2);
mean_fourier_amp_wc_3_75nk = zeros(1,img_res/2);

mean_fourier_amp_input_75nk = zeros(1,img_res/2);
mean_fourier_amp_trans_75nk = zeros(1,img_res/2);

for i = 1:img_res/2
    mean_fourier_amp_woc_1_75nk(i) = mean(fourier_amp_woc_1(:,i));
    mean_fourier_amp_woc_2_75nk(i) = mean(fourier_amp_woc_2(:,i));
    mean_fourier_amp_woc_3_75nk(i) = mean(fourier_amp_woc_3(:,i));

    mean_fourier_amp_wc_1_75nk(i) = mean(fourier_amp_wc_1(:,i));
    mean_fourier_amp_wc_2_75nk(i) = mean(fourier_amp_wc_2(:,i));
    mean_fourier_amp_wc_3_75nk(i) = mean(fourier_amp_wc_3(:,i));

    mean_fourier_amp_input_75nk(i) = mean(fourier_amp_in(:,i));
    mean_fourier_amp_trans_75nk(i) = mean(fourier_amp_trans(:,i));
end

load('phase_extraction_and_fourier_spectrum_60nK_200samples.mat')

mean_fourier_amp_woc_1_60nk = zeros(1,img_res/2);
mean_fourier_amp_woc_2_60nk = zeros(1,img_res/2);
mean_fourier_amp_woc_3_60nk = zeros(1,img_res/2);

mean_fourier_amp_wc_1_60nk = zeros(1,img_res/2);
mean_fourier_amp_wc_2_60nk = zeros(1,img_res/2);
mean_fourier_amp_wc_3_60nk = zeros(1,img_res/2);

mean_fourier_amp_input_60nk = zeros(1,img_res/2);
mean_fourier_amp_trans_60nk = zeros(1,img_res/2);

for i = 1:img_res/2
    mean_fourier_amp_woc_1_60nk(i) = mean(fourier_amp_woc_1(:,i));
    mean_fourier_amp_woc_2_60nk(i) = mean(fourier_amp_woc_2(:,i));
    mean_fourier_amp_woc_3_60nk(i) = mean(fourier_amp_woc_3(:,i));

    mean_fourier_amp_wc_1_60nk(i) = mean(fourier_amp_wc_1(:,i));
    mean_fourier_amp_wc_2_60nk(i) = mean(fourier_amp_wc_2(:,i));
    mean_fourier_amp_wc_3_60nk(i) = mean(fourier_amp_wc_3(:,i));

    mean_fourier_amp_input_60nk(i) = mean(fourier_amp_in(:,i));
    mean_fourier_amp_trans_60nk(i) = mean(fourier_amp_trans(:,i));
end
k = 2*pi*(1:momentum_cutoff-1)/100;
%n = (1:momentum_cutoff-1);
fitfun = fittype(@(c,x) c./(x.^2));

%Fitting 25nk
fit_curve_woc_1_25nk = fit(k', mean_fourier_amp_woc_1_25nk(2:end)',fitfun);
fit_curve_woc_2_25nk = fit(k', mean_fourier_amp_woc_2_25nk(2:end)',fitfun);
fit_curve_woc_3_25nk = fit(k', mean_fourier_amp_woc_3_25nk(2:end)',fitfun);

fit_curve_wc_1_25nk = fit(k', mean_fourier_amp_wc_1_25nk(2:end)',fitfun);
fit_curve_wc_2_25nk = fit(k', mean_fourier_amp_wc_2_25nk(2:end)',fitfun);
fit_curve_wc_3_25nk = fit(k', mean_fourier_amp_wc_3_25nk(2:end)',fitfun);

fit_curve_trans_25nk = fit(k', mean_fourier_amp_trans_25nk(2:end)', fitfun);
fit_curve_input_25nk = fit(k', mean_fourier_amp_input_25nk(2:end)', fitfun);

%Fitting 50nk
fit_curve_woc_1_35nk = fit(k', mean_fourier_amp_woc_1_35nk(2:end)',fitfun);
fit_curve_woc_2_35nk = fit(k', mean_fourier_amp_woc_2_35nk(2:end)',fitfun);
fit_curve_woc_3_35nk = fit(k', mean_fourier_amp_woc_3_35nk(2:end)',fitfun);

fit_curve_wc_1_35nk = fit(k', mean_fourier_amp_wc_1_35nk(2:end)',fitfun);
fit_curve_wc_2_35nk = fit(k', mean_fourier_amp_wc_2_35nk(2:end)',fitfun);
fit_curve_wc_3_35nk = fit(k', mean_fourier_amp_wc_3_35nk(2:end)',fitfun);

fit_curve_trans_35nk = fit(k', mean_fourier_amp_trans_35nk(2:end)', fitfun);
fit_curve_input_35nk = fit(k', mean_fourier_amp_input_35nk(2:end)', fitfun);


%Fitting 50nk
fit_curve_woc_1_50nk = fit(k', mean_fourier_amp_woc_1_50nk(2:end)',fitfun);
fit_curve_woc_2_50nk = fit(k', mean_fourier_amp_woc_2_50nk(2:end)',fitfun);
fit_curve_woc_3_50nk = fit(k', mean_fourier_amp_woc_3_50nk(2:end)',fitfun);

fit_curve_wc_1_50nk = fit(k', mean_fourier_amp_wc_1_50nk(2:end)',fitfun);
fit_curve_wc_2_50nk = fit(k', mean_fourier_amp_wc_2_50nk(2:end)',fitfun);
fit_curve_wc_3_50nk = fit(k', mean_fourier_amp_wc_3_50nk(2:end)',fitfun);

fit_curve_trans_50nk = fit(k', mean_fourier_amp_trans_50nk(2:end)', fitfun);
fit_curve_input_50nk = fit(k', mean_fourier_amp_input_50nk(2:end)', fitfun);

%Fitting 75nk
fit_curve_woc_1_75nk = fit(k', mean_fourier_amp_woc_1_75nk(2:end)',fitfun);
fit_curve_woc_2_75nk = fit(k', mean_fourier_amp_woc_2_75nk(2:end)',fitfun);
fit_curve_woc_3_75nk = fit(k', mean_fourier_amp_woc_3_75nk(2:end)',fitfun);

fit_curve_wc_1_75nk = fit(k', mean_fourier_amp_wc_1_75nk(2:end)',fitfun);
fit_curve_wc_2_75nk = fit(k', mean_fourier_amp_wc_2_75nk(2:end)',fitfun);
fit_curve_wc_3_75nk = fit(k', mean_fourier_amp_wc_3_75nk(2:end)',fitfun);

fit_curve_trans_75nk = fit(k', mean_fourier_amp_trans_75nk(2:end)', fitfun);
fit_curve_input_75nk = fit(k', mean_fourier_amp_input_75nk(2:end)', fitfun);

%Fitting 60 nK
fit_curve_woc_1_60nk = fit(k', mean_fourier_amp_woc_1_60nk(2:end)',fitfun);
fit_curve_woc_2_60nk = fit(k', mean_fourier_amp_woc_2_60nk(2:end)',fitfun);
fit_curve_woc_3_60nk = fit(k', mean_fourier_amp_woc_3_60nk(2:end)',fitfun);

fit_curve_wc_1_60nk = fit(k', mean_fourier_amp_wc_1_60nk(2:end)',fitfun);
fit_curve_wc_2_60nk = fit(k', mean_fourier_amp_wc_2_60nk(2:end)',fitfun);
fit_curve_wc_3_60nk = fit(k', mean_fourier_amp_wc_3_60nk(2:end)',fitfun);

fit_curve_trans_60nk = fit(k', mean_fourier_amp_trans_60nk(2:end)', fitfun);
fit_curve_input_60nk = fit(k', mean_fourier_amp_input_60nk(2:end)', fitfun);


%Extracting the fit coefficients
coeff_woc_1 = [fit_curve_woc_1_25nk.c, fit_curve_woc_1_35nk.c, fit_curve_woc_1_50nk.c, fit_curve_woc_1_60nk.c, fit_curve_woc_1_75nk.c];
coeff_woc_2 = [fit_curve_woc_2_25nk.c, fit_curve_woc_2_35nk.c, fit_curve_woc_2_50nk.c, fit_curve_woc_2_60nk.c, fit_curve_woc_2_75nk.c];
coeff_woc_3 = [fit_curve_woc_3_25nk.c, fit_curve_woc_3_35nk.c, fit_curve_woc_3_50nk.c, fit_curve_woc_3_60nk.c, fit_curve_woc_3_75nk.c];
coeff_wc_1 = [fit_curve_wc_1_25nk.c, fit_curve_wc_1_35nk.c, fit_curve_wc_1_50nk.c, fit_curve_wc_1_60nk.c, fit_curve_wc_1_75nk.c];
coeff_wc_2 = [fit_curve_wc_2_25nk.c, fit_curve_wc_2_35nk.c, fit_curve_wc_2_50nk.c, fit_curve_wc_2_60nk.c, fit_curve_wc_2_75nk.c];
coeff_wc_3 = [fit_curve_wc_3_25nk.c, fit_curve_wc_3_35nk.c, fit_curve_wc_3_50nk.c, fit_curve_wc_3_60nk.c, fit_curve_wc_3_75nk.c];
coeff_trans = [fit_curve_trans_25nk.c, fit_curve_trans_35nk.c, fit_curve_trans_50nk.c, fit_curve_trans_60nk.c, fit_curve_trans_75nk.c];
coeff_input = [fit_curve_input_25nk.c, fit_curve_input_35nk.c, fit_curve_input_50nk.c, fit_curve_input_60nk.c, fit_curve_input_75nk.c];

%Linear fitting input
lin_fitfun = fittype(@(a,b,x) a+b*x);
temp_list = [25,35,50,60,75];
input_fit = fit(temp_list', coeff_input', lin_fitfun);

%Computing residue
Delta_k_woc_1 = mean_fourier_amp_input_50nk(5:end) - mean_fourier_amp_woc_1_50nk(5:end);
Delta_k_woc_2 = mean_fourier_amp_input_50nk(5:end) - mean_fourier_amp_woc_2_50nk(5:end);
Delta_k_woc_3 = mean_fourier_amp_input_50nk(5:end) - mean_fourier_amp_woc_3_50nk(5:end);

Delta_k_wc_1 = mean_fourier_amp_input_50nk(5:end) - mean_fourier_amp_wc_1_50nk(5:end);
Delta_k_wc_2 = mean_fourier_amp_input_50nk(5:end) - mean_fourier_amp_wc_2_50nk(5:end);
Delta_k_wc_3 = mean_fourier_amp_input_50nk(5:end) - mean_fourier_amp_wc_3_50nk(5:end);


%Load n = 10 data vs TOF
load('fourier_vs_tof_50nk_n10_higher_res.mat')
t_tof = linspace(7,31,9);
fourier_amp_in = mean(fourier_amp_in_stats);

%Plotting
figure
f = tight_subplot(2,3,[.07 .1],[.15 .1],[.1 .05]);

axes(f(1))
plot(t_tof, fourier_amp_woc*1e-2, '*--','Color', 'Black')
yline(fourier_amp_in*1e-2, '-','Color','Black')
xticks([])
ylabel('$\langle |\Phi_q|^2\rangle\; (\rm \mu m)$' , 'Interpreter','latex')
title('\textbf{a}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.1,0.8])
ylim([0,1])
yticks([0,0.5,1])
%ax = gca;
%ax.YAxis.Exponent = -2;


axes(f(2))
k = k(4:end);

plot(k, mean_fourier_amp_input_50nk(5:end)*1e2,'Color','Black')
hold on
plot(k, mean_fourier_amp_woc_1_50nk(5:end)*1e2, 'o-','Color', 'Blue','MarkerSize',3)
plot(k, mean_fourier_amp_woc_2_50nk(5:end)*1e2, 'x-', 'Color', 'Red','MarkerSize',3)
plot(k, mean_fourier_amp_woc_3_50nk(5:end)*1e2, '^-', 'Color', [0,0.7, 0], 'MarkerSize', 3)
plot(k, mean_fourier_amp_trans_50nk(5:end)*1e2, '.', 'Color','Black')
xlim([0,1.5])
xticks([])
ylabel('$\langle |\Phi_q|^2\rangle\; (\rm \mu m)$' , 'Interpreter','latex')
%ax = gca;
%ax.YAxis.Exponent= -2;
%ylim([0,4.3]*1e-2)
title('\textbf{b}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.1,0.8])

g(1) = axes('Position',[.54 .69 .08 .14]);
box on
plot(k, Delta_k_woc_1*1e2, 'o-', 'MarkerSize',2,'Color','Blue')
hold on
plot(k, Delta_k_woc_2*1e2,'x-','MarkerSize', 2, 'Color','Red')
plot(k, Delta_k_woc_3*1e2, '^-', 'MarkerSize', 2, 'Color', [0,0.7,0])
ylim([-0.2,1])
yline(0)
%xlim([0,1.5])
%ax = gca;
%ax.YAxis.Exponent = -2;


axes(f(3))
plot(temp_list, coeff_trans*1e2, '.','Color','Black')
hold on
plot(temp_list, coeff_woc_1*1e2,'o','Color','Blue')
plot(temp_list, coeff_woc_2*1e2, 'x', 'Color', 'Red')
plot(temp_list, coeff_woc_3*1e2, '^', 'Color', [0,0.7,0]);
plot(temp_list, input_fit(temp_list)*1e2,'Color','Black')
%ylim([0.5,2.5]*1e-3)
ax = gca;
ax.YAxis.Exponent = -1;
xticks([])
%yticks([0,1,2]*1e-3)
ylabel('$\alpha_{T_-}\; (\mu m^{-1})$','Interpreter','latex')
title('\textbf{c}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.1,0.8])

axes(f(4))
plot(t_tof, fourier_amp_wc*1e-2, '*--','Color','Black')
yline(fourier_amp_in*1e-2, '-','Color','Black')
xlabel('$t\; (\rm ms)$','Interpreter', 'latex')
title('\textbf{d}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.1,0.8])
ylim([0,1])
yticks([0,0.5,1])
ylabel('$\langle |\Phi_q|^2\rangle\; (\rm \mu m)$' , 'Interpreter','latex')
%ylim([0,1]*1e-2)
%ax = gca;
%ax.YAxis.Exponent = -2;


axes(f(5))
plot(k,mean_fourier_amp_input_50nk(5:end)*1e2,'Color','Black')
hold on
plot(k,mean_fourier_amp_wc_1_50nk(5:end)*1e2, 'o-','Color','Blue', 'MarkerSize', 3)
plot(k,mean_fourier_amp_wc_2_50nk(5:end)*1e2, 'x-', 'Color', 'Red', 'MarkerSize',3)
plot(k,mean_fourier_amp_wc_3_50nk(5:end)*1e2, '^-','Color', [0,0.7,0], 'MarkerSize',3)
plot(k,mean_fourier_amp_trans_50nk(5:end)*1e2, '.', 'Color','Black')
xlim([0,1.5])
%ax = gca;
%ax.YAxis.Exponent = -2;
%ylim([0,4.3]*1e-2)
xlabel('$q\; (\rm \mu m^{-1})$', 'Interpreter','latex')
title('\textbf{e}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.1,0.8])
ylabel('$\langle |\Phi_q|^2\rangle\; (\rm \mu m)$' , 'Interpreter','latex')

g(2) = axes('Position',[.54 .3 .08 .14]);
box on
plot(k, Delta_k_wc_1*1e2, 'o-', 'MarkerSize',2,'Color','Blue')
hold on
plot(k, Delta_k_wc_2*1e2,'x-','MarkerSize', 2, 'Color','Red')
plot(k, Delta_k_wc_3*1e2, '^-', 'MarkerSize', 2, 'Color', [0,0.7,0])
%xlim([0,1.5])
ylim([-0.2,1])
yticks([0,0.5,1])
yline(0)
%ax = gca;
%ax.YAxis.Exponent = -2;

axes(f(6))
plot(temp_list, coeff_trans*1e2, '.','Color', 'Black')
hold on
plot(temp_list, coeff_wc_1*1e2,'o','Color', 'Blue')
plot(temp_list, coeff_wc_2*1e2, 'x','Color','Red')
plot(temp_list, coeff_wc_3*1e2, '^','Color',[0,0.7,0])
plot(temp_list, input_fit(temp_list)*1e2,'Color','Black')
xlabel('$T_-\; (\rm nK)$','Interpreter', 'latex')
ylabel('$\alpha_{T_-}\; (\rm \mu m^{-1})$','Interpreter','latex')
ax = gca;
ax.YAxis.Exponent = -1;
xlim([20,80])
xticks([20,40,60,80])
title('\textbf{f}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[0.1,0.8])

set(f,'FontName','Times','FontSize', 16)
set(g,'FontName', 'Times', 'FontSize', 12)