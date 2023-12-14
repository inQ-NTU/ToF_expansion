clear all
close all
load('temp_fitting_25nK.MAT')
coeffvals_input_25nk = coeffvals_input;
coeffvals_trans_1_25nk = coeffvals_trans_1;
coeffvals_trans_2_25nk = coeffvals_trans_2;
coeffvals_trans_3_25nk = coeffvals_trans_3;

coeffvals_woc_1_25nk = coeffvals_woc_1;
coeffvals_woc_2_25nk = coeffvals_woc_2;
coeffvals_woc_3_25nk = coeffvals_woc_3;

coeffvals_wc_1_25nk = coeffvals_wc_1;
coeffvals_wc_2_25nk = coeffvals_wc_2;
coeffvals_wc_3_25nk = coeffvals_wc_3;

load('temp_fitting_50nK.mat')

coeffvals_input_50nk = coeffvals_input;
coeffvals_trans_1_50nk = coeffvals_trans_1;
coeffvals_trans_2_50nk = coeffvals_trans_2;
coeffvals_trans_3_50nk = coeffvals_trans_3;

coeffvals_woc_1_50nk = coeffvals_woc_1;
coeffvals_woc_2_50nk = coeffvals_woc_2;
coeffvals_woc_3_50nk = coeffvals_woc_3;

coeffvals_wc_1_50nk = coeffvals_wc_1;
coeffvals_wc_2_50nk = coeffvals_wc_2;
coeffvals_wc_3_50nk = coeffvals_wc_3;

load('temp_fitting_75nk.mat')
coeffvals_input_75nk = coeffvals_input;
coeffvals_trans_1_75nk = coeffvals_trans_1;
coeffvals_trans_2_75nk = coeffvals_trans_2;
coeffvals_trans_3_75nk = coeffvals_trans_3;

coeffvals_woc_1_75nk = coeffvals_woc_1;
coeffvals_woc_2_75nk = coeffvals_woc_2;
coeffvals_woc_3_75nk = coeffvals_woc_3;

coeffvals_wc_1_75nk = coeffvals_wc_1;
coeffvals_wc_2_75nk = coeffvals_wc_2;
coeffvals_wc_3_75nk = coeffvals_wc_3;

load('temp_fitting_100nk.mat')
coeffvals_input_100nk = coeffvals_input;
coeffvals_trans_1_100nk = coeffvals_trans_1;
coeffvals_trans_2_100nk = coeffvals_trans_2;
coeffvals_trans_3_100nk = coeffvals_trans_3;

coeffvals_woc_1_100nk = coeffvals_woc_1;
coeffvals_woc_2_100nk = coeffvals_woc_2;
coeffvals_woc_3_100nk = coeffvals_woc_3;

coeffvals_wc_1_100nk = coeffvals_wc_1;
coeffvals_wc_2_100nk = coeffvals_wc_2;
coeffvals_wc_3_100nk = coeffvals_wc_3;

temp_list = [25,50,75,100];
data_input = [coeffvals_input_25nk, coeffvals_input_50nk, coeffvals_input_75nk, coeffvals_input_100nk];

data_trans_1 = [coeffvals_trans_1_25nk, coeffvals_trans_1_50nk, coeffvals_trans_1_75nk, coeffvals_trans_1_100nk];
data_trans_2 = [coeffvals_trans_2_25nk, coeffvals_trans_2_50nk, coeffvals_trans_2_75nk, coeffvals_trans_2_100nk];
data_trans_3 = [coeffvals_trans_1_25nk, coeffvals_trans_3_50nk, coeffvals_trans_3_75nk, coeffvals_trans_3_100nk];

data_woc_1 = [coeffvals_woc_1_25nk, coeffvals_woc_1_50nk, coeffvals_woc_1_75nk, coeffvals_woc_1_100nk];
data_woc_2 = [coeffvals_woc_2_25nk, coeffvals_woc_2_50nk, coeffvals_woc_2_75nk, coeffvals_woc_2_100nk];
data_woc_3 = [coeffvals_woc_1_25nk, coeffvals_woc_3_50nk, coeffvals_woc_3_75nk, coeffvals_woc_3_100nk];

