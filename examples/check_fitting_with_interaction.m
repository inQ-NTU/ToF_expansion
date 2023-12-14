close all
clear all
addpath('../classes')
addpath('../input')
load('thermal_cov_75nk.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

%generate sample and coarse-graining it
coarse_dim = 100;
phase_profile = phase_sampling_suite.generate_profiles();
coarse_phase_profile = phase_sampling_suite.coarse_grain(coarse_dim, phase_profile);
t_tof = 30e-3; 
flag_interaction_broadening = 1;

%initialize interference pattern class
interference_suite_with_broadening = class_interference_pattern(coarse_phase_profile, t_tof, flag_interaction_broadening);
interference_suite = class_interference_pattern(coarse_phase_profile, t_tof);

%generate rho tof
rho_tof_with_broadening = interference_suite_with_broadening.tof_full_expansion();
%rho_tof_with_broadening = interference_suite_with_broadening.tof_transversal_expansion();
rho_tof = interference_suite.tof_full_expansion();

%initialize phase extraction class
phase_extraction_suite_with_broadening = class_phase_extraction(rho_tof_with_broadening, t_tof, flag_interaction_broadening);
phase_extraction_suite = class_phase_extraction(rho_tof, t_tof);

%make initial guess by the position of interference peak
init_phase_with_broadening = phase_extraction_suite_with_broadening.init_phase_guess();
init_phase = phase_extraction_suite.init_phase_guess();

%perform fitting
fitted_phase_with_broadening = phase_extraction_suite_with_broadening.fitting(init_phase_with_broadening);
fitted_phase = phase_extraction_suite.fitting(init_phase);

plot(coarse_phase_profile)
hold on
plot(fitted_phase_with_broadening, 'o')
plot(fitted_phase,'x')