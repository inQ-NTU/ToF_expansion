%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

%generate phase sample and coarse-graining it (with common)
coarse_dim = 50;
phase_profile = phase_sampling_suite.generate_profiles(2);
coarse_phase_profile = phase_sampling_suite.coarse_grain(phase_profile, coarse_dim);

%initialize interference pattern class
interference_suite_coarse = class_interference_pattern(coarse_phase_profile);
interference_suite_fine = class_interference_pattern(phase_profile);

%generate rho tof
rho_tof_fine = interference_suite_fine.tof_full_expansion();
rho_tof_coarse = interference_suite_coarse.tof_full_expansion();
rho_tof_conv = interference_suite_coarse.convolution2d(rho_tof_coarse);
rho_tof_noisy = interference_suite_coarse.add_gaussian_noise(rho_tof_conv, 0.03);

%initializing phase extraction class
phase_extraction_suite = class_phase_extraction(rho_tof_noisy);

%perform phase extraction
init_phase = phase_extraction_suite.init_phase_guess();
final_phase = phase_extraction_suite.fitting(init_phase);

%reconstruction of rho tof
rho_tof_reco = phase_extraction_suite.reconstructed_interference_pattern;


%Plotting the results
%set plotting parameters
gas_length = 100; %microns
fontname = 'Times';
fontsize = 18;
%define grids
fine_grid_z = linspace(0,gas_length, length(cov_phase));
coarse_grid_z = linspace(0,gas_length, coarse_dim);
fine_grid_x = linspace(-60,60, size(rho_tof_fine,2));
coarse_grid_x = linspace(-60,60, size(rho_tof_coarse, 2));

%describe the phase in terms of the multiplication of pi and -pi
phase_profile = phase_profile/pi;
coarse_phase_profile = coarse_phase_profile/pi;
init_phase = init_phase/pi;
final_phase = final_phase/pi;


%normalizing each rho tof
rho_tof_fine = rho_tof_fine/max(rho_tof_fine, [],'all');
rho_tof_coarse = rho_tof_coarse/max(rho_tof_coarse,[],'all');
rho_tof_conv = rho_tof_conv/max(rho_tof_conv,[],'all');
rho_tof_noisy = rho_tof_noisy/max(rho_tof_noisy,[],'all');
rho_tof_reco = rho_tof_reco/max(rho_tof_reco, [],'all');

%Figure 4
figure
f4(1) = subplot(1,2,1);
imagesc(fine_grid_z, fine_grid_z, cov_phase)
colormap(gge_colormap)
cb = colorbar;
ylabel(cb, '$\Gamma_{\phi\phi}(z,z^\prime)$','Interpreter','latex','FontSize',fontsize)
xlabel('$z^\prime (\mu m)$','Interpreter','latex')
ylabel('$z\; (\mu  m)$','Interpreter','latex')
yticks([0,50,100])
xticks([0,50,100])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

f4(2) = subplot(1,2,2);
plot(fine_grid_z, phase_profile(1,:),'black')
hold on
plot(fine_grid_z, phase_profile(2,:), '--black')
hold off
legend({'$\varphi_r$','$\varphi_c$'}, 'Interpreter','latex','FontSize',fontsize)
ylabel('$\varphi_{r,c}(z)$','Interpreter','latex','FontSize',fontsize)
ylim([-1,1])
yticks([-1, 0, 1])
xticks([0,50,100])
yticklabels({'-\pi', '0', '\pi'})
xlabel('$z\; (\mu m)$','Interpreter','latex')
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

set(f4, 'FontName',fontname,'FontSize',fontsize)


%Figure 5
figure
tlo = tiledlayout(2,2);
f5(1) = nexttile(1);
imagesc(fine_grid_x, fine_grid_z, rho_tof_fine)
ylabel('$z\; (\mu m)$','FontSize',fontsize, 'Interpreter','latex')
xticks([])
yticks([0,50,100])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f5(2) = nexttile(2);
imagesc(coarse_grid_x,coarse_grid_z,rho_tof_coarse)
xticks([])
yticks([])
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);


f5(3) = nexttile(3);
imagesc(coarse_grid_x, coarse_grid_z, rho_tof_conv)
xlabel('$x\; (\mu m)$','FontSize',fontsize, 'Interpreter','latex')
ylabel('$z\; (\mu m)$','FontSize',fontsize, 'Interpreter','latex')
xticks([-60,0,60])
yticks([0,50,100])
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f5(4) = nexttile(4);
imagesc(coarse_grid_x, coarse_grid_z, rho_tof_noisy)
xlabel('$x\; (\mu m)$','FontSize',fontsize, 'Interpreter','latex')
xticks([-60,0,60])
yticks([])
title('(d)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

set(f5, 'FontName',fontname,'FontSize',fontsize)
colormap(gge_colormap)
cb = colorbar(f5(end)); 
set(cb, 'YTick', [0,0.5,1])
% To position the colorbar as a global colorbar representing
% all tiles, 
cb.Layout.Tile = 'East'; 
set(get(cb,'label'),'string',sprintf('%s', '$\rho_{ToF}$'),'Interpreter','latex','FontSize',22);
tlo.TileSpacing = 'compact';
tlo.Padding ='compact';


%Figure 6
figure
f6(1) = subplot(2,2,[1,2]);
plot(fine_grid_z, phase_profile(1,:),'black')
hold on
plot(coarse_grid_z, init_phase, 'o')
plot(coarse_grid_z, final_phase, '.-red')
xticks([0,50,100])
xlabel('$z\; (\mu m)$','Interpreter','latex','FontSize',fontsize)
ylabel('$\varphi_r(z)$','Interpreter','latex','FontSize',fontsize)
legend({'$\varphi_r^{(true)}$','$\varphi_r^{(guess)}$', '$\varphi_r^{(fit)}$'},'Interpreter','latex')
legend box off
yticks([-1,0,1])
yticklabels({'-\pi','0','\pi'})
xticks([0,50,100])
ylim([-1,1])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

f6(2) = subplot(2,2,3);
imagesc(coarse_grid_x, coarse_grid_z, rho_tof_noisy)
xlabel('$x\; (\mu m)$', 'Interpreter','latex')
ylabel('$z\; (\mu m)$','Interpreter','latex')
xticks([-60,0,60])
yticks([0,50,100])
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
clim([0,1])


f6(3) = subplot(2,2,4);
imagesc(coarse_grid_x, coarse_grid_z, rho_tof_reco)
xlabel('$x\; (\mu m)$', 'Interpreter','latex')
xticks([-60,0,60])
yticks([])
cb = colorbar;
set(get(cb,'label'),'string',sprintf('%s', '$\rho_{ToF}$'),'Interpreter','latex','FontSize',22);
set(cb, 'YTick', [0,0.5,1])
clim([0,1])
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

colormap(gge_colormap)
set(f6, 'FontName',fontname,'FontSize',fontsize)
