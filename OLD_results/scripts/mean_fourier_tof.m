clear all
close all
load('fourier_rmse_25nk_200points_no_1dconv.mat')
n_cutoff = 40;
n_sample = 100;

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
plot(mean_trans_1, '-','Color','Red')
hold on
plot(mean_trans_2, '-','Color','Blue')
plot(mean_trans_3,'-','Color', 'Green')
ylim([0,2])
title('Transversal','Interpreter','latex')
ylabel('Scaled mean')
xlabel('n')

f(2) = subplot(1,3,2);
plot(mean_woc_1, '-','Color','Red')
hold on
plot(mean_woc_2, '-','Color','Blue')
plot(mean_woc_3,'-','Color', 'Green')
ylim([0,2])
title('Full with $\varphi_c = 0$','Interpreter','latex')
xlabel('n')
legend({'$t = 7 \; ms$', '$t = 15 \; ms$', '$t = 30 \; ms$'},'Interpreter','latex')

f(3) = subplot(1,3,3);
plot(mean_wc_1, '-','Color','Red')
hold on
plot(mean_wc_2, '-','Color','Blue')
plot(mean_wc_3,'-','Color', 'Green')
ylim([0,2])
title('Full with $\varphi_c \neq 0$','Interpreter','latex')
xlabel('n')
sgtitle('$\mathbf{T = 100 \; nK}$','Interpreter', 'latex')

set(f, 'FontName','Times', 'FontSize', 16)
