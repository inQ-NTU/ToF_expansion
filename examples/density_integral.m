addpath('../classes')
addpath('../input')

load('thermal_cov_50nk.mat')
t_tof = 30e-3;
%initiate gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);

phase_samples = phase_sampling_suite.generate_profiles();

%Coarse-graining each sample to the size of 50
coarse_dim = 81;
coarse_samples = phase_sampling_suite.coarse_grain(coarse_dim, phase_samples);

%initialize interference pattern class
interference_suite = class_interference_pattern(coarse_samples, t_tof);

%full_tof
rho_tof_full = interference_suite.tof_full_expansion();
rho_tof_full = rho_tof_full*1e-18; 
%rho_tof_trans = interference_suite.tof_transversal_expansion();
imagesc(rho_tof_full)
colorbar