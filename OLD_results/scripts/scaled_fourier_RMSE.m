clear all
load('fourier_RMSE_100nk_200points_no_1dconv.mat')
n_cutoff = 100;
n_sample = 100;
rmse_trans_1 = zeros(1, n_cutoff);
rmse_trans_2 = zeros(1, n_cutoff);
rmse_trans_3 = zeros(1, n_cutoff);


rmse_woc_1 = zeros(1, n_cutoff);
rmse_woc_2 = zeros(1, n_cutoff);
rmse_woc_3 = zeros(1, n_cutoff);

rmse_wc_1 = zeros(1, n_cutoff);
rmse_wc_2 = zeros(1, n_cutoff);
rmse_wc_3 = zeros(1, n_cutoff);

%avg_occupation = zeros(1, n_cutoff);

for i = 1:n_cutoff
    %avg_occupation(i) = mean(all_woc_fourier_3(:,i));
    rmse_trans_1(i) = rmse(all_input_fourier(i,:), all_trans_fourier_1(i,:))/max(all_input_fourier(i,:));
    rmse_trans_2(i) = rmse(all_input_fourier(i,:), all_trans_fourier_2(i,:))/max(all_input_fourier(i,:));
    rmse_trans_3(i) = rmse(all_input_fourier(i,:), all_trans_fourier_3(i,:))/max(all_input_fourier(i,:));

    rmse_woc_1(i) = rmse(all_input_fourier(i,:), all_woc_fourier_1(i,:))/max(all_input_fourier(i,:));
    rmse_woc_2(i) = rmse(all_input_fourier(i,:), all_woc_fourier_2(i,:))/max(all_input_fourier(i,:));
    rmse_woc_3(i) = rmse(all_input_fourier(i,:), all_woc_fourier_3(i,:))/max(all_input_fourier(i,:));

    rmse_wc_1(i) = rmse(all_input_fourier(i,:), all_wc_fourier_1(i,:))/max(all_input_fourier(i,:));
    rmse_wc_2(i) = rmse(all_input_fourier(i,:), all_wc_fourier_2(i,:))/max(all_input_fourier(i,:));
    rmse_wc_3(i) = rmse(all_input_fourier(i,:), all_wc_fourier_3(i,:))/max(all_input_fourier(i,:));
end

%Plotting
%t = 7 ms
f(1) = subplot(1,3,1);
plot(rmse_trans_1, 'o--','Color','Red')
hold on
plot(rmse_trans_2, 'o--','Color','Blue')
plot(rmse_trans_3,'o--','Color', 'Green')
ylim([0,2])
title('Transversal','Interpreter','latex')
ylabel('Scaled RMSE')
xlabel('n')

f(2) = subplot(1,3,2);
plot(rmse_woc_1, 'o--','Color','Red')
hold on
plot(rmse_woc_2, 'o--','Color','Blue')
plot(rmse_woc_3,'o--','Color', 'Green')
ylim([0,2])
title('Full with $\varphi_c = 0$','Interpreter','latex')
xlabel('n')
legend({'$t = 7 \; ms$', '$t = 15 \; ms$', '$t = 30 \; ms$'},'Interpreter','latex')

f(3) = subplot(1,3,3);
plot(rmse_wc_1, 'o--','Color','Red')
hold on
plot(rmse_wc_2, 'o--','Color','Blue')
plot(rmse_wc_3,'o--','Color', 'Green')
ylim([0,2])
title('Full with $\varphi_c \neq 0$','Interpreter','latex')
xlabel('n')
sgtitle('$\mathbf{T = 100 \; nK}$','Interpreter', 'latex')

set(f, 'FontName','Times', 'FontSize', 16)