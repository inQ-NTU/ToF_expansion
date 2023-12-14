 close all
clear all
%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);

%generate sample and coarse-graining it
coarse_dim = 80;
t_tof_1 =7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3;

phase_profiles = phase_sampling_suite.generate_profiles(2);
reference_profiles = phase_sampling_suite.reference_profiles(phase_profiles);
coarse_phase_profiles = phase_sampling_suite.coarse_grain(coarse_dim, reference_profiles);
%initializing interference suite
interference_suite1_wc = class_interference_pattern(coarse_phase_profiles, t_tof_1);
interference_suite1_woc = class_interference_pattern(coarse_phase_profiles(1,:), t_tof_1);
interference_suite2_wc = class_interference_pattern(coarse_phase_profiles, t_tof_2);
interference_suite2_woc = class_interference_pattern(coarse_phase_profiles(1,:), t_tof_2);
interference_suite3_wc = class_interference_pattern(coarse_phase_profiles, t_tof_3);
interference_suite3_woc = class_interference_pattern(coarse_phase_profiles(1,:), t_tof_3);

%generate rho tof
rho_tof_1_wc = interference_suite1_wc.tof_full_expansion();
rho_tof_1_woc = interference_suite1_woc.tof_full_expansion();
rho_tof_1_trans = interference_suite1_woc.tof_transversal_expansion();
rho_tof_2_wc = interference_suite2_wc.tof_full_expansion();
rho_tof_2_woc = interference_suite2_woc.tof_full_expansion();
rho_tof_2_trans = interference_suite2_woc.tof_transversal_expansion();
rho_tof_3_wc = interference_suite3_wc.tof_full_expansion();
rho_tof_3_woc = interference_suite3_woc.tof_full_expansion();
rho_tof_3_trans = interference_suite3_woc.tof_transversal_expansion();

%initialize phase extraction class
phase_extraction_suite1_wc = class_phase_extraction(rho_tof_1_wc, t_tof_1);
phase_extraction_suite1_woc = class_phase_extraction(rho_tof_1_woc, t_tof_1);
phase_extraction_suite1_trans = class_phase_extraction(rho_tof_1_trans, t_tof_1);
phase_extraction_suite2_wc = class_phase_extraction(rho_tof_2_wc, t_tof_2);
phase_extraction_suite2_woc = class_phase_extraction(rho_tof_2_woc, t_tof_2);
phase_extraction_suite2_trans = class_phase_extraction(rho_tof_2_trans, t_tof_2);
phase_extraction_suite3_wc = class_phase_extraction(rho_tof_3_wc, t_tof_3);
phase_extraction_suite3_woc = class_phase_extraction(rho_tof_3_woc, t_tof_3);
phase_extraction_suite3_trans = class_phase_extraction(rho_tof_3_trans, t_tof_3);

%perform fitting
fitted_phase_1_wc = phase_extraction_suite1_wc.fitting(phase_extraction_suite1_wc.init_phase_guess());
fitted_phase_1_woc = phase_extraction_suite1_woc.fitting(phase_extraction_suite1_woc.init_phase_guess());
fitted_phase_1_trans = phase_extraction_suite1_trans.fitting(phase_extraction_suite1_trans.init_phase_guess());

fitted_phase_2_wc = phase_extraction_suite2_wc.fitting(phase_extraction_suite2_wc.init_phase_guess());
fitted_phase_2_woc = phase_extraction_suite2_woc.fitting(phase_extraction_suite2_woc.init_phase_guess());
fitted_phase_2_trans = phase_extraction_suite2_trans.fitting(phase_extraction_suite2_trans.init_phase_guess());

fitted_phase_3_wc = phase_extraction_suite3_wc.fitting(phase_extraction_suite3_wc.init_phase_guess());
fitted_phase_3_woc = phase_extraction_suite3_woc.fitting(phase_extraction_suite3_woc.init_phase_guess());
fitted_phase_3_trans = phase_extraction_suite3_trans.fitting(phase_extraction_suite3_trans.init_phase_guess());

%compute fourier transform
%Input
fourier_input = abs(fft(coarse_phase_profiles(1,:))/sqrt(coarse_dim));
fourier_input = fourier_input(1:coarse_dim/2+1);% Single sampling plot

