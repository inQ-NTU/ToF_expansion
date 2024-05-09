clear all
close all

%Adding directories and loading example phase profile containing a variable
%phase_profile_RS
%First (second) row of phase_profile_RS is interpreted to be relative (common) phase
addpath('../../classes')
addpath('../../input')
addpath('../../imaging_effect')
load('thermal_cov_60nk.mat')

%Number of atoms
condensate_length = 100e-6;
t_tof_short = 3.5e-3;
t_tof_long = 15e-3; 
width_fit_flag = 1;

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles();
com_phase = phase_sampling_suite.generate_profiles();
%com_phase = zeros(1, size(cov_phase,1));

%initialize interference pattern class
interference_suite_short= class_interference_pattern([rel_phase; com_phase], t_tof_short);
interference_suite_long= class_interference_pattern([rel_phase; com_phase], t_tof_long);

%initial width
cloud_widths_short = interference_suite_short.compute_density_sigma_t(0, t_tof_short);
cloud_widths_long = interference_suite_long.compute_density_sigma_t(0, t_tof_long);

%full expansion (transversal and longitudinal)
rho_tof_short = interference_suite_short.tof_full_expansion();
rho_tof_long = interference_suite_long.tof_full_expansion();

z_res = size(rho_tof_short, 1);
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

img_rho_tof_short = absorption_imaging(rho_tof_short', grid_dens, cloud_widths_short);
img_rho_tof_long = absorption_imaging(rho_tof_long', grid_dens, cloud_widths_long);

coarse_z_res = size(img_rho_tof_short,1);
condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);


%phase extraction
extraction_suite_short = class_phase_extraction(img_rho_tof_short, t_tof_short, width_fit_flag);
extraction_suite_long = class_phase_extraction(img_rho_tof_long, t_tof_long, width_fit_flag);

extraction_suite_short_no_proc = class_phase_extraction(rho_tof_short, t_tof_short, width_fit_flag);
extraction_suite_long_no_proc = class_phase_extraction(rho_tof_long, t_tof_long, width_fit_flag);

ext_phase_short = extraction_suite_short.fitting(extraction_suite_short.init_phase_guess());
ext_phase_long = extraction_suite_long.fitting(extraction_suite_long.init_phase_guess());

ext_phase_short_no_proc = extraction_suite_short_no_proc.fitting(extraction_suite_short_no_proc.init_phase_guess());
ext_phase_long_no_proc = extraction_suite_long_no_proc.fitting(extraction_suite_long_no_proc.init_phase_guess());


%amplitude extraction
amp_short = extraction_suite_short.normalization_amplitudes;
amp_long = extraction_suite_long.normalization_amplitudes;

amp_short_no_proc = extraction_suite_short_no_proc.normalization_amplitudes;
amp_long_no_proc = extraction_suite_long_no_proc.normalization_amplitudes;

%Contrast extraction
con_short = extraction_suite_short.contrasts;
con_long = extraction_suite_long.contrasts;

con_short_no_proc = extraction_suite_short_no_proc.contrasts;
con_long_no_proc = extraction_suite_long_no_proc.contrasts;

%Width extraction
width_short = extraction_suite_short.gaussian_width;
width_long = extraction_suite_long.gaussian_width;

width_short_no_proc = extraction_suite_short_no_proc.gaussian_width;
width_long_no_proc = extraction_suite_long_no_proc.gaussian_width;

%Plotting
f = tight_subplot(2,3,[.1 .1],[.15 .05],[.1 .1]);

axes(f(1))
imagesc(fine_grid, fine_grid, rho_tof_short')
xticks([])
ylabel('$x\; (\rm \mu m)$', 'Interpreter', 'latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(2))
imagesc(coarse_grid, coarse_grid, img_rho_tof_short')
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(f(3))
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
plot(fine_grid, rel_phase, 'Color','Black')
hold on
plot(fine_grid, com_phase ,'--','Color','Black')
plot(fine_grid,ext_phase_short_no_proc,'Color','Blue')
plot(coarse_grid, ext_phase_short, 'Color','red')
xticks([])

ylabel('$\phi_{\pm}(z)$','Interpreter', 'latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(4))
yyaxis left
plot(fine_grid, amp_short_no_proc,'Color','Blue')
ylabel('$A$','Interpreter','latex')
hold on
yyaxis right
plot(coarse_grid, amp_short, 'Color', 'red')
xticks([-50,0,50])
xticklabels([-50,0,50])
xlabel('$z\; (\mu m)$','Interpreter','latex')
ax = gca;
ax.YAxis(2).Exponent = 2; 
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(f(5))
plot(fine_grid, con_short_no_proc,'Color', 'Blue')
hold on
plot(coarse_grid, con_short, 'Color', 'red')
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
ylabel('$C$','Interpreter','latex')
ylb = ylabel('$C$','Interpreter', 'latex');
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.85])
ylim([0.4,1.1])
%ax = gca;
%ax.YAxis.Exponent = -1;

axes(f(6))
plot(fine_grid(5:end-5), width_short_no_proc(5:end-5), 'Color', 'Blue')
hold on
plot(coarse_grid(5:end-5), width_short(5:end-5),'Color', 'red')
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
ylabel('$\sigma \; (\mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
%yticks([24,25,26])
%ylim([24,26])

colormap(gge_colormap)
set(f,'FontName', 'Times', 'FontSize', 14)

figure
g = tight_subplot(2,3,[.1 .1],[.15 .05],[.1 .1]);

axes(g(1))
imagesc(fine_grid, fine_grid, rho_tof_long')
xticks([])
ylabel('$x\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(g(2))
imagesc(coarse_grid, coarse_grid, img_rho_tof_long')
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(g(3))
plot(fine_grid, rel_phase,'Color','Black')
hold on
plot(fine_grid, com_phase ,'--','Color','Black')
plot(fine_grid, ext_phase_long_no_proc,'Color','Blue')
plot(coarse_grid, ext_phase_long,'Color','red')
xticks([])
ylabel('$\phi_{\pm}(z)$','Interpreter', 'latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(g(4))
yyaxis left
plot(fine_grid, amp_long_no_proc,'Color', 'blue')
ylabel('$A$', 'Interpreter','latex')
hold on
yyaxis right
plot(coarse_grid, amp_long, 'Color','red')
xticks([-50,0,50])
xticklabels([-50,0,50])
xlabel('$z\; (\rm \mu m)$','Interpreter','latex')
ax = gca;
ax.YAxis(2).Exponent = 2; 
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(g(5))
plot(fine_grid, con_long_no_proc,'Color', 'blue')
hold on
plot(coarse_grid, con_long,'Color', 'red')
xlabel('$z\; (\rm \mu m)$', 'Interpreter', 'latex')
ylb = ylabel('$C$','Interpreter', 'latex');
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.85])
ylim([0.4,1.1])
%ax = gca;
%ax.YAxis.Exponent = -1;

axes(g(6))
plot(fine_grid(5:end-5), width_long_no_proc(5:end-5),'Color','blue')
hold on
plot(coarse_grid(5:end-5), width_long(5:end-5),'Color', 'red')
xlabel('$z\; (\rm \mu m)$', 'Interpreter', 'latex')
ylabel('$\sigma\; (\mu m)$', 'Interpreter', 'latex')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
%yticks([24,25,26])
%ylim([24,26])

colormap(gge_colormap)
set(g,'FontName', 'Times', 'FontSize', 14)
