%clear all
close all

%Adding directories and loading example phase profile containing a variable
%phase_profile_RS
%First (second) row of phase_profile_RS is interpreted to be relative (common) phase
addpath('../../classes')
addpath('../../input')
load('thermal_cov_50nk.mat')

%Number of atoms
condensate_length = 100e-6;
t_tof = 15e-3;
width_fit_flag = 1;
intr_broaden_flag = 1;
z_res = size(cov_phase,1); 
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles();
com_phase = phase_sampling_suite.generate_profiles();

%initialize interference pattern class
%wob = without broadening
%wc = with broadening
interference_suite_wob = class_interference_pattern([rel_phase; com_phase], t_tof);
interference_suite_wb = class_interference_pattern([rel_phase; com_phase], t_tof, 'InverseParabola', width_fit_flag);

%full expansion (transversal and longitudinal)
rho_tof_full_wob = interference_suite_wob.tof_full_expansion();

rho_tof_full_wb = interference_suite_wb.tof_full_expansion();

condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);


%phase extraction
extraction_suite_wob = class_phase_extraction(rho_tof_full_wob, t_tof, width_fit_flag);
extraction_suite_wb = class_phase_extraction(rho_tof_full_wb, t_tof, width_fit_flag);

extraction_suite_woc_no_proc = class_phase_extraction(rho_tof_full_wob, t_tof, width_fit_flag);
extraction_suite_wc_no_proc = class_phase_extraction(rho_tof_full_wb, t_tof, width_fit_flag);

ext_phase_wob = extraction_suite_wob.fitting(extraction_suite_wob.init_phase_guess());
ext_phase_wb = extraction_suite_wb.fitting(extraction_suite_wb.init_phase_guess());

%amplitude extraction
amp_wob = extraction_suite_wob.normalization_amplitudes;
amp_wb = extraction_suite_wb.normalization_amplitudes;

%Contrast extraction
con_wob = extraction_suite_wob.contrasts;
con_wb = extraction_suite_wb.contrasts;

%Width extraction
width_wob = extraction_suite_wob.gaussian_width;
width_wb = extraction_suite_wb.gaussian_width;
%Plotting
f = tight_subplot(2,3,[.1 .1],[.15 .05],[.1 .1]);

axes(f(1))
imagesc(fine_grid, fine_grid, rho_tof_full_wob')
xticks([])
ylabel('$x\; (\rm \mu m)$', 'Interpreter', 'latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(2))
imagesc(fine_grid, fine_grid, rho_tof_full_wb')
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(f(3))
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
plot(fine_grid, rel_phase, 'Color','Black')
hold on
plot(fine_grid,ext_phase_wob,'Color','Blue')
plot(fine_grid, ext_phase_wb, 'Color','red')
xticks([])
plot(fine_grid, com_phase, 'Color', 'Black', 'LineStyle','--')
ylabel('$\phi_{\pm}(z)$','Interpreter', 'latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(4))
plot(fine_grid, amp_wob,'Color','Blue')
ylabel('$A$','Interpreter','latex')
hold on
plot(fine_grid, amp_wb, 'Color', 'red')
xticks([-50,0,50])
xticklabels([-50,0,50])
xlabel('$z\; (\mu m)$','Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(f(5))
plot(fine_grid, con_wob,'Color', 'Blue')
hold on
plot(fine_grid, con_wb, 'Color', 'red')
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
ylabel('$C$','Interpreter','latex')
ylabel('$C$','Interpreter', 'latex');
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.85])
ylim([0.4,1.1])

axes(f(6))
plot(fine_grid(3:end-2), width_wob(3:end-2), 'Color', 'Blue')
hold on
plot(fine_grid(3:end-2), width_wb(3:end-2),'Color', 'red')
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
ylabel('$\sigma \; (\mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

colormap(gge_colormap)
set(f,'FontName', 'Times', 'FontSize', 16)