clear all
close all

addpath('../classes')
addpath('../input')
%addpath('Data/')
load('thermal_cov_50nk.mat')
%Defining some parameters
coarse_dim =50;
condensate_length = 100;
convolution_scale = 0.008;
z=linspace(0,condensate_length,coarse_dim);

relative_phase = pi*cos(3*pi*z/condensate_length);
common_phase = pi*cos(pi*z/condensate_length);

%FULL TOF
interference_suite_zero_phase = class_interference_pattern(zeros(1,coarse_dim));
interference_suite_no_common = class_interference_pattern(relative_phase);
interference_suite_all_phase = class_interference_pattern([relative_phase; common_phase]);

%Generate interference pattern
full_tof_zero_phase = interference_suite_zero_phase.tof_full_expansion();
full_tof_no_common = interference_suite_no_common.tof_full_expansion();
full_tof_all_phase = interference_suite_all_phase.tof_full_expansion();

%Convolution
full_tof_zero_phase_convolved = interference_suite_zero_phase.convolution2d(full_tof_zero_phase, convolution_scale);
full_tof_no_common_convolved = interference_suite_no_common.convolution2d(full_tof_no_common, convolution_scale);
full_tof_all_phase_convolved = interference_suite_all_phase.convolution2d(full_tof_all_phase, convolution_scale);

trans_tof_zero_phase = interference_suite_zero_phase.tof_transversal_expansion();
trans_tof_no_common = interference_suite_no_common.tof_transversal_expansion();
trans_tof_all_phase = interference_suite_all_phase.tof_transversal_expansion();

%calculating residue
residue_zero_phase = full_tof_zero_phase - trans_tof_zero_phase;
residue_no_common = full_tof_no_common - trans_tof_no_common;
residue_all_phase = full_tof_all_phase - trans_tof_all_phase;

residue_zero_phase_convolved = full_tof_zero_phase_convolved - trans_tof_zero_phase;
residue_no_common_convolved = full_tof_no_common_convolved - trans_tof_no_common;
residue_all_phase_convolved = full_tof_all_phase_convolved - trans_tof_all_phase;


max_res_zero_phase = max(residue_zero_phase, [],'all');
max_res_no_common = max(residue_no_common, [],'all');
max_res_all_phase = max(residue_all_phase, [],'all');

min_res_zero_phase = min(residue_zero_phase, [],'all');
min_res_no_common = min(residue_no_common, [],'all');
min_res_all_phase = min(residue_all_phase, [],'all');

%Drawing the plots
z_grid = linspace(0,condensate_length,size(residue_all_phase,1));
x_grid = linspace(-60,60, size(residue_all_phase,2));
cmin = min([min_res_all_phase, min_res_no_common, min_res_zero_phase],[],'all');
cmax = max([max_res_all_phase, max_res_no_common, max_res_zero_phase],[],'all');

p = figure;
f(1) = subplot(2,3,1);
imagesc(x_grid, z_grid, residue_zero_phase)
clim([cmin, cmax])
ylabel('$z\; (\mu m )$','FontSize',16, 'Interpreter','latex','FontName','Times')
xlabel('$x\; (\mu m)$','FontSize',16,'Interpreter','latex','FontName','Times')
title('$\varphi_r = \varphi_c = 0$', 'FontSize', 18, 'Interpreter','latex','FontName','Times')
yticks([0,50,100])
yticklabels([0,50,100])

f(2) = subplot(2,3,2);
imagesc(x_grid, z_grid, residue_no_common)
clim([cmin, cmax])
xlabel('$x\; (\mu m)$','FontSize',16,'Interpreter','latex','FontName','Times')
title('$\varphi_r = \pi\cos(\frac{3\pi z}{L}), \; \varphi_c = 0$', 'FontSize', 18, 'Interpreter','latex','FontName','Times')
yticks([])

f(3) = subplot(2,3,3);
imagesc(x_grid, z_grid, residue_all_phase)
clim([cmin, cmax])
colormap(gge_colormap)
xlabel('$x\; (\mu m)$','FontSize',16,'Interpreter','latex','FontName','Times')
title({'$\varphi_r =  \pi\cos(\frac{3\pi z}{L})$', '$\varphi_c = \pi \cos(\frac{\pi z}{L})$'}, 'FontSize', 18, 'Interpreter','latex','FontName','Times')
yticks([])

cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0,0,0];
set(get(cb,'Label'),'Interpreter','latex')
set(get(cb,'Label'),'String','$\rho_{ToF}^{(full)} - \rho_{ToF}^{(trans)}$')
set(get(cb,'Label'),'FontSize',18)

f(4) = subplot(2,3,4);
imagesc(x_grid, z_grid, residue_zero_phase_convolved)
%clim([cmin, cmax])
ylabel('$z\; (\mu m )$','FontSize',16, 'Interpreter','latex','FontName','Times')
xlabel('$x\; (\mu m)$','FontSize',16,'Interpreter','latex','FontName','Times')
title('$\varphi_r = \varphi_c = 0$', 'FontSize', 18, 'Interpreter','latex','FontName','Times')
yticks([0,50,100])
yticklabels([0,50,100])

f(5) = subplot(2,3,5);
imagesc(x_grid, z_grid, residue_no_common_convolved)
%clim([cmin, cmax])
xlabel('$x\; (\mu m)$','FontSize',16,'Interpreter','latex','FontName','Times')
title('$\varphi_r = \pi\cos(\frac{3\pi z}{L}), \; \varphi_c = 0$', 'FontSize', 18, 'Interpreter','latex','FontName','Times')
yticks([])

f(6) = subplot(2,3,6);
imagesc(x_grid, z_grid, residue_all_phase_convolved)
%clim([cmin, cmax])
colormap(gge_colormap)
xlabel('$x\; (\mu m)$','FontSize',16,'Interpreter','latex','FontName','Times')
title({'$\varphi_r =  \pi\cos(\frac{3\pi z}{L})$', '$\varphi_c = \pi \cos(\frac{\pi z}{L})$'}, 'FontSize', 18, 'Interpreter','latex','FontName','Times')
yticks([])

cb = colorbar(f(6),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0,0,0];
set(get(cb,'Label'),'Interpreter','latex')
set(get(cb,'Label'),'String','$\rho_{ToF}^{(full)} - \rho_{ToF}^{(trans)}$')
set(get(cb,'Label'),'FontSize',18)

set(f, 'FontName','Times','FontSize',18)