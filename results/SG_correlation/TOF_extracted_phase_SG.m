clear all
close all
addpath('../../classes')
addpath('../../input')

%The raw data SG_profiles_batch1 and SG_profiles_batch2 are quite memory
%heavy and therefore are not available in online repository. Please contact
%the raw data
load('SG_profiles_batch1.mat')
load('thermal_cov_50nk_1000x1000.mat') %thermal cov for sampling common phase

num_samples = 1000;
pixnum = 1000;
cg_pixnum = 200;
t_tof_1 = 10e-3; 
t_tof_2 = 15e-3;
t_tof_3 = 20e-3;

gauss_sampling = class_gaussian_phase_sampling(cov_phase);
input_relative_phase = phase_SG_10';
input_common_phase = gauss_sampling.generate_profiles(num_samples);

%coarse_graining
cg_input_relative_phase = gauss_sampling.coarse_grain(cg_pixnum, input_relative_phase);
cg_input_common_phase = gauss_sampling.coarse_grain(cg_pixnum, input_common_phase);

ext_rel_phase_woc_10ms = zeros(num_samples, cg_pixnum);
ext_rel_phase_wc_10ms = zeros(num_samples, cg_pixnum);

ext_rel_phase_woc_15ms = zeros(num_samples, cg_pixnum);
ext_rel_phase_wc_15ms = zeros(num_samples, cg_pixnum); 

ext_rel_phase_woc_20ms = zeros(num_samples, cg_pixnum);
ext_rel_phase_wc_20ms = zeros(num_samples, cg_pixnum); 

count =0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern(cg_input_relative_phase(i,:),t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(cg_input_relative_phase(i,:),t_tof_2);
    interference_suite_woc_3 = class_interference_pattern(cg_input_relative_phase(i,:),t_tof_3);
    
    interference_suite_wc_1 = class_interference_pattern([cg_input_relative_phase(i,:); cg_input_common_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([cg_input_relative_phase(i,:); cg_input_common_phase(i,:)], t_tof_2);
    interference_suite_wc_3 = class_interference_pattern([cg_input_relative_phase(i,:); cg_input_common_phase(i,:)], t_tof_3);

    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_woc_3 = interference_suite_woc_3.tof_full_expansion();

    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
    rho_tof_wc_3 = interference_suite_wc_3.tof_full_expansion();

    extraction_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
    extraction_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
    extraction_suite_woc_3 = class_phase_extraction(rho_tof_woc_3, t_tof_3);

    extraction_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
    extraction_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);
    extraction_suite_wc_3 = class_phase_extraction(rho_tof_wc_3, t_tof_3);

    ext_rel_phase_woc_10ms(i,:) = extraction_suite_woc_1.fitting(extraction_suite_woc_1.init_phase_guess());
    ext_rel_phase_woc_15ms(i,:) = extraction_suite_woc_2.fitting(extraction_suite_woc_2.init_phase_guess());
    ext_rel_phase_woc_20ms(i,:) = extraction_suite_woc_3.fitting(extraction_suite_woc_3.init_phase_guess());

    ext_rel_phase_wc_10ms(i,:) = extraction_suite_wc_1.fitting(extraction_suite_wc_1.init_phase_guess());
    ext_rel_phase_wc_15ms(i,:) = extraction_suite_wc_2.fitting(extraction_suite_wc_2.init_phase_guess());
    ext_rel_phase_wc_20ms(i,:) = extraction_suite_wc_3.fitting(extraction_suite_wc_3.init_phase_guess());

    count = count+1;
    disp(count)
end
%save('SG_10_tof.mat','cg_input_relative_phase', 'cg_input_common_phase', 'input_common_phase', 'input_relative_phase',...
%    'ext_rel_phase_woc_10ms', 'ext_rel_phase_woc_15ms', 'ext_rel_phase_woc_20ms', 'ext_rel_phase_wc_10ms', 'ext_rel_phase_wc_15ms',...
%    'ext_rel_phase_wc_20ms')
