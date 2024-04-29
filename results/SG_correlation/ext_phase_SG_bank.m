clear all
close all
addpath('../../classes')
addpath('../../input')
load('thermal_cov_75nk.mat')
load('SG_profiles_batch2.mat')

img_res = 52;
condensate_length = 100e-6;
z_res = 200;
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);       
t_tof = 15e-3;
num_samples = 1;
width_flag = 1; %ALWAYS SET TO 1 IF THERE IS IMAGE PROCESSING

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_SG_3';
rel_phase = rel_phase(1:num_samples,:);
%sampling common phase
com_phase = phase_sampling_suite.generate_profiles(num_samples);


cg_rel_phase = zeros(num_samples, z_res);
cg_com_phase = zeros(num_samples, z_res);
%coarse-graining each phase profile for faster simulation
for i = 1:num_samples
    cg_rel_phase(i,:) = imresize(rel_phase(i,:), [1 z_res]);
    cg_com_phase(i,:) = imresize(com_phase(i,:), [1 z_res]);
end

%wop = without processing, wp = with processing
%woc = without common phase, wc = with common phase

ext_phase_wop_woc = zeros(num_samples, z_res);
ext_phase_wop_wc = zeros(num_samples, z_res);

ext_phase_wp_woc = zeros(num_samples, img_res); 
ext_phase_wp_wc = zeros(num_samples, img_res);

inner_count = 0;
for i = 1:num_samples
    interference_suite_woc = class_interference_pattern(cg_rel_phase(i,:), t_tof);
    interference_suite_wc = class_interference_pattern([cg_rel_phase(i,:); cg_com_phase(i,:)], t_tof);
    
    %initial width
    cloud_widths = interference_suite_woc.compute_density_sigma_t(0, t_tof);
    %full expansion (transversal and longitudinal)
    rho_tof_full_woc = interference_suite_woc.tof_full_expansion();
    rho_tof_full_wc = interference_suite_wc.tof_full_expansion();
    
    %create artificial image
    img_rho_tof_woc = absorption_imaging(rho_tof_full_woc', grid_dens, cloud_widths);
    img_rho_tof_wc = absorption_imaging(rho_tof_full_wc', grid_dens, cloud_widths);

    %phase extraction
    extraction_suite_woc = class_phase_extraction(img_rho_tof_woc, t_tof, width_flag);
    extraction_suite_wc = class_phase_extraction(img_rho_tof_wc, t_tof, width_flag);

    extraction_suite_woc_ref = class_phase_extraction(rho_tof_full_woc, t_tof, width_flag);
    extraction_suite_wc_ref = class_phase_extraction(rho_tof_full_wc, t_tof, width_flag);

    ext_phase_wp_woc(i,:) = extraction_suite_woc.fitting(extraction_suite_woc.init_phase_guess());
    ext_phase_wp_wc(i,:) = extraction_suite_wc.fitting(extraction_suite_wc.init_phase_guess());
    ext_phase_wop_woc(i,:) = extraction_suite_woc_ref.fitting(extraction_suite_woc_ref.init_phase_guess());
    ext_phase_wop_wc(i,:) = extraction_suite_wc_ref.fitting(extraction_suite_wc_ref.init_phase_guess());

    inner_count = inner_count +1;
    disp(inner_count)
end

fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res).*1e6;
super_fine_grid = linspace(-condensate_length/2, condensate_length/2, 1000).*1e6;
coarse_grid = linspace(-condensate_length/2, condensate_length/2, img_res).*1e6;
%save('ext_phase_SG_3_bank.mat', 'cg_rel_phase', 'rel_phase','com_phase', 'ext_phase_wop_wc', 'ext_phase_wop_woc', 'ext_phase_wp_woc', 'ext_phase_wp_wc', 'coarse_grid', 'fine_grid', 'super_fine_grid')