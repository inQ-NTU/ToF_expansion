close all
%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')
load('EXAMPLE_sampled_phase_profile.mat')
coarse_dim = 50;
SNR = 100;
phase_profile = pi*phase_profile;

%initialize phase sampling clas
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);

%generate phase sample and coarse-graining it (with common)
%phase_profile = phase_sampling_suite.generate_profiles(2);
coarse_phase_profile = phase_sampling_suite.coarse_grain(phase_profile, coarse_dim);

%initialize interference pattern class
interference_suite_coarse = class_interference_pattern(coarse_phase_profile);
interference_suite_fine = class_interference_pattern(phase_profile);

%generate rho tof
rho_tof_fine = interference_suite_fine.tof_full_expansion();
rho_tof_coarse = interference_suite_coarse.tof_full_expansion();
rho_tof_conv = interference_suite_coarse.convolution2d(rho_tof_coarse);
rho_tof_noisy = interference_suite_coarse.add_gaussian_noise(rho_tof_conv, 1/SNR);

%initializing phase extraction class
extraction_suite = class_phase_extraction(rho_tof_noisy);

%perform phase extraction
init_phase = extraction_suite.init_phase_guess();
final_phase = extraction_suite.fitting(init_phase);
%if 0
%reconstruction of rho tof
rho_tof_reco = extraction_suite.reconstructed_interference_pattern;

%amplitudes and contrasts
amplitude = extraction_suite.normalization_amplitudes;
contrast = extraction_suite.contrasts;


%Plotting the results
%set plotting parameters
gas_length = 100; %microns
fontname = 'Times';
fontsize = 16;
%define grids
fine_grid_z = linspace(0,gas_length, length(cov_phase_fine));
coarse_grid_z = linspace(0,gas_length, coarse_dim);
fine_grid_x = linspace(-60,60, size(rho_tof_fine,2));
coarse_grid_x = linspace(-60,60, size(rho_tof_coarse, 2));

%normalizing each rho tof
rho_tof_fine = rho_tof_fine/max(rho_tof_fine, [],'all');
rho_tof_coarse = rho_tof_coarse/max(rho_tof_coarse,[],'all');
rho_tof_conv = rho_tof_conv/max(rho_tof_conv,[],'all');
rho_tof_noisy = rho_tof_noisy/max(rho_tof_noisy,[],'all');
rho_tof_reco = rho_tof_reco/max(rho_tof_reco, [],'all');

%%%%%%%%%%%%%Figure 4%%%%%%%%%%%%%%%%%
img1 = figure;
f4 = tight_subplot(1,2,[0.1,0.075],[0.15, 0.15],[0.1, 0.1]);

axes(f4(1))
imagesc(fine_grid_z, fine_grid_z, cov_phase_fine)
colormap(gge_colormap)
cb = colorbar;
clim([0,3])
set(cb,'YTick',[0,1,2,3])
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\Gamma_{\phi\phi}$')
set(get(cb,'Title'),'FontSize',fontsize+5)
xlabel('$z^\prime (\mu m)$','Interpreter','latex')
ylabel('$z\; (\mu  m)$','Interpreter','latex')
yticks([0,50,100])
xticks([0,50,100])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

axes(f4(2));
plot(fine_grid_z, phase_profile(1,:),'black')
hold on
plot(fine_grid_z, phase_profile(2,:), '--black')
hold off
legend({'$\varphi_r$','$\varphi_c$'}, 'Interpreter','latex','FontSize',fontsize)
legend box off
ylb = ylabel('$\varphi_{r,c}(z)$','Interpreter','latex','FontSize',fontsize);
ylb.Position(1) = ylb.Position(1)+5;
ylb.Position(2) = ylb.Position(2)+0.1;
ylim([-pi,pi])
yticks([-pi, 0, pi])
xticks([0,50,100])
yticklabels({'$-\pi$', '$0$', '$\pi$'})
xlabel('$z\; (\mu m)$','Interpreter','latex')
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

set(f4, 'FontName',fontname,'FontSize',fontsize)

%%%%%%%%%%Figure 5%%%%%%%%%%%%%%%%%%%%%%%%%%
img2 = figure;
f5 = tight_subplot(2,2,[0.1,0.075],[0.1, 0.1],[0.15, 0.15]);
axes(f5(1))
imagesc(fine_grid_x, fine_grid_z, rho_tof_fine)
ylabel('$z\; (\mu m)$','FontSize',fontsize, 'Interpreter','latex')
xticks([])
yticks([0,50,100])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

axes(f5(2))
imagesc(coarse_grid_x,coarse_grid_z,rho_tof_coarse)
xticks([])
yticks([])
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);


axes(f5(3))
imagesc(coarse_grid_x, coarse_grid_z, rho_tof_conv)
xlabel('$x\; (\mu m)$','FontSize',fontsize, 'Interpreter','latex')
ylabel('$z\; (\mu m)$','FontSize',fontsize, 'Interpreter','latex')
xticks([-60,0,60])
yticks([0,50,100])
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

axes(f5(4))
imagesc(coarse_grid_x, coarse_grid_z, rho_tof_noisy)
xlabel('$x\; (\mu m)$','FontSize',fontsize, 'Interpreter','latex')
xticks([-60,0,60])
yticks([])
title('(d)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

set(f5, 'FontName',fontname,'FontSize',fontsize)
colormap(gge_colormap)
cb = colorbar;
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',fontsize+5)
set(cb, 'YTick', [0,0.25,0.5,0.75,1])
cb.Position = cb.Position + [0.1,0,0,0.45];

%%%%%%%%%%%%Figure 6%%%%%%%%%%%%%%%%%%%%%%%%%%
img3 = figure;
f6(1) = subplot(2,2,[1,2]);
plot(fine_grid_z, phase_profile(1,:),'color','black','Linewidth', 1.2)
hold on
plot(coarse_grid_z, init_phase, 'o')
plot(coarse_grid_z, final_phase, '.-red','Linewidth',1.2,'MarkerSize', 12)
xticks([0,50,100])
xlabel('$z\; (\mu m)$','Interpreter','latex','FontSize',fontsize)
ylabel('$\varphi_r(z)$','Interpreter','latex','FontSize',fontsize)
legend({'$\varphi_r^{(true)}$','$\varphi_r^{(cal)}$', '$\varphi_r^{(fit)}$'},'Interpreter','latex')
legend box off
yticks([-pi,0,pi])
yticklabels({'$-\pi$','$0$','$\pi$'})
xticks([0,50,100])
ylim([-pi,pi])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

axes('Position',[.2 .62 .12 .1] );
box on
plot(coarse_grid_z, amplitude,'color', 'blue','Linewidth', 1.2)
hold on
plot(coarse_grid_z, contrast, 'color', '#77AC30','Linewidth', 1.2)

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
cb.Position = cb.Position + [0.08,0,0,0];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',fontsize)
set(cb, 'YTick', [0,0.5,1])
clim([0,1])
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

colormap(gge_colormap)
set(f6, 'FontName',fontname,'FontSize',fontsize)
%end