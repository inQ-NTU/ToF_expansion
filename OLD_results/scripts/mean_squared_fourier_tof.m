clear all
close all

load('fourier_rmse_100nk_200points_200samples_no_1dconv.mat')
n_cutoff = 30;
n_sample = 100;

all_input_fourier = all_input_fourier.^2;
all_trans_fourier_1 = all_trans_fourier_1.^2;
all_trans_fourier_2 = all_trans_fourier_2.^2;
all_trans_fourier_3 = all_trans_fourier_3.^2;
all_woc_fourier_1 = all_woc_fourier_1.^2;
all_woc_fourier_2 = all_woc_fourier_2.^2;
all_woc_fourier_3 = all_woc_fourier_3.^2;
all_wc_fourier_1 = all_wc_fourier_1.^2;
all_wc_fourier_2 = all_wc_fourier_2.^2;
all_wc_fourier_3 = all_wc_fourier_3.^2;

mean_input = zeros(1,n_cutoff);

mean_trans_1 = zeros(1, n_cutoff);
mean_trans_2 = zeros(1, n_cutoff);
mean_trans_3 = zeros(1, n_cutoff);


mean_woc_1 = zeros(1, n_cutoff);
mean_woc_2 = zeros(1, n_cutoff);
mean_woc_3 = zeros(1, n_cutoff);

mean_wc_1 = zeros(1, n_cutoff);
mean_wc_2 = zeros(1, n_cutoff);
mean_wc_3 = zeros(1, n_cutoff);

for i = 1:n_cutoff
    mean_input(i) = mean(all_input_fourier(:,i));
    mean_trans_1(i) = mean(all_trans_fourier_1(:,i));
    mean_trans_2(i) = mean(all_trans_fourier_2(:,i));
    mean_trans_3(i) = mean(all_trans_fourier_3(:,i));

    mean_woc_1(i) = mean(all_woc_fourier_1(:,i));
    mean_woc_2(i) = mean(all_woc_fourier_2(:,i));
    mean_woc_3(i) = mean(all_woc_fourier_3(:,i));

    mean_wc_1(i) = mean(all_wc_fourier_1(:,i));
    mean_wc_2(i) = mean(all_wc_fourier_2(:,i));
    mean_wc_3(i) = mean(all_wc_fourier_3(:,i));
end
%Plotting
%t = 7 ms
f(1) = subplot(1,3,1);
plot(linspace(5,20, 16), mean_trans_1(5:20), 'o--','Color','Red','Linewidth',1.2)
hold on
plot(linspace(5,20, 16), mean_trans_2(5:20), 'x--','Color','Blue','Linewidth',1.2)
plot(linspace(5,20, 16), mean_trans_3(5:20),'^--','Color', [0,0.7,0],'Linewidth',1.2)
plot(linspace(5,20, 16), mean_input(5:20),'-','Color','Black','Linewidth',1.2)
%ylim([0,2])
title('Transversal','Interpreter','latex')
ylabel('$\langle \varphi_n^2 \rangle$','Interpreter','latex')
xlabel('$n$','Interpreter','latex')
legend({'$t = 7 \; ms$', '$t = 15 \; ms$', '$t = 30 \; ms$','Input'},'Interpreter','latex')

f(2) = subplot(1,3,2);
plot(linspace(5,20, 16), mean_woc_1(5:20), 'o--','Color','Red','Linewidth',1.2)
hold on
plot(linspace(5,20, 16), mean_woc_2(5:20), 'x--','Color','Blue','Linewidth',1.2)
plot(linspace(5,20, 16), mean_woc_3(5:20),'^--','Color', [0,0.7,0],'Linewidth',1.2)
plot(linspace(5,20, 16), mean_input(5:20),'-','Color','Black','Linewidth',1.2)
%ylim([0,2])
title('Full with $\varphi_c = 0$','Interpreter','latex')
xlabel('$n$','Interpreter', 'latex')


f(3) = subplot(1,3,3);
plot(linspace(5,20, 16), mean_wc_1(5:20), 'o--','Color','Red','Linewidth',1.2)
hold on
plot(linspace(5,20, 16), mean_wc_2(5:20), 'x--','Color','Blue','Linewidth',1.2)
plot(linspace(5,20, 16), mean_wc_3(5:20),'^--','Color', [0,0.7,0],'Linewidth',1.2)
plot(linspace(5,20, 16), mean_input(5:20),'-','Color','Black','Linewidth',1.2)
%ylim([0,2])
title('Full with $\varphi_c \neq 0$','Interpreter','latex')
xlabel('$n$','Interpreter','latex')
sgtitle('$\mathbf{T = 25 \; nK}$','Interpreter', 'latex','FontSize',20)

set(f, 'FontName','Times', 'FontSize', 16)

if 0
mean_diff_trans_1 = -(mean_trans_1 - mean_input);
mean_diff_trans_2 = -(mean_trans_2 - mean_input);
mean_diff_trans_3 = -(mean_trans_3 - mean_input);