%Short tof
fourier_fit_1_wc = abs(fft(fitted_phase_1_wc)/sqrt(coarse_dim));
fourier_fit_1_wc = fourier_fit_1_wc(1:coarse_dim/2+1);
fourier_fit_1_wc_dev = fourier_fit_1_wc - fourier_input;


fourier_fit_1_woc = abs(fft(fitted_phase_1_woc)/sqrt(coarse_dim));
fourier_fit_1_woc = fourier_fit_1_woc(1:coarse_dim/2+1);
fourier_fit_1_woc_dev = fourier_fit_1_woc - fourier_input;

fourier_fit_1_trans = abs(fft(fitted_phase_1_trans)/sqrt(coarse_dim));
fourier_fit_1_trans = fourier_fit_1_trans(1:coarse_dim/2+1);
fourier_fit_1_trans_dev = fourier_fit_1_trans - fourier_input;


%Medium tof
fourier_fit_2_wc = abs(fft(fitted_phase_2_wc)/sqrt(coarse_dim));
fourier_fit_2_wc = fourier_fit_2_wc(1:coarse_dim/2+1);
fourier_fit_2_wc_dev = fourier_fit_2_wc - fourier_input;

fourier_fit_2_woc = abs(fft(fitted_phase_2_woc)/sqrt(coarse_dim));
fourier_fit_2_woc = fourier_fit_2_woc(1:coarse_dim/2+1);
fourier_fit_2_woc_dev = fourier_fit_2_woc - fourier_input;

fourier_fit_2_trans = abs(fft(fitted_phase_2_trans)/sqrt(coarse_dim));
fourier_fit_2_trans = fourier_fit_2_trans(1:coarse_dim/2+1);
fourier_fit_2_trans_dev = fourier_fit_2_trans - fourier_input;


%Long tof
fourier_fit_3_wc = abs(fft(fitted_phase_3_wc)/sqrt(coarse_dim));
fourier_fit_3_wc = fourier_fit_3_wc(1:coarse_dim/2+1);
fourier_fit_3_wc_dev = fourier_fit_3_wc - fourier_input; 


fourier_fit_3_woc = abs(fft(fitted_phase_3_woc)/sqrt(coarse_dim));
fourier_fit_3_woc = fourier_fit_3_woc(1:coarse_dim/2+1);
fourier_fit_3_woc_dev = fourier_fit_3_woc - fourier_input; 

fourier_fit_3_trans = abs(fft(fitted_phase_3_trans)/sqrt(coarse_dim));
fourier_fit_3_trans = fourier_fit_3_trans(1:coarse_dim/2+1);
fourier_fit_3_trans_dev = fourier_fit_3_trans - fourier_input;

%Plotting
%1. Plot the resulting interference pattern
x_grid = linspace(-48,48, size(rho_tof_1_trans,2));
z_grid = linspace(-40, 40, size(rho_tof_1_trans, 1));

f(1) = subplot(3,3,1);
imagesc(x_grid, z_grid, rho_tof_1_trans)
%clim([0 5e17])
xticks([])
title('Transversal','Interpreter','latex')
ylabel('$z \; (\mu m)$','Interpreter','latex')

f(2) = subplot(3,3,2);
imagesc(x_grid, z_grid, rho_tof_1_woc)
%clim([0 5e17])
xticks([])
yticks([])
title('Full with $\varphi_c = 0$', 'Interpreter', 'latex')

f(3) = subplot(3,3,3);
imagesc(x_grid, z_grid, rho_tof_1_wc)
%clim([0 5e17])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
xticks([])
yticks([])
title('Full with $\varphi_c \neq 0$','Interpreter','latex')

f(4) = subplot(3,3,4); 
imagesc(x_grid, z_grid, rho_tof_2_trans)
%clim([0 12e16])
xticks([])
ylabel('$z \;(\mu m)$', 'Interpreter','latex')

f(5) = subplot(3,3,5); 
imagesc(x_grid, z_grid, rho_tof_2_woc)
%clim([0 12e16])
xticks([])
yticks([])

f(6) = subplot(3,3,6);
imagesc(x_grid, z_grid, rho_tof_2_wc)
%clim([0 12e16])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
xticks([])
yticks([])

