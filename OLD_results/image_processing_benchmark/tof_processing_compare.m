clear all
close all

%Adding directories and loading example phase profile containing a variable
%phase_profile_RS
%First (second) row of phase_profile_RS is interpreted to be relative (common) phase
addpath('../classes')
addpath('../input')
addpath('../artificial_imaging')
addpath('../artificial_imaging/necessary_functions')
addpath('../artificial_imaging/utility')
%load('EXAMPLE_phase_profile.mat')
load('thermal_cov_75nk.mat')

condensate_length = 100e-6;
t_tof_1 = 14e-3;
t_tof_2 = 15e-3; 
width_flag = 1;

%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
shift_calibrate = 2400;                     %the calibration value when there is no absorption
img_res = 52;

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles();
%com_phase = phase_sampling_suite.generate_profiles();


cg_rel_phase = phase_sampling_suite.coarse_grain(img_res, rel_phase);
%initialize interference pattern class
%woc = without common phase
%wc = with common phase
interference_suite_1 = class_interference_pattern(rel_phase, t_tof_1);
interference_suite_2 = class_interference_pattern(rel_phase, t_tof_2);

%initial width
cloud_widths_1 = interference_suite_1.compute_density_sigma_t(0, t_tof_1);
cloud_widths_2 = interference_suite_2.compute_density_sigma_t(0, t_tof_2);

%full expansion (transversal and longitudinal)
rho_tof_1 = interference_suite_1.tof_full_expansion();

rho_tof_2 = interference_suite_2.tof_full_expansion();

%Making the image square for processing purpose
z_res = size(rho_tof_1, 1);
%x_res = size(rho_tof_1, 2);
%Delta_res = x_res - z_res; 
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

%rho_tof_1 = rho_tof_1(:,Delta_res/2+1:x_res  - Delta_res/2);
%rho_tof_2 = rho_tof_2(:,Delta_res/2+1:x_res  - Delta_res/2);


%create artificial image
img_rho_tof_1 = create_artificial_images(rho_tof_1, ...
                                 grid_dens, ...
                                 cloud_widths_1, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

img_rho_tof_2 = create_artificial_images(rho_tof_2, ...
                                 grid_dens, ...
                                 cloud_widths_2, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);


%Calibrating and defining grids
img_rho_tof_1 = shift_calibrate -img_rho_tof_1;
img_rho_tof_2 = shift_calibrate - img_rho_tof_2;

coarse_z_res = size(img_rho_tof_1,1);
condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);

%Coarse-graining unprocessed density interference pattern as reference
cg_rho_tof_1 = imresize(rho_tof_1, [coarse_z_res coarse_z_res]);
cg_rho_tof_2 = imresize(rho_tof_2, [coarse_z_res coarse_z_res]);


%phase extraction
extraction_suite_1 = class_phase_extraction(img_rho_tof_1', t_tof_1, width_flag);
extraction_suite_2 = class_phase_extraction(img_rho_tof_2', t_tof_2, width_flag);

extraction_suite_1_ref = class_phase_extraction(cg_rho_tof_1, t_tof_1);
extraction_suite_2_ref = class_phase_extraction(cg_rho_tof_2, t_tof_2);

ext_phase_1 = extraction_suite_1.fitting(extraction_suite_1.init_phase_guess());
ext_phase_2 = extraction_suite_2.fitting(extraction_suite_2.init_phase_guess());

ext_phase_1_ref = extraction_suite_1_ref.fitting(extraction_suite_1_ref.init_phase_guess());
ext_phase_2_ref = extraction_suite_2_ref.fitting(extraction_suite_2_ref.init_phase_guess());


%Plotting
subplot(2,3,1)
imagesc(rho_tof_1')

subplot(2,3,2)
imagesc(img_rho_tof_1)

subplot(2,3,3)
plot(coarse_grid, ext_phase_1, 'Color','red')
hold on
plot(coarse_grid, ext_phase_1_ref,'Color','blue')
plot(fine_grid, rel_phase, '--','Color', 'Black')



subplot(2,3,4)
imagesc(rho_tof_2')

subplot(2,3,5)
imagesc(img_rho_tof_2)

subplot(2,3,6)
plot(coarse_grid, ext_phase_2, 'Color','red')
hold on
plot(coarse_grid, ext_phase_2_ref,'Color','blue')
plot(fine_grid, rel_phase, '--','Color', 'Black')

colormap(gge_colormap)
