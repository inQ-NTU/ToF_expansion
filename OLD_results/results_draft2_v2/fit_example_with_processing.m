clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')
addpath('../artificial_imaging')
addpath('../artificial_imaging/necessary_functions')
addpath('../artificial_imaging/utility')

condensate_length = 100e-6;
transversal_length = 120e-6; 
num_atoms = 10^4;

%Imaging setup
%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil

%sampling suite is used only to coarse-grain (cg_rel_phase)-> inefficient
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);

z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;

n_rel = 4;
n_com = 6;

rel_phase = pi*cos(n_rel*pi*z_grid/(condensate_length.*1e6));
com_phase = pi*cos(n_com*pi*z_grid/(condensate_length.*1e6));
t_tof =15e-3;

interference_suite_woc = class_interference_pattern(rel_phase, t_tof);
interference_suite_wc = class_interference_pattern([rel_phase; com_phase], t_tof);

%cloud widths
cloud_widths = interference_suite_woc.compute_density_sigma_t(0, t_tof);

%Simulating TOF
rho_tof_full_wc = interference_suite_wc.tof_full_expansion();
rho_tof_full_wc = interference_suite_wc.normalize(rho_tof_full_wc, num_atoms);

rho_tof_full_woc = interference_suite_woc.tof_full_expansion();
rho_tof_full_woc = interference_suite_woc.normalize(rho_tof_full_woc, num_atoms);

rho_tof_trans = interference_suite_woc.tof_transversal_expansion();
rho_tof_trans = interference_suite_woc.normalize(rho_tof_trans, num_atoms);

%Making the image square
z_res = size(rho_tof_full_woc, 1);
x_res = size(rho_tof_full_woc, 2);
Delta_res = x_res - z_res; 

rho_tof_trans = rho_tof_trans(:,Delta_res/2+1:x_res  - Delta_res/2);
rho_tof_full_woc = rho_tof_full_woc(:,Delta_res/2+1:x_res  - Delta_res/2);
rho_tof_full_wc = rho_tof_full_wc(:,Delta_res/2+1:x_res  - Delta_res/2);

%artificial imaging
grid_dens = z_grid*1e-6;
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

%coarse graining image without processing for comparison
coarse_resolution_z = size(img_rho_tof_trans,1);
rho_tof_full_woc = imresize(rho_tof_full_woc, [coarse_resolution_z coarse_resolution_z]);
rho_tof_full_wc = imresize(rho_tof_full_wc, [coarse_resolution_z coarse_resolution_z]);
rho_tof_trans = imresize(rho_tof_trans, [coarse_resolution_z coarse_resolution_z]);

%Calibrating and defining output grids
shift_calibrate = 2400;
img_rho_tof_woc = shift_calibrate -img_rho_tof_woc;
img_rho_tof_wc = shift_calibrate - img_rho_tof_wc;
img_rho_tof_trans = shift_calibrate - img_rho_tof_trans;
coarse_z_res = size(img_rho_tof_wc,1);
condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);


%coarse graining input
cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase); 


%phase extraction process without processing
phase_ext_suite_woc = class_phase_extraction(rho_tof_full_woc, t_tof);
phase_ext_suite_wc = class_phase_extraction(rho_tof_full_wc, t_tof);
phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t_tof);

ext_phase_woc_0 = phase_ext_suite_woc.fitting(phase_ext_suite_woc.init_phase_guess());
ext_phase_wc_0 = phase_ext_suite_wc.fitting(phase_ext_suite_wc.init_phase_guess());
ext_phase_trans_0 = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());

%phase extraction process - with processing
phase_ext_suite_woc = class_phase_extraction(img_rho_tof_woc', t_tof);
phase_ext_suite_wc = class_phase_extraction(img_rho_tof_wc', t_tof);
phase_ext_suite_trans = class_phase_extraction(img_rho_tof_trans', t_tof);

ext_phase_woc = phase_ext_suite_woc.fitting(phase_ext_suite_woc.init_phase_guess());
ext_phase_wc = phase_ext_suite_wc.fitting(phase_ext_suite_wc.init_phase_guess());
ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());

%Fitting residue
l= condensate_length*1e6;
residue_trans = ext_phase_trans - cg_rel_phase;
residue_wc = ext_phase_wc - cg_rel_phase - residue_trans;
residue_woc = ext_phase_woc - cg_rel_phase - residue_trans;

residue_trans_0 = ext_phase_trans_0 - cg_rel_phase;
residue_wc_0 = ext_phase_wc_0 - cg_rel_phase - residue_trans_0;
residue_woc_0 = ext_phase_woc_0 - cg_rel_phase - residue_trans_0;

%Plotting
f(1) = subplot(2,2,1);
plot(z_grid, rel_phase)
hold on
plot(coarse_grid, ext_phase_wc, 'o')
plot(coarse_grid, ext_phase_wc_0, 'x')
plot(z_grid, com_phase, '--')

f(2) = subplot(2,2,2);
plot(coarse_grid, residue_wc, '-o')
hold on
plot(coarse_grid, residue_wc_0, '-x')

f(3) = subplot(2,2,3);
plot(z_grid, rel_phase)
hold on
plot(coarse_grid, ext_phase_woc, 'o')
plot(z_grid, zeros(1,longitudinal_resolution), '--')

f(3) = subplot(2,2,4);
plot(coarse_grid, residue_woc, '-o')
hold on
plot(coarse_grid, residue_woc_0, '-x')


