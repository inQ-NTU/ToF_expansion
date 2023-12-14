clear all
load('fourier_corr_data.mat')

f(1) = subplot(1,3,1);
plot(diag_cov_input, 'Color', 'black', 'LineWidth', 1.2)
hold on
plot(diag_cov1_trans, 'o','Color', 'blue')
plot(diag_cov2_trans, 'x', 'MarkerSize', 8, 'Color', 'red', 'LineWidth', 1.2)
plot(diag_cov3_trans, '^', 'Color', [0,0.7,0])
title('Transverse','Interpreter', 'latex')
ylabel('$<\varphi_n^2>$', 'Interpreter', 'latex')
xlabel('$n$','Interpreter', 'latex')
legend({'Input', '$t_{ToF} = 7 \; ms$', '$t_{ToF} = 15 \; ms$', '$t_{ToF} = 30 \;  ms$'}, 'Interpreter', 'latex', 'FontSize', 12)


f(2) = subplot(1,3,2);
plot(diag_cov_input, 'Color', 'black', 'LineWidth', 1.2)
hold on
plot(diag_cov1_woc, 'o','Color', 'blue')
plot(diag_cov2_woc, 'x', 'MarkerSize', 8, 'Color', 'red', 'LineWidth', 1.2)
plot(diag_cov3_woc, '^', 'Color', [0,0.7,0])
title('Full $\varphi_c = 0$', 'Interpreter','latex')
yticks([])
xlabel('$n$','Interpreter', 'latex')
legend({'Input', '$t_{ToF} = 7 \; ms$', '$t_{ToF} = 15 \; ms$', '$t_{ToF} = 30 \;  ms$'},'Interpreter', 'latex', 'FontSize', 12)

f(3) = subplot(1,3,3);
plot(diag_cov_input, 'Color', 'black', 'LineWidth', 1.2)
hold on
plot(diag_cov1_wc,'o', 'Color', 'blue')
plot(diag_cov2_wc, 'x', 'MarkerSize', 8, 'Color', 'red', 'LineWidth', 1.2)
plot(diag_cov3_wc, '^', 'Color', [0,0.7,0])
title('Full $\varphi_c \neq 0$','Interpreter', 'latex')
yticks([])
xlabel('$n$','Interpreter', 'latex')
legend({'Input', '$t_{ToF} = 7 \; ms$', '$t_{ToF} = 15 \; ms$', '$t_{ToF} = 30 \;  ms$'}, 'Interpreter','latex', 'FontSize', 12)

set(f, 'FontName','Times','FontSize',16)