clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 2e-6;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = floor(transversal_length/pixel_width);

z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z).*1e6;

rel_phase = sampling_suite.generate_profiles();
com_phase = sampling_suite.generate_profiles();

cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);

t_tof_1 = 7e-3;
t_tof_2 = 15e-3;

interference_suite_woc_1 = class_interference_pattern(rel_phase, t_tof_1);
interference_suite_woc_2 = class_interference_pattern(rel_phase, t_tof_2);

interference_suite_wc_1 = class_interference_pattern([rel_phase; com_phase], t_tof_1);
interference_suite_wc_2 = class_interference_pattern([rel_phase; com_phase], t_tof_2);

rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
rho_tof_woc_1 = imresize(rho_tof_woc_1, [coarse_resolution_z, coarse_resolution_x]);
rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
rho_tof_woc_2 = imresize(rho_tof_woc_2, [coarse_resolution_z, coarse_resolution_x]);
rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
rho_tof_wc_1 = imresize(rho_tof_wc_1,  [coarse_resolution_z, coarse_resolution_x]);
rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
rho_tof_wc_2 = imresize(rho_tof_wc_2,  [coarse_resolution_z, coarse_resolution_x]);

%phase extraction process
phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);

ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());

ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());

%plotting
f(1) = subplot(2,2,1);
plot(z_grid, rel_phase, 'Color','Black')
hold on
plot(z_grid_coarse, ext_phase_woc_1, 'o','Color','Blue','MarkerSize',3)
plot(z_grid_coarse, ext_phase_woc_2, 'x','Color','red','MarkerSize',4)
plot(z_grid, zeros(1, longitudinal_resolution),'--','Color','Black')
ylim([-pi,pi])
yticks([-pi, -pi/2,0,pi/2,pi])
xticks([])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(2) = subplot(2,2,2);
plot(z_grid_coarse, ext_phase_woc_1 - cg_rel_phase, 'o--', 'Color', 'Blue', 'MarkerSize', 3);
hold on
plot(z_grid_coarse, ext_phase_woc_2 - cg_rel_phase, 'x--','Color', 'Red', 'MarkerSize', 4);
xticks([])
ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
yticks([-pi/2,0,pi/2])
yticklabels({'-\pi/2', '0', '\pi/2'})
ylim([-pi/2,pi/2])
f(3) = subplot(2,2,3);
plot(z_grid, rel_phase, 'Color','black')
hold on
plot(z_grid_coarse, ext_phase_wc_1, 'o','Color','Blue','MarkerSize',3)
plot(z_grid_coarse, ext_phase_wc_2, 'x','Color','red', 'MarkerSize', 4)
plot(z_grid, com_phase, '--', 'Color','Black')
ylim([-pi,pi])
yticks([-pi, -pi/2,0,pi/2,pi])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')

f(4) = subplot(2,2,4);
plot(z_grid_coarse, ext_phase_wc_1 - cg_rel_phase, 'o--', 'Color', 'Blue', 'MarkerSize', 3);
hold on
plot(z_grid_coarse, ext_phase_wc_2 - cg_rel_phase, 'x--','Color', 'Red', 'MarkerSize', 4);
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')
ylim([-pi/2,pi/2])
yticks([-pi/2,0,pi/2])
yticklabels({'-\pi/2', '0', '\pi/2'})
set(f, 'FontName', 'Times', 'FontSize', 10)
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex')