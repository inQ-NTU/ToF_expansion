clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 2e-6;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = transversal_length/pixel_width;
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z+1).*1e6;
num_samples = 500[];
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3;
ext_phase_woc_1 = zeros(num_samples, coarse_resolution_z);
ext_phase_woc_2 = zeros(num_samples, coarse_resolution_z);
ext_phase_woc_3 = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_1 = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_2 = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_3 = zeros(num_samples, coarse_resolution_z);
rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);
cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);
cg_com_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);
count = 0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t_tof_2);
    interference_suite_woc_3 = class_interference_pattern(rel_phase(i,:), t_tof_3);
    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    interference_suite_wc_3 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_3);
    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion(); 
    rho_tof_woc_1 = imresize(rho_tof_woc_1, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_woc_2 = imresize(rho_tof_woc_2, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_woc_3 = interference_suite_woc_3.tof_full_expansion();
    rho_tof_woc_3 = imresize(rho_tof_woc_3, [coarse_resolution_z, coarse_resolution_x]);
    
    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion(); 
    rho_tof_wc_1 = imresize(rho_tof_wc_1, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
    rho_tof_wc_2 = imresize(rho_tof_wc_2, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_wc_3 = interference_suite_wc_3.tof_full_expansion();
    rho_tof_wc_3 = imresize(rho_tof_wc_3, [coarse_resolution_z, coarse_resolution_x]);
    
    phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
    phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
    phase_ext_suite_woc_3 = class_phase_extraction(rho_tof_woc_3, t_tof_3);

    phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
    phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);
    phase_ext_suite_wc_3 = class_phase_extraction(rho_tof_wc_3, t_tof_3);

    ext_phase_woc_1(i,:) = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2(i,:) = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    ext_phase_woc_3(i,:) = phase_ext_suite_woc_3.fitting(phase_ext_suite_woc_3.init_phase_guess());

    ext_phase_wc_1(i,:) = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2(i,:) = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());
    ext_phase_wc_3(i,:) = phase_ext_suite_wc_3.fitting(phase_ext_suite_wc_3.init_phase_guess());
    count = count +1;
    disp(count)
end

save('phase_extraction_75nk_500samples.mat', 'rel_phase', 'cg_rel_phase','cg_com_phase', 'com_phase', 'ext_phase_woc_1', 'ext_phase_woc_2',...
    'ext_phase_woc_3', 'ext_phase_wc_1','ext_phase_wc_2', 'ext_phase_wc_3')