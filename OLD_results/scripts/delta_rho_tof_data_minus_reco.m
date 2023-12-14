addpath('../classes')
addpath('../input')
%addpath('Data/')
load('thermal_cov_50nk.mat')
%Defining some parameters
coarse_dim =50;
z=linspace(0,100,coarse_dim);
%sampling relative and common phase 
%initiate gaussian phase sampling class
%phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
%phase_samples = phase_sampling_suite.generate_profiles(2);
%phase_samples = -pi+2*pi*z/100;
phase_samples = pi*cos(3*pi*z/100);
%phase_samples = zeros(2,coarse_dim);
%coarse graining
%phase_samples = phase_sampling_suite.coarse_grain(phase_samples, coarse_dim);

%generate interference pattern
interference_suite = class_interference_pattern(phase_samples);
rho_tof_full = interference_suite.tof_full_expansion();
rho_tof_trans = interference_suite.tof_transversal_expansion();

%start extraction proces
extraction_suite_full = class_phase_extraction(rho_tof_full);
extraction_suite_trans = class_phase_extraction(rho_tof_trans);

phase_full = extraction_suite_full.fitting(extraction_suite_full.init_phase_guess);
phase_trans = extraction_suite_trans.fitting(extraction_suite_trans.init_phase_guess);

%Reconstructing the interference pattern and calculating the marginals
reco_tof_full = extraction_suite_full.reconstructed_interference_pattern;
reco_tof_trans = extraction_suite_trans.reconstructed_interference_pattern;
residue_tof_full = (rho_tof_full - reco_tof_full);
residue_tof_trans = (rho_tof_trans - reco_tof_trans);

%Drawing the figures
z_grid = linspace(0,100,size(rho_tof_full,1));
x_grid = linspace(-60,60, size(rho_tof_full,2));
fontname = 'Times';
fontsize = 16; 

p = figure;
f(1) = subplot(2,3,1);
imagesc(x_grid, z_grid, rho_tof_full)
colorbar
title('Input Full')

f(2) = subplot(2,3,2);
imagesc(x_grid, z_grid, reco_tof_full)
colorbar
title('Reconstructed Full')

f(3) = subplot(2,3,3);
imagesc(x_grid, z_grid, residue_tof_full)
colorbar
title('Residue Full')
colormap(gge_colormap)

f(4) = subplot(2,3,4);
imagesc(x_grid, z_grid, rho_tof_trans)
colorbar
title('Input Transverse')

f(5) = subplot(2,3,5);
imagesc(x_grid, z_grid, reco_tof_trans)
colorbar
title('Reconstructed Transverse')

f(6) = subplot(2,3,6);
imagesc(x_grid, z_grid, residue_tof_trans)
colorbar
title('Residue Transverse')
colormap(gge_colormap)


