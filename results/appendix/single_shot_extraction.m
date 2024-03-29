%clear all
close all

%Adding directories and loading example phase profile containing a variable
%phase_profile_RS
%First (second) row of phase_profile_RS is interpreted to be relative (common) phase
addpath('../../classes')
addpath('../../input')
addpath('../image processing')
load('thermal_cov_60nk.mat')

%Number of atoms
condensate_length = 100e-6;
t_tof = 15e-3;
width_fit_flag = 1;

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles();
com_phase = phase_sampling_suite.generate_profiles();

%initialize interference pattern class
%woc = without common phase
%wc = with common phase
interference_suite_woc = class_interference_pattern(rel_phase, t_tof);
interference_suite_wc = class_interference_pattern([rel_phase; com_phase], t_tof);

%initial width
cloud_widths = interference_suite_woc.compute_density_sigma_t(0, t_tof);

%full expansion (transversal and longitudinal)
rho_tof_full_woc = interference_suite_woc.tof_full_expansion();

rho_tof_full_wc = interference_suite_wc.tof_full_expansion();

%Making the image square for processing purpose
z_res = size(rho_tof_full_woc, 1);
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

img_rho_tof_woc = absorption_imaging(rho_tof_full_woc, grid_dens, cloud_widths);
img_rho_tof_wc = absorption_imaging(rho_tof_full_wc, grid_dens, cloud_widths);

coarse_z_res = size(img_rho_tof_wc,1);
condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);


%phase extraction
extraction_suite_woc = class_phase_extraction(img_rho_tof_woc', t_tof, width_fit_flag);
extraction_suite_wc = class_phase_extraction(img_rho_tof_wc', t_tof, width_fit_flag);

extraction_suite_woc_no_proc = class_phase_extraction(rho_tof_full_woc, t_tof, width_fit_flag);
extraction_suite_wc_no_proc = class_phase_extraction(rho_tof_full_wc, t_tof, width_fit_flag);

ext_phase_woc = extraction_suite_woc.fitting(extraction_suite_woc.init_phase_guess());
ext_phase_wc = extraction_suite_wc.fitting(extraction_suite_wc.init_phase_guess());

ext_phase_woc_no_proc = extraction_suite_woc_no_proc.fitting(extraction_suite_woc_no_proc.init_phase_guess());
ext_phase_wc_no_proc = extraction_suite_wc_no_proc.fitting(extraction_suite_wc_no_proc.init_phase_guess());


%amplitude extraction
amp_woc = extraction_suite_woc.normalization_amplitudes;
amp_wc = extraction_suite_wc.normalization_amplitudes;

amp_woc_no_proc = extraction_suite_woc_no_proc.normalization_amplitudes;
amp_wc_no_proc = extraction_suite_wc_no_proc.normalization_amplitudes;

%Contrast extraction
con_woc = extraction_suite_woc.contrasts;
con_wc = extraction_suite_wc.contrasts;

con_woc_no_proc = extraction_suite_woc_no_proc.contrasts;
con_wc_no_proc = extraction_suite_wc_no_proc.contrasts;

%Width extraction
width_woc = extraction_suite_woc.gaussian_width;
width_wc = extraction_suite_wc.gaussian_width;

width_woc_no_proc = extraction_suite_woc_no_proc.gaussian_width;
width_wc_no_proc = extraction_suite_wc_no_proc.gaussian_width;

%Plotting
f = tight_subplot(2,3,[.1 .1],[.15 .05],[.1 .1]);

axes(f(1))
imagesc(fine_grid, fine_grid, rho_tof_full_woc')
xticks([])
ylabel('$x\; (\rm \mu m)$', 'Interpreter', 'latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(2))
imagesc(coarse_grid, coarse_grid, img_rho_tof_woc)
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(f(3))
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
plot(fine_grid, rel_phase, 'Color','Black')
hold on
plot(fine_grid,ext_phase_woc_no_proc,'Color','Blue')
plot(coarse_grid, ext_phase_woc, 'Color','red')
xticks([])
yline(0, '--','Color','Black')
ylabel('$\phi_{\pm}(z)$','Interpreter', 'latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(4))
yyaxis left
plot(fine_grid, amp_woc_no_proc,'Color','Blue')
ylabel('$A$','Interpreter','latex')
hold on
yyaxis right
plot(coarse_grid, amp_woc, 'Color', 'red')
xticks([-50,0,50])
xticklabels([-50,0,50])
xlabel('$z\; (\mu m)$','Interpreter','latex')
ax = gca;
ax.YAxis(2).Exponent = 2; 
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(f(5))
plot(fine_grid, con_woc_no_proc,'Color', 'Blue')
hold on
plot(coarse_grid, con_woc, 'Color', 'red')
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
ylabel('$C$','Interpreter','latex')
ylb = ylabel('$C$','Interpreter', 'latex');
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.85])
ylim([0.4,1.1])
ax = gca;
ax.YAxis.Exponent = -1;

axes(f(6))
plot(fine_grid(5:end-5), width_woc_no_proc(5:end-5), 'Color', 'Blue')
hold on
plot(coarse_grid(5:end-5), width_woc(5:end-5),'Color', 'red')
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
imagesc(fine_grid, fine_grid, rho_tof_full_wc')
xticks([])
ylabel('$x\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(g(2))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc)
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(g(3))
plot(fine_grid, rel_phase,'Color','Black')
hold on
plot(fine_grid, com_phase ,'--','Color','Black')
plot(fine_grid, ext_phase_wc_no_proc,'Color','Blue')
plot(coarse_grid, ext_phase_wc,'Color','red')
xticks([])
ylabel('$\phi_{\pm}(z)$','Interpreter', 'latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(g(4))
yyaxis left
plot(fine_grid, amp_wc_no_proc,'Color', 'blue')
ylabel('$A$', 'Interpreter','latex')
hold on
yyaxis right
plot(coarse_grid, amp_wc, 'Color','red')
xticks([-50,0,50])
xticklabels([-50,0,50])
xlabel('$z\; (\rm \mu m)$','Interpreter','latex')
ax = gca;
ax.YAxis(2).Exponent = 2; 
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(g(5))
plot(fine_grid, con_wc_no_proc,'Color', 'blue')
hold on
plot(coarse_grid, con_wc,'Color', 'red')
xlabel('$z\; (\rm \mu m)$', 'Interpreter', 'latex')
ylb = ylabel('$C$','Interpreter', 'latex');
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.85])
ylim([0.4,1.1])
ax = gca;
ax.YAxis.Exponent = -1;
axes(g(6))
plot(fine_grid(5:end-5), width_wc_no_proc(5:end-5),'Color','blue')
hold on
plot(coarse_grid(5:end-5), width_wc(5:end-5),'Color', 'red')
xlabel('$z\; (\rm \mu m)$', 'Interpreter', 'latex')
ylabel('$\sigma\; (\mu m)$', 'Interpreter', 'latex')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
%yticks([24,25,26])
%ylim([24,26])

colormap(gge_colormap)
set(g,'FontName', 'Times', 'FontSize', 14)
