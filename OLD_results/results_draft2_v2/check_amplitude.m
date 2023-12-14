clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 1e-6;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = transversal_length/pixel_width;
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z+1).*1e6;
num_samples = 1;
rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);
interference_suite_woc = class_interference_pattern(rel_phase);
interference_suite_wc = class_interference_pattern([rel_phase; com_phase]);
rho_tof_woc = interference_suite_woc.tof_full_expansion();
rho_tof_woc = imresize(rho_tof_woc, [coarse_resolution_z coarse_resolution_x]);
rho_tof_trans = interference_suite_woc.tof_transversal_expansion();
rho_tof_trans = imresize(rho_tof_trans, [coarse_resolution_z coarse_resolution_x]);
rho_tof_wc = interference_suite_wc.tof_full_expansion();
rho_tof_wc = imresize(rho_tof_wc, [coarse_resolution_z coarse_resolution_x]);
phase_ext_suite_woc = class_phase_extraction(rho_tof_woc);
phase_ext_suite_wc = class_phase_extraction(rho_tof_wc);
phase_ext_suite_trans = class_phase_extraction(rho_tof_trans);
ext_phase_woc = phase_ext_suite_woc.fitting(phase_ext_suite_woc.init_phase_guess());
ext_phase_wc = phase_ext_suite_wc.fitting(phase_ext_suite_wc.init_phase_guess());
ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());
plot(phase_ext_suite_trans.normalization_amplitudes)
hold on
plot(phase_ext_suite_woc.normalization_amplitudes)
plot(phase_ext_suite_wc.normalization_amplitudes)
