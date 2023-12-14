clear all
close all

%Adding directories and loading example phase profile containing a variable
%phase_profile_RS
%First (second) row of phase_profile_RS is interpreted to be relative (common) phase
addpath('../../classes')
addpath('../../input')
addpath('../../artificial_imaging')
addpath('../../artificial_imaging/necessary_functions')
addpath('../../artificial_imaging/utility')
load('thermal_cov_75nk.mat')

%Number of atoms
N_atoms = 10^4;
condensate_length = 100e-6;
t_tof_1 = 5e-3;
t_tof_2 = 7e-3;
t_tof_3 = 8.3e-3;
t_tof_4 = 10e-3;


%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil

load('example_phase.mat')
%phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
%rel_phase = phase_sampling_suite.generate_profiles();
%com_phase = phase_sampling_suite.generate_profiles();

%initialize interference pattern class
%woc = without common phase
%wc = with common phase
interference_suite_wc_1 = class_interference_pattern([rel_phase; com_phase], t_tof_1);
interference_suite_wc_2 = class_interference_pattern([rel_phase; com_phase], t_tof_2);
interference_suite_wc_3 = class_interference_pattern([rel_phase; com_phase], t_tof_3);
interference_suite_wc_4 = class_interference_pattern([rel_phase; com_phase], t_tof_4);

%initial width
cloud_widths_1 = interference_suite_wc_1.compute_density_sigma_t(0, t_tof_1);
cloud_widths_2 = interference_suite_wc_2.compute_density_sigma_t(0, t_tof_2);
cloud_widths_3 = interference_suite_wc_3.compute_density_sigma_t(0, t_tof_3);
cloud_widths_4 = interference_suite_wc_2.compute_density_sigma_t(0, t_tof_4);

rho_tof_full_wc_1 = interference_suite_wc_1.tof_full_expansion();
rho_tof_full_wc_2 = interference_suite_wc_2.tof_full_expansion();
rho_tof_full_wc_3 = interference_suite_wc_3.tof_full_expansion();
rho_tof_full_wc_4 = interference_suite_wc_4.tof_full_expansion();

%create artificial image
%Make sure that the original image (before processing) is square for
%processing purpose
%Making the image square for processing purpose
z_res = size(rho_tof_full_wc_1, 1);
x_res = size(rho_tof_full_wc_1, 2);
Delta_res = x_res - z_res; 
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

rho_tof_full_wc_1 = rho_tof_full_wc_1(:,Delta_res/2+1:x_res  - Delta_res/2);
rho_tof_full_wc_2 = rho_tof_full_wc_2(:,Delta_res/2+1:x_res  - Delta_res/2);
rho_tof_full_wc_3 = rho_tof_full_wc_3(:,Delta_res/2+1:x_res  - Delta_res/2);
rho_tof_full_wc_4 = rho_tof_full_wc_4(:,Delta_res/2+1:x_res  - Delta_res/2);

%Simulate image processing
img_rho_tof_wc_1 = create_artificial_images(rho_tof_full_wc_1, ...
                                 grid_dens, ...
                                 cloud_widths_1, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

img_rho_tof_wc_2 = create_artificial_images(rho_tof_full_wc_2, ...
                                 grid_dens, ...
                                 cloud_widths_2, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

img_rho_tof_wc_3 = create_artificial_images(rho_tof_full_wc_3, ...
                                 grid_dens, ...
                                 cloud_widths_3, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

img_rho_tof_wc_4 = create_artificial_images(rho_tof_full_wc_4, ...
                                 grid_dens, ...
                                 cloud_widths_4, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

shift_calibrate = 2400;
img_rho_tof_wc_1 = shift_calibrate - img_rho_tof_wc_1;
img_rho_tof_wc_2 = shift_calibrate - img_rho_tof_wc_2;
img_rho_tof_wc_3 = shift_calibrate - img_rho_tof_wc_3;
img_rho_tof_wc_4 = shift_calibrate - img_rho_tof_wc_4;

coarse_z_res = size(img_rho_tof_wc_1,1);
condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);

%Plotting
f = tight_subplot(2,4,[.04 .02],[.04 .04],[.04 .04]);
axes(f(1))
imagesc(fine_grid, fine_grid, (rho_tof_full_wc_1')*1e-12)
xticks([])
yticks([])
title('\textbf{a}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(2))
imagesc(fine_grid, fine_grid,(rho_tof_full_wc_2')*1e-12)
xticks([])
yticks([])
title('\textbf{b}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(3))
imagesc(fine_grid, fine_grid, (rho_tof_full_wc_3')*1e-12)
title('\textbf{c}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
yticks([])
xticks([])

axes(f(4))
imagesc(coarse_grid, coarse_grid, (rho_tof_full_wc_4')*1e-12)
yticks([])
xticks([])
title('\textbf{d}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(5))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_1)
xticks([])
yticks([])
title('\textbf{e}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(6))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_2)
xticks([])
yticks([])
title('\textbf{f}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(7))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_3)
title('\textbf{g}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
yticks([])
xticks([])

axes(f(8))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_4)
yticks([])
xticks([])
title('\textbf{h}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);


colormap(gge_colormap)
set(f, 'FontName', 'Times','FontSize', 18)