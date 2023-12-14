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
load('EXAMPLE_phase_profile.mat')
load('thermal_cov_75nk.mat')

%Number of atoms
N_atoms = 10^4;
condensate_length = 100e-6;
t_tof = 15e-3; 

%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
shift_calibrate = 2400;                     %the calibration value when there is no absorption

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles();

interference_suite = class_interference_pattern(rel_phase, t_tof);

%initial width
cloud_widths = interference_suite.compute_density_sigma_t(0, t_tof);

%full expansion (transversal and longitudinal)
rho_tof = interference_suite.tof_full_expansion();
rho_tof = interference_suite.normalize(rho_tof, N_atoms);

%Making the image square for processing purpose
z_res = size(rho_tof, 1);
x_res = size(rho_tof, 2);
Delta_res = x_res - z_res; 
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

rho_tof = rho_tof(:,Delta_res/2+1:x_res  - Delta_res/2);


%create artificial image
img_rho_tof = create_artificial_images(rho_tof, ...
                                 grid_dens, ...
                                 cloud_widths, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

%Calibrating and defining grids
img_rho_tof = shift_calibrate -img_rho_tof;
coarse_z_res = size(img_rho_tof,1);
condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);

%coarse graining without image processing for comparison
rho_tof = imresize(rho_tof, [coarse_z_res coarse_z_res]);


%phase extraction
extraction_suite_proc = class_phase_extraction(img_rho_tof', t_tof);
extraction_suite = class_phase_extraction(rho_tof, t_tof);

ext_phase_proc = extraction_suite_proc.fitting(extraction_suite_proc.init_phase_guess());
ext_phase = extraction_suite.fitting(extraction_suite.init_phase_guess());

amp_proc = extraction_suite_proc.normalization_amplitudes;
amp = extraction_suite.normalization_amplitudes;

contr_proc = extraction_suite_proc.contrasts;
contr = extraction_suite.contrasts;

%Plotting
figure
plot(coarse_grid, ext_phase_proc)
hold on
plot(coarse_grid, ext_phase)
plot(fine_grid, rel_phase)


figure
yyaxis left
plot(coarse_grid, amp_proc)
yyaxis right
plot(coarse_grid, amp)

figure
plot(coarse_grid, contr_proc)
hold on
plot(coarse_grid, contr)

