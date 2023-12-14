chosen_idx = 12;
n_cutoff = 100;
fourier_input = all_input_fourier(chosen_idx,:);
fourier_fit_1_trans = all_trans_fourier_1(chosen_idx,:);
fourier_fit_2_trans = all_trans_fourier_2(chosen_idx,:);
fourier_fit_3_trans = all_trans_fourier_3(chosen_idx,:);
fourier_fit_1_woc = all_woc_fourier_1(chosen_idx,:);
fourier_fit_2_woc = all_woc_fourier_2(chosen_idx,:);
fourier_fit_3_woc = all_woc_fourier_3(chosen_idx,:);
fourier_fit_1_wc = all_wc_fourier_1(chosen_idx,:);
fourier_fit_2_wc = all_wc_fourier_2(chosen_idx,:);
fourier_fit_3_wc = all_wc_fourier_3(chosen_idx,:);
fourier_fit_1_trans_dev = fourier_fit_1_trans - fourier_input;
fourier_fit_2_trans_dev = fourier_fit_2_trans - fourier_input;
fourier_fit_3_trans_dev = fourier_fit_3_trans - fourier_input;
fourier_fit_1_woc_dev = fourier_fit_1_woc - fourier_input;
fourier_fit_2_woc_dev = fourier_fit_2_woc - fourier_input;
fourier_fit_3_woc_dev = fourier_fit_3_woc - fourier_input;
fourier_fit_1_wc_dev = fourier_fit_1_wc - fourier_input;
fourier_fit_2_wc_dev = fourier_fit_2_wc - fourier_input;
fourier_fit_3_wc_dev = fourier_fit_3_wc - fourier_input;




figure
h(1) = subplot(2,3,1);
plot(n_grid, fourier_input(1:n_cutoff+1),'color','black','LineWidth', 2)
hold on
plot(n_grid, fourier_fit_1_trans(1:n_cutoff+1),'o', 'Color', 'blue')
plot(n_grid, fourier_fit_2_trans(1:n_cutoff+1),'x', 'Color','red', 'MarkerSize', 8, 'LineWidth',1.2)
plot(n_grid, fourier_fit_3_trans(1:n_cutoff+1),'^', 'Color',[0,0.7,0])
hold off
xlabel('$n$','Interpreter','latex')
ylabel('$\varphi_n$','Interpreter','latex')
ylim([0,5])
title('Transversal','Interpreter','latex')

h(2) = subplot(2,3,2);
plot(n_grid, fourier_input(1:n_cutoff+1),'color','black','LineWidth', 2)
hold on
plot(n_grid, fourier_fit_1_woc(1:n_cutoff+1),'o', 'Color', 'blue')
plot(n_grid, fourier_fit_2_woc(1:n_cutoff+1),'x', 'Color','red', 'MarkerSize', 8, 'LineWidth',1.2)
plot(n_grid, fourier_fit_3_woc(1:n_cutoff+1),'^', 'Color',[0,0.7,0])
hold off
xlabel('$n$','Interpreter','latex')
ylim([0,5])
yticks([])
title('Full with $\varphi_c = 0$','Interpreter', 'latex')

h(3) = subplot(2,3,3);
plot(n_grid, fourier_input(1:n_cutoff+1),'color','black','LineWidth', 2)
hold on
plot(n_grid, fourier_fit_1_wc(1:n_cutoff+1),'o', 'Color', 'blue')
plot(n_grid, fourier_fit_2_wc(1:n_cutoff+1),'x', 'Color','red', 'MarkerSize', 8, 'LineWidth',1.2)
plot(n_grid, fourier_fit_3_wc(1:n_cutoff+1),'^', 'Color',[0,0.7,0])
hold off
xlabel('$n$','Interpreter','latex')
ylim([0,5])
yticks([])
title('Full with $\varphi_c \neq 0$','Interpreter', 'latex')


h(4) = subplot(2,3,4);
plot(n_grid, fourier_fit_1_trans_dev(1:n_cutoff+1), 'o','Color','blue')
hold on
plot(n_grid, fourier_fit_2_trans_dev(1:n_cutoff+1), 'x','Color', 'red', 'MarkerSize', 8, 'LineWidth',1.2)
plot(n_grid, fourier_fit_3_trans_dev(1:n_cutoff+1), '^','Color', [0,0.7,0])
hold off
xlabel('$n$','Interpreter','latex')
ylabel('$\Delta \varphi_n$','Interpreter','latex')
ylim([-1,1])

h(5) = subplot(2,3,5);
plot(n_grid, fourier_fit_1_woc_dev(1:n_cutoff+1), 'o','Color','blue')
hold on
plot(n_grid, fourier_fit_2_woc_dev(1:n_cutoff+1), 'x','Color', 'red', 'MarkerSize', 8, 'LineWidth',1.2)
plot(n_grid, fourier_fit_3_woc_dev(1:n_cutoff+1), '^','Color', [0,0.7,0])
hold off
xlabel('$n$','Interpreter','latex')
ylim([-1,1])
yticks([])

h(6) = subplot(2,3,6);
plot(n_grid, fourier_fit_1_wc_dev(1:n_cutoff+1), 'o','Color','blue')
hold on
plot(n_grid, fourier_fit_2_wc_dev(1:n_cutoff+1), 'x','Color', 'red', 'MarkerSize', 8, 'LineWidth',1.2)
plot(n_grid, fourier_fit_3_wc_dev(1:n_cutoff+1), '^','Color', [0,0.7,0])
hold off
xlabel('$n$','Interpreter','latex')
ylim([-1,1])
yticks([])

set(h, 'FontName','Times','FontSize',16)
