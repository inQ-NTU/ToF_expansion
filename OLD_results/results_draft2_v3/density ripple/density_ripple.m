clear all
close all
addpath('../../input')
addpath('../../classes')

load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
N_atoms = 10^4;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
transversal_resolution = (transversal_length/condensate_length)*longitudinal_resolution;
x_grid = linspace(-transversal_length/2,transversal_length/2, transversal_resolution);
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution);

rel_phase = sampling_suite.generate_profiles();
rel_phase = sampling_suite.convolution_1d(rel_phase, 0.01);
com_phase = sampling_suite.generate_profiles();
com_phase = sampling_suite.convolution_1d(com_phase, 0.01);
%load('example_phase.mat')
interference_suite_woc = class_interference_pattern(rel_phase);
interference_suite_wc = class_interference_pattern([rel_phase; com_phase]);

rho_tof_2d = interference_suite_woc.tof_transversal_expansion();
rho_tof_2d = interference_suite_woc.normalize(rho_tof_2d, N_atoms);

rho_tof_3d_woc = interference_suite_woc.tof_full_expansion();
rho_tof_3d_woc = interference_suite_wc.normalize(rho_tof_3d_woc, N_atoms);

rho_tof_3d_wc = interference_suite_wc.tof_full_expansion();
rho_tof_3d_wc = interference_suite_wc.normalize(rho_tof_3d_wc, N_atoms);

%Computing density ripple
density_ripple_2d = trapz(x_grid, rho_tof_2d, 2);
density_ripple_3d_woc = trapz(x_grid, rho_tof_3d_woc, 2);
density_ripple_3d_wc = trapz(x_grid, rho_tof_3d_wc, 2);

%Plotting
x_grid = x_grid.*1e6;
z_grid = z_grid.*1e6;
fontsize = 16;

%First figure
figure
f = tight_subplot(2,3,[.05 .05],[.15 .05],[.1 .1]);

axes(f(1))
imagesc(z_grid, x_grid, (rho_tof_2d.*1e-12)');
clim([0,8])
xticks([])
ylabel('$x\; (\rm \mu m)$', 'Interpreter','latex')
title('\textbf{a}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(2))
imagesc(z_grid, x_grid, (rho_tof_3d_woc.*1e-12)');
clim([0,8])
xticks([])
yticks([])
title('\textbf{b}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(3))
imagesc(z_grid, x_grid, (rho_tof_3d_wc.*1e-12)')
clim([0,8])
xticks([])
yticks([])
cb = colorbar('Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0,0,0];
set(get(cb,'YLabel'),'Interpreter','latex')
set(get(cb,'YLabel'),'String','$\rho_{\rm TOF}\; (\rm \mu m^{-2})$')
set(get(cb,'YLabel'),'FontSize',fontsize)
title('\textbf{c}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
colormap(gge_colormap)

axes(f(4))
plot(z_grid, density_ripple_2d.*1e-6,'Color','black')
ylim([0,250])
xlabel('$z\; (\rm \mu m)$', 'Interpreter','latex')
ylabel('$n_{\rm TOF}\; (\rm \mu m^{-1})$','Interpreter','latex')
title('\textbf{d}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(5))
plot(z_grid, density_ripple_3d_woc.*1e-6,'Color','black')
ylim([0,250])
yticks([])
xlabel('$z\; (\rm \mu m)$', 'Interpreter','latex','Color','black')
title('\textbf{e}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(6))
plot(z_grid, density_ripple_3d_wc.*1e-6,'Color','black')
ylim([0,250])
yticks([])
xlabel('$z\; (\rm \mu m)$', 'Interpreter','latex')
title('\textbf{f}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);


set(f, 'FontName', 'Times', 'FontSize', fontsize)
%save('example_phase.mat','rel_phase','com_phase')