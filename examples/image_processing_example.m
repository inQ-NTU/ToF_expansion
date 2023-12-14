%This is a script to show how image processing after TOF works
%Image processing here refers to the simulation of experimental imaging
%devices
clear all
close all

addpath('../classes')
addpath('../input')
addpath('../artificial_imaging')
addpath('../artificial_imaging/necessary_functions')
addpath('../artificial_imaging/utility')
load('thermal_cov_60nk.mat')

t_tof = 15e-3; 
condensate_length = 100e-6; %100 microns gas

%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
shift_calibrate = 2400;

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles();
com_phase = phase_sampling_suite.generate_profiles();

%initialize interference pattern class
%woc = without common phase
%wc = with common phase
interference_suite_woc = class_interference_pattern(rel_phase, t_tof);
interference_suite_wc = class_interference_pattern([rel_phase; com_phase], t_tof);

%initial width
cloud_widths = interference_suite_woc.compute_density_sigma_t(0, t_tof);

%transversal expansion
rho_tof_trans = interference_suite_woc.tof_transversal_expansion();

%full expansion (transversal and longitudinal)
rho_tof_full_woc = interference_suite_woc.tof_full_expansion();

rho_tof_full_wc = interference_suite_wc.tof_full_expansion();

%Making the image square for processing purpose
z_res = size(rho_tof_full_woc, 1);
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

%create artificial image
img_rho_tof_trans = create_artificial_images(rho_tof_trans, ...
                                 grid_dens, ...
                                 cloud_widths, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

img_rho_tof_woc = create_artificial_images(rho_tof_full_woc, ...
                                 grid_dens, ...
                                 cloud_widths, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

img_rho_tof_wc = create_artificial_images(rho_tof_full_wc, ...
                                 grid_dens, ...
                                 cloud_widths, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

img_rho_tof_woc = shift_calibrate -img_rho_tof_woc;
img_rho_tof_wc = shift_calibrate - img_rho_tof_wc;
img_rho_tof_trans = shift_calibrate - img_rho_tof_trans;
coarse_z_res = size(img_rho_tof_wc,1);

condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);

figure
f(1) = subplot(2,3,1);
imagesc(fine_grid, fine_grid, rho_tof_trans')
colorbar

f(2) = subplot(2,3,2);
imagesc(fine_grid, fine_grid, rho_tof_full_woc')
colorbar

f(3) = subplot(2,3,3);
imagesc(fine_grid, fine_grid, rho_tof_full_wc')
colorbar

f(4) = subplot(2,3,4);
imagesc(coarse_grid, coarse_grid, img_rho_tof_trans)
colorbar

f(5) = subplot(2,3,5);
imagesc(coarse_grid, coarse_grid, img_rho_tof_woc)
colorbar

f(6) = subplot(2,3,6);
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc)
colorbar

colormap(gge_colormap)