f(7) = subplot(3,3,7);
imagesc(x_grid, z_grid, rho_tof_3_trans)
%clim([0 3e16])
ylabel('$z \;(\mu m)$', 'Interpreter','latex')
xlabel('$x\; (\mu m)$','Interpreter', 'latex')

f(8) = subplot(3,3,8);
imagesc(x_grid, z_grid, rho_tof_3_woc)
%clim([0 3e16])
yticks([])

f(9) = subplot(3,3,9);
imagesc(x_grid, z_grid, rho_tof_3_wc)
%clim([0 3e16])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
yticks([])
colormap(gge_colormap)

set(f, 'FontName','Times','FontSize',16)

%2. PLOT PHASE RECONSTRUCTION IN REAL SPACE
figure
g(1) = subplot(1,3,1);
plot(z_grid(2:coarse_dim-1), coarse_phase_profiles(1,2:coarse_dim-1),'LineWidth', 1.2,'Color','black')
hold on
plot(z_grid(2:coarse_dim-1), fitted_phase_1_trans(2:coarse_dim-1), 'o-','Color','blue')
plot(z_grid(2:coarse_dim-1), fitted_phase_2_trans(2:coarse_dim-1), 'x-','MarkerSize',8,'Linewidth',1.5,'Color','red')
plot(z_grid(2:coarse_dim-1), fitted_phase_3_trans(2:coarse_dim-1), '^-','Color',[0,0.7,0])
hold off
%legend({'Input', '$t_{ToF} = 7\; ms$','$t_{ToF} = 15\; ms$', '$t_{ToF} = 30\; ms$'},'Interpreter','latex','FontSize', 12)
ylim([-pi,pi])
yticks([-pi, -pi/2, 0, pi/2, pi])
yticklabels({'$-\pi$', '$-\pi/2$', '$0$', '$\pi/2$', '$\pi$'})
ya = get(gca, 'YAxis');
ya.TickLabelInterpreter = 'latex';
ylabel('$\varphi_z$','Interpreter','latex')
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
title('Transversal','Interpreter','latex')

g(2) = subplot(1,3,2);
plot(z_grid, coarse_phase_profiles(1,:),'Linewidth',1.2,'Color','black')
hold on
plot(z_grid, zeros(1,coarse_dim), 'Color','black', 'LineStyle','--')
plot(z_grid, fitted_phase_1_woc, 'o-','Color','blue')
plot(z_grid, fitted_phase_2_woc, 'x-','MarkerSize',8,'LineWidth', 1.2,'Color','red')
plot(z_grid, fitted_phase_3_woc, '^-','Color', [0,0.7,0])
hold off
%legend({'Input $\varphi_r(z)$', 'Input $\varphi_c(z)$', '$t_{ToF} = 7\; ms$','$t_{ToF} = 15\; ms$', '$t_{ToF} = 30\; ms$'},'Interpreter','latex','FontSize', 12)
ylim([-pi,pi])
yticks([-pi, -pi/2, 0, pi/2, pi])
yticklabels([])
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
title('Full with $\varphi_c = 0$','Interpreter', 'latex')


g(3) = subplot(1,3,3);
plot(z_grid, coarse_phase_profiles(1,:), 'LineWidth', 1.2,'Color','black')
hold on
plot(z_grid, coarse_phase_profiles(2,:),'Color','black','LineStyle','--')
plot(z_grid, fitted_phase_1_wc, 'o-','Color','blue')
plot(z_grid, fitted_phase_2_wc,'x-','MarkerSize',8,'LineWidth',1.2,'Color','red')
plot(z_grid, fitted_phase_3_wc, '^-','Color', [0,0.7,0])
hold off
%legend({'Input $\varphi_r(z)$', 'Input $\varphi_c(z)$', '$t_{ToF} = 7\; ms$','$t_{ToF} = 15\; ms$', '$t_{ToF} = 30\; ms$'},'Interpreter','latex','FontSize',12)
ylim([-pi,pi])
yticks([-pi, -pi/2, 0, pi/2, pi])
yticklabels([])
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
title('Full with $\varphi_c \neq 0$','Interpreter', 'latex')

set(g, 'FontName','Times','FontSize',16)

%3. PLOT RECONSTRUCTION IN FOURIER SPACE
n_cutoff = 30;
n_grid = linspace(0,n_cutoff, n_cutoff+1);

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