mean_diff_woc_1 = -(mean_woc_1 - mean_input);
mean_diff_woc_2 = -(mean_woc_2 - mean_input);
mean_diff_woc_3 = -(mean_woc_3 - mean_input);

mean_diff_wc_1 = -(mean_wc_1 - mean_input);
mean_diff_wc_2 = -(mean_wc_2 - mean_input);
mean_diff_wc_3 = -(mean_wc_3 - mean_input);


f(1) = subplot(1,3,1);
plot(mean_diff_trans_1(2:end), 'o-','Color','Blue','Linewidth',1.2)
hold on
plot(mean_diff_trans_2(2:end), 'x-','Color', 'Red','Linewidth', 1.2)
plot(mean_diff_trans_3(2:end), '^-','Color',[0,0.7,0], 'Linewidth', 1.2)
ylim([-0.5,2])
title('Transversal','Interpreter','latex')
xlabel('$n$', 'interpreter', 'latex')
ylabel('$\langle \varphi_{n, in}^{2}\rangle - \langle \varphi_{n, out}^{2}\rangle$','Interpreter', 'latex')

f(2) = subplot(1,3,2);
plot(mean_diff_woc_1(2:end), 'o','Color','Blue','Linewidth', 1.2)
hold on
plot(mean_diff_woc_2(2:end), 'x','Color', 'Red','Linewidth',1.2)
plot(mean_diff_woc_3(2:end), '^','Color',[0,0.7,0], 'Linewidth', 1.2)
ylim([-0.5,2])
title('Full with $\varphi_c = 0$','Interpreter', 'latex')
legend({'$t = 7 \; ms$', '$t = 15 \; ms$', '$t = 30 \; ms$'},'Interpreter','latex')

f(3) = subplot(1,3,3);
plot(mean_diff_wc_1(2:end), 'o','Color','Blue','Linewidth',1.2)
hold on
plot(mean_diff_wc_2(2:end), 'x','Color', 'Red','Linewidth',1.2)
plot(mean_diff_wc_3(2:end), '^','Color',[0,0.7,0],'Linewidth',1.2)
ylim([-0.5,2])
title('Full with $\varphi_c \neq 0$', 'Interpreter', 'latex')

sgtitle('$\mathbf{T = 25\; nK}$','interpreter','latex','FontSize',20)

set(f, 'FontName', 'Times', 'FontSize', 16)
end

% Some data - replace it with yours (its from an earlier project)
% Define Start points, fit-function and fit curve
x0 = 1; 
fitfun = fittype(@(a,x) a./(x.^2) );

fitted_curve_input = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_input(2:end)',fitfun,'StartPoint',x0);

fitted_curve_trans_1 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_trans_1(2:end)',fitfun,'StartPoint',x0);
fitted_curve_trans_2 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_trans_2(2:end)',fitfun,'StartPoint',x0);
fitted_curve_trans_3 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_trans_3(2:end)',fitfun,'StartPoint',x0);

fitfun = fittype(@(a,x) a./(x.^2) );

fitted_curve_woc_1 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_woc_1(2:end)',fitfun,'StartPoint',x0);
fitted_curve_woc_2 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_woc_2(2:end)',fitfun,'StartPoint',x0);
fitted_curve_woc_3 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_woc_3(2:end)',fitfun,'StartPoint',x0);

fitfun = fittype(@(a,x) a./(x.^2) );
fitted_curve_wc_1 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_wc_1(2:end)',fitfun,'StartPoint',x0);
fitted_curve_wc_2 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_wc_2(2:end)',fitfun,'StartPoint',x0);
fitted_curve_wc_3 = fit(linspace(1,n_cutoff-1,n_cutoff-1)',mean_wc_3(2:end)',fitfun,'StartPoint',x0);

% Save the coeffiecient values for a,b,c and d in a vector
coeffvals_input = coeffvalues(fitted_curve_input);

coeffvals_trans_1 = coeffvalues(fitted_curve_trans_1);
coeffvals_trans_2 = coeffvalues(fitted_curve_trans_2);
coeffvals_trans_3 = coeffvalues(fitted_curve_trans_3);

coeffvals_woc_1 = coeffvalues(fitted_curve_woc_1);
coeffvals_woc_2 = coeffvalues(fitted_curve_woc_2);
coeffvals_woc_3 = coeffvalues(fitted_curve_woc_3);

coeffvals_wc_1 = coeffvalues(fitted_curve_wc_1);
coeffvals_wc_2 = coeffvalues(fitted_curve_wc_2);
coeffvals_wc_3 = coeffvalues(fitted_curve_wc_3);

save('temp_fitting_100nK.mat', 'coeffvals_input', 'coeffvals_trans_1','coeffvals_trans_2','coeffvals_trans_3', 'coeffvals_woc_1', 'coeffvals_woc_2', 'coeffvals_woc_3', 'coeffvals_wc_1', 'coeffvals_wc_2', 'coeffvals_wc_3')