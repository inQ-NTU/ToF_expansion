addpath('../classes')
addpath('../input')
%addpath('Data/')
load('thermal_cov_50nk.mat')
%Defining some parameters
coarse_dim =50;
condensate_length = 100;
x_min = -60;
x_max = 60;

%sampling relative and common phase 
%initiate gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
phase_samples_fine = phase_sampling_suite.generate_profiles(2);
%coarse graining
phase_samples = phase_sampling_suite.coarse_grain(phase_samples_fine, coarse_dim);

%generate interference pattern
interference_suite1 = class_interference_pattern(phase_samples);
interference_suite2 = class_interference_pattern(phase_samples(1,:));

rho_tof1 = interference_suite1.tof_full_expansion();
rho_tof2 = interference_suite2.tof_full_expansion();

%start extraction proces
extraction_suite1 = class_phase_extraction(rho_tof1);
extraction_suite2 = class_phase_extraction(rho_tof2);

phase1 = extraction_suite1.fitting(extraction_suite1.init_phase_guess());
phase2 = extraction_suite2.fitting(extraction_suite2.init_phase_guess());

amp1 = extraction_suite1.normalization_amplitudes();
amp2 = extraction_suite2.normalization_amplitudes();


%Drawing the plot
z_grid_fine = linspace(0,condensate_length, size(phase_samples_fine,2));
z_grid = linspace(0,condensate_length, coarse_dim);
x_grid = linspace(x_min, x_max, size(rho_tof1, 2));
cmin = min(min(rho_tof1, [],'all'), min(rho_tof2,[],'all'));
cmax = max(max(rho_tof2, [], 'all'), max(rho_tof2, [],'all'));
fontsize = 16;
fontname = 'Times';

fig = figure;
f(1) = subplot(2,2,1);
imagesc(x_grid, z_grid, rho_tof1)
xlabel('$x\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname, 'Interpreter','latex')
ylabel('$z\; (\mu m)$','FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
title('$\varphi_c \neq 0$','Interpreter','latex','FontSize',fontsize+2)
clim([cmin, cmax])

f(2) = subplot(2,2,2);
imagesc(x_grid, z_grid, rho_tof2)
clim([cmin,cmax])
cb = colorbar(f(2),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0,0,0];
set(get(cb,'Label'),'Interpreter','latex')
%set(get(cb,'Label'),'String','$\rho_{ToF}^{(full)}$')
set(get(cb,'Label'),'FontSize',fontsize+2)
xlabel('$x\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
title('$\varphi_c = 0 $','Interpreter','latex','FontSize',fontsize+2)
yticks([])
colormap(gge_colormap)

f(3) = subplot(2,2,3);
plot(z_grid, amp1,'--ro')
hold on
plot(z_grid, amp2,'--bx')
hold off
ylabel('$A(z)$','Interpreter','latex', 'FontName',fontname, 'FontSize',fontsize)
xlabel('$z\; (\mu m)$','FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')

f(4) = subplot(2,2,4);
plot(z_grid_fine, phase_samples_fine(1,:),'black')
hold on
plot(z_grid, phase1, 'ro')
plot(z_grid, phase2, 'bx')
plot(z_grid_fine, phase_samples_fine(2,:), '--black')
ylim([-pi pi])
yticks([-pi 0 pi])
yticklabels({'-\pi','0','\pi'})
xlabel('$z\; (\mu m)$','FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
ylabel('$\varphi(z)$','FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
set(f, 'FontName',fontname,'FontSize',fontsize)