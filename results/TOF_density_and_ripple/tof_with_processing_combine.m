clear all
close all

addpath('../../classes')
addpath('../../input')
load('thermal_cov_75nk.mat')

condensate_length = 100e-6;
grid_dens = linspace(-condensate_length/2, condensate_length/2, 400);

t_tof_1 = 1.5e-3;
t_tof_2 = 3.5e-3; 
t_tof_3 = 7e-3;
t_tof_4 = 15e-3;

load('example_phase.mat')
%phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
%rel_phase = phase_sampling_suite.generate_profiles();
%com_phase = phase_sampling_suite.generate_profiles();

%initialize interference pattern class
%woc = without common phase
%wc = with common phase
interference_suite_wc_1 = class_interference_pattern([rel_phase; com_phase], t_tof_1);
interference_suite_wc_2 = class_interference_pattern([rel_phase; com_phase], t_tof_2);
interference_suite_wc_3 = class_interference_pattern([rel_phase; com_phase], t_tof_3);
interference_suite_wc_4 = class_interference_pattern([rel_phase; com_phase], t_tof_4);

%initial width
cloud_widths_1 = interference_suite_wc_1.compute_density_sigma_t(0, t_tof_1);
cloud_widths_2 = interference_suite_wc_2.compute_density_sigma_t(0, t_tof_2);
cloud_widths_3 = interference_suite_wc_3.compute_density_sigma_t(0, t_tof_3);
cloud_widths_4 = interference_suite_wc_2.compute_density_sigma_t(0, t_tof_4);

rho_tof_full_wc_1 = interference_suite_wc_1.tof_full_expansion();
rho_tof_full_wc_2 = interference_suite_wc_2.tof_full_expansion();
rho_tof_full_wc_3 = interference_suite_wc_3.tof_full_expansion();
rho_tof_full_wc_4 = interference_suite_wc_4.tof_full_expansion();

%Simulate image processing
img_rho_tof_wc_1 = absorption_imaging(rho_tof_full_wc_1', grid_dens, cloud_widths_1);
img_rho_tof_wc_2 = absorption_imaging(rho_tof_full_wc_2', grid_dens, cloud_widths_2);
img_rho_tof_wc_3 = absorption_imaging(rho_tof_full_wc_3' , grid_dens, cloud_widths_3);
img_rho_tof_wc_4 = absorption_imaging(rho_tof_full_wc_4', grid_dens, cloud_widths_4);

fine_grid = grid_dens*1e6;
coarse_z_res = size(img_rho_tof_wc_1,1);
condensate_length = 1e6*condensate_length;
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);

%Plotting
figure
f = tight_subplot(2,4,[.04 .02],[.04 .04],[.04 .04]);
axes(f(1))
imagesc(fine_grid, fine_grid, (rho_tof_full_wc_1')*1e-12)
xticks([])
yticks([])
title('\textbf{a}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(2))
imagesc(fine_grid, fine_grid,(rho_tof_full_wc_2')*1e-12)
xticks([])
yticks([])
title('\textbf{b}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(3))
imagesc(fine_grid, fine_grid, (rho_tof_full_wc_3')*1e-12)
title('\textbf{c}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
yticks([])
xticks([])

axes(f(4))
imagesc(coarse_grid, coarse_grid, (rho_tof_full_wc_4')*1e-12)
yticks([])
xticks([])
title('\textbf{d}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(5))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_1')
xticks([])
yticks([])
title('\textbf{e}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(6))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_2')
xticks([])
yticks([])
title('\textbf{f}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(7))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_3')
title('\textbf{g}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
yticks([])
xticks([])

axes(f(8))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_4')
yticks([])
xticks([])
title('\textbf{h}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

colormap(gge_colormap)
set(f, 'FontName', 'Times','FontSize', 18)