close all
clear all
addpath('../classes')
addpath('../input')
load('thermal_cov_100nk.mat')
coarse_dim = 81;
%Gaussian phase sampling
sampling_suite = class_gaussian_phase_sampling(cov_phase);

rel_phase = sampling_suite.generate_profiles(2);
cg_rel_phase = sampling_suite.coarse_grain(coarse_dim, rel_phase);

%interference class
interference_suite = class_interference_pattern(cg_rel_phase);
rho_tof_full = interference_suite.tof_full_expansion();
rho_tof_trans = interference_suite.tof_transversal_expansion();

%phase extraction class
phase_ext_trans = class_phase_extraction(rho_tof_trans);
phase_ext_full = class_phase_extraction(rho_tof_full);

ext_phase_full = phase_ext_full.fitting(phase_ext_full.init_phase_guess());
ext_phase_trans = phase_ext_trans.fitting(phase_ext_trans.init_phase_guess());

%Plot
plot(cg_rel_phase(1,:))
hold on
plot(ext_phase_full, 'x')
plot(ext_phase_trans, 'o')

