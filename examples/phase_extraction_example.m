close all
clear all

%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_60nk.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

%generate sample and coarse-graining it
coarse_dim = 100;
phase_profile = phase_sampling_suite.generate_profiles();
coarse_phase_profile = phase_sampling_suite.coarse_grain(coarse_dim, phase_profile);
t_tof = 15e-3; 

%initialize interference pattern class
interference_suite = class_interference_pattern(coarse_phase_profile, t_tof, 'InverseParabola');

%generate rho tof
rho_tof = interference_suite.tof_full_expansion();

%initialize phase extraction class
phase_extraction_suite = class_phase_extraction(rho_tof, t_tof);

%make initial guess by the position of interference peak
init_phase = phase_extraction_suite.init_phase_guess();

%perform fitting
fitted_phase = phase_extraction_suite.fitting(init_phase);

subplot(1,2,1)
imagesc(rho_tof)
colorbar

colormap(gge_colormap)

subplot(1,2,2)
plot(linspace(0,100,400), phase_profile, 'b')
hold on
plot(linspace(0,100,coarse_dim),fitted_phase, 'o', 'Color','red')
legend('Input Phase', 'Extracted Phase')


