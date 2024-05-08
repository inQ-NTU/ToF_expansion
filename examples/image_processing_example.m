%This is a script to show how image processing after TOF works
%Image processing here refers to the simulation of experimental imaging
%devices
clear all
close all

addpath('../classes')
addpath('../input')
addpath('../imaging_effect')
addpath('../imaging_effect/utility')
addpath('../imaging_effect/image_analysis')
addpath('../imaging_effect/artificial_imaging')
addpath('../imaging_effect/artificial_imaging/necessary_functions')

load('thermal_cov_60nk.mat')
z_res = size(cov_phase, 1);
t_tof = 15e-3; 
condensate_length = 100e-6; %100 microns gas

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles();
com_phase = phase_sampling_suite.generate_profiles();

grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);     

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

%create artificial image
%The input has to be transposed (longitudinal = horizontal) before being passed to absorption imaging
%function, otherwise the coherent transfer function is applied in the wrong
%direction
img_rho_tof_trans = absorption_imaging(rho_tof_trans', grid_dens, cloud_widths);
img_rho_tof_woc = absorption_imaging(rho_tof_full_woc', grid_dens, cloud_widths);
img_rho_tof_wc = absorption_imaging(rho_tof_full_wc', grid_dens, cloud_widths);

coarse_z_res = size(img_rho_tof_wc,1);

condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);

figure
f(1) = subplot(2,3,1);
imagesc(fine_grid, fine_grid, rho_tof_trans) 
colorbar

f(2) = subplot(2,3,2);
imagesc(fine_grid, fine_grid, rho_tof_full_woc)
colorbar

f(3) = subplot(2,3,3);
imagesc(fine_grid, fine_grid, rho_tof_full_wc)
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