clear all
close all
addpath('../input')
addpath('../classes')

load('thermal_cov_75nk.mat')

condensate_length = 100e-6;
transversal_length = 120e-6; 
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
transversal_resolution = (transversal_length/condensate_length)*longitudinal_resolution;
x_grid = linspace(-transversal_length/2,transversal_length/2, transversal_resolution);
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution);

rel_phase = sampling_suite.generate_profiles();
com_phase = sampling_suite.generate_profiles();

interference_suite_woc = class_interference_pattern(rel_phase);
interference_suite_wc = class_interference_pattern([rel_phase; com_phase]);

rho_tof_2d = interference_suite_woc.tof_transversal_expansion();
rho_tof_3d_woc = interference_suite_woc.tof_full_expansion();
rho_tof_3d_wc = interference_suite_wc.tof_full_expansion();

%Normalizing to a total of 10,000 atoms
rho_tof_2d = rho_tof_2d.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_2d,2)));
rho_tof_3d_woc = rho_tof_3d_woc.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_woc, 2)));
rho_tof_3d_wc = rho_tof_3d_wc.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_wc,2)));

%Plotting
x_grid = x_grid.*1e6;
z_grid = z_grid.*1e6;

f(1) = subplot(1,3,1);
imagesc(z_grid, x_grid, (rho_tof_2d.*1e-12)')
clim([0,8])
ylabel('$x\; (\rm \mu m)$', 'Interpreter','latex')
title('a','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
xlabel('$z\; (\rm \mu m)$', 'Interpreter','latex')
f(2) = subplot(1,3,2);
imagesc(z_grid, x_grid, (rho_tof_3d_woc.*1e-12)')
clim([0,8])
yticks([])
%title('b','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xlabel('$z\; (\rm \mu m)$', 'Interpreter','latex')
f(3) = subplot(1,3,3);
subplot(1,3,3)
imagesc(z_grid, x_grid, (rho_tof_3d_wc.*1e-12)')
clim([0,8])
yticks([])
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.09,0,0,0];
set(get(cb,'YLabel'),'Interpreter','latex')
set(get(cb,'YLabel'),'String','$\rho_{\rm ToF}\; (\rm \mu m^{-2})$')
set(get(cb,'YLabel'),'FontSize',12)
xlabel('$z\; (\rm \mu m)$', 'Interpreter','latex')

%title('c','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 12)