data_wc_1 = [coeffvals_wc_1_25nk, coeffvals_wc_1_50nk, coeffvals_wc_1_75nk, coeffvals_wc_1_100nk];
data_wc_2 = [coeffvals_wc_2_25nk, coeffvals_wc_2_50nk, coeffvals_wc_2_75nk, coeffvals_wc_2_100nk];
data_wc_3 = [coeffvals_wc_1_25nk, coeffvals_wc_3_50nk, coeffvals_wc_3_75nk, coeffvals_wc_3_100nk];

%fitting
fitfun = fittype(@(a,b,x) a*x+b);
fit_input = fit(temp_list', data_input', fitfun);
fit_trans_1 = fit(temp_list', data_trans_1', fitfun);
fit_trans_2 = fit(temp_list', data_trans_2', fitfun);
fit_trans_3 = fit(temp_list', data_trans_3', fitfun);

fit_woc_1 = fit(temp_list', data_woc_1', fitfun);
fit_woc_2 = fit(temp_list', data_woc_2', fitfun);
fit_woc_3 = fit(temp_list', data_woc_3', fitfun);

fit_wc_1 = fit(temp_list', data_wc_1', fitfun);
fit_wc_2 = fit(temp_list', data_wc_2', fitfun);
fit_wc_3 = fit(temp_list', data_wc_3', fitfun);


f(1) = subplot(1,3,1);
x = linspace(25,100);
plot(temp_list, data_trans_1, 'o', 'Color','blue','Linewidth',1.2)
hold on
plot(x, fit_trans_1(x), 'Color','blue','Linewidth',1.2)
plot(temp_list, data_trans_2, 'x', 'Color', 'red','Linewidth',1.2)
plot(x, fit_trans_2(x), 'Color', 'red','Linewidth',1.2)
plot(temp_list, data_trans_3, '^','Color',[0,0.7,0],'Linewidth',1.2)
plot(x, fit_trans_3(x), 'Color', [0,0.7,0],'Linewidth',1.2)
plot(temp_list, data_input, '.','Color','black','Linewidth',1.2)
plot(x, fit_input(x), 'Color','black','Linewidth',1.2)
hold off
title('Transverse','Interpreter','latex')
ylim([20,140])
xlabel('$T\; (nK)$', 'Interpreter','latex')
ylabel('$C$','Interpreter', 'latex')

f(2) = subplot(1,3,2);
plot(temp_list, data_woc_1, 'o', 'Color','blue','Linewidth',1.2)
hold on
plot(x, fit_woc_1(x), 'Color','blue','Linewidth',1.2)
plot(temp_list, data_woc_2, 'x', 'Color', 'red','Linewidth',1.2)
plot(x, fit_woc_2(x), 'Color','red')
plot(temp_list, data_woc_3, '^','Color',[0,0.7,0],'Linewidth',1.2)
plot(x, fit_woc_3(x), 'Color',[0,0.7,0],'Linewidth',1.2)
plot(temp_list, data_input, '.','Color','black','Linewidth',1.2)
plot(x, fit_input(x), 'Color','black','Linewidth',1.2)
title('Full with $\varphi_c = 0$','Interpreter','latex')
ylim([20,140])
xlabel('$T\; (nK)$', 'Interpreter','latex')
ylabel('$C$','Interpreter', 'latex')

f(3) = subplot(1,3,3);
plot(temp_list, data_wc_1, 'o', 'Color','blue','Linewidth',1.2)
hold on
plot(x, fit_wc_1(x), 'Color','blue','Linewidth',1.2)
plot(temp_list, data_wc_2, 'x', 'Color', 'red','Linewidth',1.2)
plot(x, fit_woc_2(x), 'Color','red','Linewidth',1.2)
plot(temp_list, data_wc_3, '^','Color',[0,0.7,0],'Linewidth',1.2)
plot(x, fit_woc_3(x), 'Color',[0,0.7,0],'Linewidth',1.2)
plot(temp_list, data_input, '.','Color','black','Linewidth',1.2)
plot(x, fit_input(x), 'Color','black','Linewidth',1.2)
title('Full with $\varphi_c \neq 0 (T_c = T_r)$','Interpreter','latex')
legend({'$7 \; ms$','', '$15 \; ms$','', '$30\; ms$','', 'Input',''},'Interpreter','latex')
xlabel('$T\; (nK)$', 'Interpreter','latex')
set(f,'FontName','Times','FontSize', 14)
ylabel('$C$','Interpreter', 'latex')