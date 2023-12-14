clear all
close all
addpath('../../input')
addpath('../../classes')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width =1e-6;
N_atoms = 10^4;

sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);

coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = transversal_length/pixel_width;
%z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
%z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z+1).*1e6;
num_samples = 300;

t_tof_1 = 15e-3;
t_tof_2 = 30e-3;

ext_phase_woc_1 = zeros(num_samples, coarse_resolution_z);
ext_phase_woc_2 = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_1 = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_2 = zeros(num_samples, coarse_resolution_z);
ext_phase_trans = zeros(num_samples, coarse_resolution_z);

rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);

cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);
count = 0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t_tof_2);
    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    
    
    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_woc_1 = interference_suite_woc_1.normalize(rho_tof_woc_1, N_atoms);
    rho_tof_woc_1 = imresize(rho_tof_woc_1, [coarse_resolution_z, coarse_resolution_x]);

    rho_tof_trans = interference_suite_woc_1.tof_transversal_expansion();
    rho_tof_trans = interference_suite_woc_1.normalize(rho_tof_trans, N_atoms);
    rho_tof_trans = imresize(rho_tof_trans, [coarse_resolution_z, coarse_resolution_x]);

    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_woc_2 = interference_suite_woc_2.normalize(rho_tof_woc_2, N_atoms);
    rho_tof_woc_2 = imresize(rho_tof_woc_2, [coarse_resolution_z, coarse_resolution_x]);

    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_wc_1 = interference_suite_wc_1.normalize(rho_tof_wc_1, N_atoms);
    rho_tof_wc_1 = imresize(rho_tof_wc_1, [coarse_resolution_z, coarse_resolution_x]);

    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
    rho_tof_wc_2 = interference_suite_wc_2.normalize(rho_tof_wc_2, N_atoms);
    rho_tof_wc_2 = imresize(rho_tof_wc_2, [coarse_resolution_z, coarse_resolution_x]);

    phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
    phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
    phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t_tof_1);

    phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
    phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);    
    
    ext_phase_woc_1(i,:) = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2(i,:) = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    ext_phase_trans(i,:) = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());
    ext_phase_wc_1(i,:) = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2(i,:) = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());

    count = count +1;
    disp(count)
end

%Compute the correlation
corr_input = class_1d_correlation(rel_phase);
corr_trans = class_1d_correlation(ext_phase_trans);
corr1_woc = class_1d_correlation(ext_phase_woc_1);
corr2_woc = class_1d_correlation(ext_phase_woc_2);
corr1_wc = class_1d_correlation(ext_phase_wc_1);
corr2_wc = class_1d_correlation(ext_phase_wc_2);

cov_in = corr_input.covariance_matrix();
cov_trans = corr_trans.covariance_matrix();
cov1_woc = corr1_woc.covariance_matrix();
cov2_woc = corr2_woc.covariance_matrix();
cov1_wc = corr1_wc.covariance_matrix();
cov2_wc = corr2_wc.covariance_matrix();

%save('cov_reconstruction.mat', 'rel_phase', 'com_phase', 'ext_phase_woc_1', 'ext_phase_woc_2','ext_phase_wc_1', 'ext_phase_wc_2','ext_phase_trans','cov_in','cov_trans', 'cov1_woc', 'cov2_woc', 'cov1_wc', 'cov2_wc')