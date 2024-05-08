close all
clear all
addpath('../classes')
addpath('../input')
addpath('../imaging_effect')
addpath('../imaging_effect/utility')
addpath('../imaging_effect/image_analysis')
addpath('../imaging_effect/artificial_imaging')
addpath('../imaging_effect/artificial_imaging/necessary_functions')
load('thermal_cov_75nk.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

%generate sample and coarse-graining it
coarse_dim = 100;
z_grid = linspace(-50,50,coarse_dim);
phase_profile = phase_sampling_suite.generate_profiles();
coarse_phase_profile = phase_sampling_suite.coarse_grain(coarse_dim, phase_profile);
t_tof = 12e-3; 
flag_interaction_broadening = 1; %Always set to 1 if one consider fitting with image processing
%The above flag will also turn the width as a fitting parameter during
%extraction
%Image processing modifies the effective width of interference fringes,
%even when the original image has a uniform width -> This is why one always
%has to turn this on when fitting after image processing

%initialize interference pattern class
interference_suite_with_broadening = class_interference_pattern(coarse_phase_profile, t_tof, 'InverseParabola', flag_interaction_broadening);
interference_suite = class_interference_pattern(coarse_phase_profile, t_tof);

%initial width
cloud_widths = interference_suite.compute_density_sigma_t(0, t_tof);

%generate TOF density data
rho_tof_with_broadening = interference_suite_with_broadening.tof_full_expansion();
rho_tof = interference_suite.tof_full_expansion();
rho_tof_with_processing = absorption_imaging(rho_tof, z_grid*1e-6, cloud_widths);

%initialize phase extraction class
phase_extraction_suite_with_broadening = class_phase_extraction(rho_tof_with_broadening, t_tof, flag_interaction_broadening);
phase_extraction_suite = class_phase_extraction(rho_tof, t_tof);

phase_extraction_suite_with_processing = class_phase_extraction(rho_tof_with_processing', t_tof, flag_interaction_broadening);
%due to image processing code -> one has to transpose the image first before
%extraction

%make initial guess by the position of interference peak
init_phase_with_broadening = phase_extraction_suite_with_broadening.init_phase_guess();
init_phase = phase_extraction_suite.init_phase_guess();
init_phase_with_processing = phase_extraction_suite_with_processing.init_phase_guess();

%perform fitting
fitted_phase_with_broadening = phase_extraction_suite_with_broadening.fitting(init_phase_with_broadening);
fitted_phase = phase_extraction_suite.fitting(init_phase);
fitted_phase_with_processing = phase_extraction_suite_with_processing.fitting(init_phase_with_processing);


z_grid_processing = linspace(-50,50, length(fitted_phase_with_processing));

plot(z_grid, coarse_phase_profile)
hold on
plot(z_grid, fitted_phase,'x')
plot(z_grid, fitted_phase_with_broadening, 'o')
plot(z_grid_processing, fitted_phase_with_processing, '^')
legend('Input phase', 'Fitted phase', 'Fitted phase with broadening', 'Fitted phase with processing')

figure
f(1) = subplot(1,3,1);
imagesc(z_grid, z_grid, rho_tof') 
colorbar

f(2) = subplot(1,3,2);
imagesc(z_grid, z_grid, rho_tof_with_broadening')
colorbar

f(3) = subplot(1,3,3);
imagesc(z_grid_processing, z_grid_processing, rho_tof_with_processing)
colorbar

colormap(gge_colormap)


