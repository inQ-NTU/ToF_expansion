clear all
close all
addpath('../../input')
addpath('../../classes')
load('thermal_cov_75nk.mat')

condensate_length = 100e-6;
pixel_width =1e-6;
pixnumz = floor(condensate_length/pixel_width);
z_grid = linspace(-condensate_length/2, condensate_length/2, pixnumz);

sampling_suite = class_gaussian_phase_sampling(cov_phase);
num_samples = 10;

t_tof_1 = 7e-3;
t_tof_2 = 15e-3;

gradient_vec_1_woc = zeros(num_samples, pixnumz);
gradient_vec_2_woc = zeros(num_samples, pixnumz);
gradient_vec_1_wc = zeros(num_samples, pixnumz);
gradient_vec_2_wc = zeros(num_samples, pixnumz);
gradient_vec_trans = zeros(num_samples, pixnumz);

rel_phase = sampling_suite.generate_profiles(num_samples);
rel_phase = sampling_suite.coarse_grain(pixnumz, rel_phase);
com_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.coarse_grain(pixnumz, com_phase);

count = 0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t_tof_2);
    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    
    rho_tof_trans = interference_suite_woc_1.tof_transversal_expansion();
    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();

    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();

    phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t_tof_1);

    phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
    phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);

    phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
    phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);
    
    
    ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());
    ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());
    

    gradient_vec_1_woc(i,:) = gradient(ext_phase_woc_1);
    gradient_vec_2_woc(i,:) = gradient(ext_phase_woc_2);
    gradient_vec_trans(i,:) = gradient(ext_phase_trans);
    gradient_vec_1_wc(i,:) = gradient(ext_phase_wc_1);
    gradient_vec_2_wc(i,:) = gradient(ext_phase_wc_2);
    count = count +1;
    disp(count)
end

%Compute the correlation
corr_trans = class_1d_correlation(gradient_vec_trans);
corr1_woc = class_1d_correlation(gradient_vec_1_woc);
corr2_woc = class_1d_correlation(gradient_vec_2_woc);
corr1_wc = class_1d_correlation(gradient_vec_1_wc);
corr2_wc = class_1d_correlation(gradient_vec_2_wc);

cov_trans = corr_trans.covariance_matrix();
cov1_woc = corr1_woc.covariance_matrix();
cov2_woc = corr2_woc.covariance_matrix();
cov1_wc = corr1_wc.covariance_matrix();
cov2_wc = corr2_wc.covariance_matrix();

%save('input_vel_vel_correlation.mat','rel_phase','com_phase')

%save('vel_vel_correlation.mat','gradient_vec_1_woc', 'gradient_vec_2_woc', 'gradient_vec_1_wc', 'gradient_vec_2_wc', ...
%    'gradient_vec_trans', 'cov1_woc', 'cov2_woc', 'cov1_wc', 'cov2_wc', 'cov_trans','rel_phase', 'com_phase')