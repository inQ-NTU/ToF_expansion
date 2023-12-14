clear all
close all
addpath('../../classes')
addpath('../../input')
addpath('../../artificial_imaging/')
addpath('../../artificial_imaging/necessary_functions')
addpath('../../artificial_imaging/utility')
load('SG_profiles_batch1.mat')
load('thermal_cov_50nk_1000x1000.mat')

num_samples = 1000;
cg_pixnum = 200;
condensate_length = 100e-6;
grid_dens = linspace(-condensate_length/2, condensate_length/2, cg_pixnum);

t_tof_1 = 10e-3; 
t_tof_2 = 15e-3;
t_tof_3 = 20e-3;

%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
shift_calibrate = 2400;                     %the calibration value when there is no absorption
img_res = 52;


gauss_sampling = class_gaussian_phase_sampling(cov_phase);
input_relative_phase = phase_SG_10';
input_common_phase = gauss_sampling.generate_profiles(num_samples);

%coarse_graining
cg_input_relative_phase = gauss_sampling.coarse_grain(cg_pixnum, input_relative_phase);
cg_input_common_phase = gauss_sampling.coarse_grain(cg_pixnum, input_common_phase);

ext_rel_phase_woc_10ms = zeros(num_samples, img_res);
ext_rel_phase_wc_10ms = zeros(num_samples, img_res);

ext_rel_phase_woc_15ms = zeros(num_samples, img_res);
ext_rel_phase_wc_15ms = zeros(num_samples, img_res); 

ext_rel_phase_woc_20ms = zeros(num_samples, img_res);
ext_rel_phase_wc_20ms = zeros(num_samples, img_res); 

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

    %initial width
    cloud_widths_1 = interference_suite_woc_1.compute_density_sigma_t(0, t_tof_1);
    cloud_widths_2 = interference_suite_woc_2.compute_density_sigma_t(0, t_tof_2);
    cloud_widths_3 = interference_suite_woc_3.compute_density_sigma_t(0, t_tof_3);
    


    %create artificial image
        img_rho_tof_woc_1 = create_artificial_images(rho_tof_woc_1, ...
                                 grid_dens, ...
                                 cloud_widths_1, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);
  
        img_rho_tof_woc_2 = create_artificial_images(rho_tof_woc_2, ...
                                 grid_dens, ...
                                 cloud_widths_2, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

        img_rho_tof_woc_3 = create_artificial_images(rho_tof_woc_3, ...
                                 grid_dens, ...
                                 cloud_widths_3, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

        img_rho_tof_wc_1 = create_artificial_images(rho_tof_wc_1, ...
                                 grid_dens, ...
                                 cloud_widths_1, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);
  
        img_rho_tof_wc_2 = create_artificial_images(rho_tof_wc_2, ...
                                 grid_dens, ...
                                 cloud_widths_2, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

        img_rho_tof_wc_3 = create_artificial_images(rho_tof_wc_3, ...
                                 grid_dens, ...
                                 cloud_widths_3, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

     %Calibrating and defining grids
     img_rho_tof_woc_1 = shift_calibrate -img_rho_tof_woc_1;
     img_rho_tof_wc_1 = shift_calibrate - img_rho_tof_wc_1;

     img_rho_tof_woc_2 = shift_calibrate -img_rho_tof_woc_2;
     img_rho_tof_wc_2 = shift_calibrate - img_rho_tof_wc_2;

     img_rho_tof_woc_3 = shift_calibrate -img_rho_tof_woc_3;
     img_rho_tof_wc_3 = shift_calibrate - img_rho_tof_wc_3;


    extraction_suite_woc_1 = class_phase_extraction(img_rho_tof_woc_1', t_tof_1);
    extraction_suite_woc_2 = class_phase_extraction(img_rho_tof_woc_2', t_tof_2);
    extraction_suite_woc_3 = class_phase_extraction(img_rho_tof_woc_3', t_tof_3);

    extraction_suite_wc_1 = class_phase_extraction(img_rho_tof_wc_1', t_tof_1);
    extraction_suite_wc_2 = class_phase_extraction(img_rho_tof_wc_2', t_tof_2);
    extraction_suite_wc_3 = class_phase_extraction(img_rho_tof_wc_3', t_tof_3);

    ext_rel_phase_woc_10ms(i,:) = extraction_suite_woc_1.fitting(extraction_suite_woc_1.init_phase_guess());
    ext_rel_phase_woc_15ms(i,:) = extraction_suite_woc_2.fitting(extraction_suite_woc_2.init_phase_guess());
    ext_rel_phase_woc_20ms(i,:) = extraction_suite_woc_3.fitting(extraction_suite_woc_3.init_phase_guess());

    ext_rel_phase_wc_10ms(i,:) = extraction_suite_wc_1.fitting(extraction_suite_wc_1.init_phase_guess());
    ext_rel_phase_wc_15ms(i,:) = extraction_suite_wc_2.fitting(extraction_suite_wc_2.init_phase_guess());
    ext_rel_phase_wc_20ms(i,:) = extraction_suite_wc_3.fitting(extraction_suite_wc_3.init_phase_guess());

    count = count+1;
    disp(count)
end
save('SG_10_tof_with_processing.mat','cg_input_relative_phase', 'cg_input_common_phase', 'input_common_phase', 'input_relative_phase',...
    'ext_rel_phase_woc_10ms', 'ext_rel_phase_woc_15ms', 'ext_rel_phase_woc_20ms', 'ext_rel_phase_wc_10ms', 'ext_rel_phase_wc_15ms',...
    'ext_rel_phase_wc_20ms')
