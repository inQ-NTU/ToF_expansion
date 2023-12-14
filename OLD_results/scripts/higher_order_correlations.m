clear all
close all
%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

%initialize gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
%load('500_phase_data_and_correlations_15.6ms_tof.mat')
%generate nmb_samples phase profiles and coarse-graining them
nmb_samples = 100;
t_tof = 15e-3;
coarse_dim = 40;

all_samples = phase_sampling_suite.generate_profiles(nmb_samples);
coarse_samples = phase_sampling_suite.coarse_grain(all_samples, coarse_dim);

%Looping and perform extraction
extracted_phase_data = zeros(nmb_samples, coarse_dim);
count = 0;
for i = 1:nmb_samples
    interference_suite = class_interference_pattern(all_samples(i,:), t_tof);
    rho_tof = interference_suite.tof_full_expansion();
    rho_tof = imresize(rho_tof, [coarse_dim, 1.2*coarse_dim]);
    
    extraction_suite = class_phase_extraction(rho_tof,t_tof);
    extracted_profile = extraction_suite.fitting(extraction_suite.init_phase_guess());
    extracted_phase_data(i,:) = extracted_profile;

    count = count+1;
    disp(count)
    
end


%initialize 1d correlation class
correlation_suite = class_1d_correlation(extracted_phase_data);

%correlation function
G4 = correlation_suite.correlation_func(4);

%wick calculation
W4 = correlation_suite.wick_four_point_correlation();

%Deviation from Wick
DevGW4 = G4-W4;

%Plotting the outcome
z_grid = linspace(-50,50, coarse_dim);
fontname = 'Times';
fontsize = 16;

fig = figure;
f(1) = subplot(1,3,1);
imagesc(z_grid, z_grid, G4(:,:,floor(coarse_dim/4),floor(3*coarse_dim/4)))
colorbar
ylabel('$z_1\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
xlabel('$z_2\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')

f(2) = subplot(1,3,2);
imagesc(z_grid, z_grid, W4(:,:,floor(coarse_dim/4),floor(3*coarse_dim/4)))
colorbar
xlabel('$z_2\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')

f(3) = subplot(1,3,3);
imagesc(z_grid, z_grid, DevGW4(:,:,floor(coarse_dim/4),floor(3*coarse_dim/4)))
colorbar
xlabel('$z_2\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')

colormap(gge_colormap)
set(f, 'FontName',fontname,'FontSize',fontsize)

if 0
%display the true and reconstructed covariance matrix
z_grid = linspace(0,100, coarse_dim);
fontname = 'Times';
fontsize = 16;
crange_G3 = [-0.5,0.5];
crange_G4 = [0,6];


fig = figure;
f(1) = subplot(2,2,1);
imagesc(z_grid, z_grid, third_order_corr_data_ori(:,:,floor(3*coarse_dim/4)))
clim(crange_G3)
yticks([0,50,100])
yticklabels([0,50,100])
xticks([])
ylabel('$z_1\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
title('$G^{(3)}(\mathbf{z})$','Interpreter','latex','FontSize',fontsize+2)


f(2) = subplot(2,2,2);
imagesc(z_grid, z_grid, third_order_corr_data_ext(:,:,floor(3*coarse_dim/4)))
colorbar
clim(crange_G3)
cb1 = colorbar(f(2),'Location','EastOutside','TickLabelInterpreter','latex');
cb1.Position = cb1.Position + [0.08,0,0,-0.012];
yticks([])
xticks([])
title('$G^{(3)}_{ToF}(\mathbf{z})$','Interpreter','latex','FontSize',fontsize+2)

f(3) = subplot(2,2,3); 
imagesc(z_grid, z_grid, fourth_order_corr_data_ori(:,:,floor(coarse_dim/4),floor(3*coarse_dim/4)))
clim(crange_G4)
ylabel('$z_1\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
xlabel('$z_2\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
title('$G^{(4)}(\mathbf{z})$','Interpreter','latex','FontSize',fontsize+2)


f(4) = subplot(2,2,4); 
imagesc(z_grid, z_grid, fourth_order_corr_data_ext(:,:,floor(coarse_dim/4),floor(3*coarse_dim/4)))
clim(crange_G4)
cb2 = colorbar(f(4),'Location','EastOutside','TickLabelInterpreter','latex');
cb2.Position = cb2.Position + [0.08,0,0,-0.012];
yticks([])
xlabel('$z_2\; (\mu m)$', 'FontSize',fontsize, 'FontName',fontname,'Interpreter','latex')
title('$G^{(4)}_{ToF}(\mathbf{z})$','Interpreter','latex','FontSize',fontsize+2)

colormap(gge_colormap)
set(f, 'FontName',fontname,'FontSize',fontsize)
end