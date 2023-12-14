clear all
close all
addpath('../../input')
addpath('../../classes')
addpath('../../artificial_imaging')
addpath('../../artificial_imaging/necessary_functions')
addpath('../../artificial_imaging/utility')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 

%%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
shift_calibrate     = 2400;                 %Calibration factor

load('input_vel_vel_correlation.mat')       %loading input phase profiles

z_res = size(rel_phase,2);
x_res = 1.2*z_res;
Delta_res = x_res - z_res; 

width_fit_flag = 1;

num_samples = size(rel_phase, 1);
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

coarse_resolution_z = 52;


t_tof_1 = 7e-3;
t_tof_2 = 15e-3;

gradient_vec_1_woc = zeros(num_samples, coarse_resolution_z);
gradient_vec_2_woc = zeros(num_samples, coarse_resolution_z);
gradient_vec_1_wc = zeros(num_samples, coarse_resolution_z);
gradient_vec_2_wc = zeros(num_samples, coarse_resolution_z);
gradient_vec_trans = zeros(num_samples, coarse_resolution_z);

count = 0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t_tof_2);
    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    
    cloud_widths_1 = interference_suite_woc_1.compute_density_sigma_t(0, t_tof_1);
    cloud_widths_2 = interference_suite_woc_1.compute_density_sigma_t(0, t_tof_2);

    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();

    %Processing the image
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

    %calibrate, transpose, and resizing
    img_rho_tof_woc_1 = shift_calibrate -img_rho_tof_woc_1;
    img_rho_tof_woc_1 = img_rho_tof_woc_1';
    img_rho_tof_woc_2 = shift_calibrate - img_rho_tof_woc_2;
    img_rho_tof_woc_2 = img_rho_tof_woc_2';
    
    img_rho_tof_wc_1 = shift_calibrate - img_rho_tof_wc_1;
    img_rho_tof_wc_1 = img_rho_tof_wc_1';
    img_rho_tof_wc_2 = shift_calibrate - img_rho_tof_wc_2;
    img_rho_tof_wc_2 = img_rho_tof_wc_2';

    phase_ext_suite_woc_1 = class_phase_extraction(img_rho_tof_woc_1, t_tof_1, width_fit_flag);
    phase_ext_suite_woc_2 = class_phase_extraction(img_rho_tof_woc_2, t_tof_2, width_fit_flag);

    phase_ext_suite_wc_1 = class_phase_extraction(img_rho_tof_wc_1, t_tof_1, width_fit_flag);
    phase_ext_suite_wc_2 = class_phase_extraction(img_rho_tof_wc_2, t_tof_2, width_fit_flag);
    
    ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());    

    gradient_vec_1_woc(i,:) = gradient(ext_phase_woc_1);
    gradient_vec_2_woc(i,:) = gradient(ext_phase_woc_2);
    gradient_vec_1_wc(i,:) = gradient(ext_phase_wc_1);
    gradient_vec_2_wc(i,:) = gradient(ext_phase_wc_2);
    count = count +1;
    disp(count)
end

%Compute the correlation
corr1_woc = class_1d_correlation(gradient_vec_1_woc);
corr2_woc = class_1d_correlation(gradient_vec_2_woc);
corr1_wc = class_1d_correlation(gradient_vec_1_wc);
corr2_wc = class_1d_correlation(gradient_vec_2_wc);

cov1_woc = corr1_woc.covariance_matrix();
cov2_woc = corr2_woc.covariance_matrix();
cov1_wc = corr1_wc.covariance_matrix();
cov2_wc = corr2_wc.covariance_matrix();

save('vel_vel_correlation_processed.mat','gradient_vec_1_woc', 'gradient_vec_2_woc', 'gradient_vec_1_wc', 'gradient_vec_2_wc', ...
    'cov1_woc', 'cov2_woc', 'cov1_wc', 'cov2_wc')