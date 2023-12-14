addpath('../classes')
addpath('../input')
load('thermal_cov_75nk.mat')

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
phase_profile = phase_sampling_suite.generate_profiles();
flag_interaction_broadening = 1;
t_tof = 15e-3; 

%initialize interference pattern class
interference_suite_with_broadening = class_interference_pattern(phase_profile, t_tof, 'InverseParabola', flag_interaction_broadening);
interference_suite = class_interference_pattern(phase_profile, t_tof);

%generating interference pattern
%transversal expansion only
rho_tof_trans_with_broadening = interference_suite_with_broadening.tof_transversal_expansion();
rho_tof_trans = interference_suite.tof_transversal_expansion();

%full expansion (transversal and longitudinal)
rho_tof_full_with_broadening = interference_suite_with_broadening.tof_full_expansion();
rho_tof_full = interference_suite.tof_full_expansion();

%showing the results
subplot(2,2,1)
imagesc(rho_tof_trans)
colorbar

subplot(2,2,2)
imagesc(rho_tof_full)
colorbar

subplot(2,2,3)
imagesc(rho_tof_trans_with_broadening)
colorbar

subplot(2,2,4)
imagesc(rho_tof_full_with_broadening)
colorbar

colormap(gge_colormap)