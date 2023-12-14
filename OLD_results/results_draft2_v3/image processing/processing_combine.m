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
t_tof_1 = 8.5e-3;
t_tof_2 = 15e-3;

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

%initial width
cloud_widths_1 = interference_suite_wc_1.compute_density_sigma_t(0, t_tof_1);
cloud_widths_2 = interference_suite_wc_2.compute_density_sigma_t(0, t_tof_2);

rho_tof_full_wc_1 = interference_suite_wc_1.tof_full_expansion();
rho_tof_full_wc_1 = interference_suite_wc_1.normalize(rho_tof_full_wc_1, N_atoms);

rho_tof_full_wc_2 = interference_suite_wc_2.tof_full_expansion();
rho_tof_full_wc_2 = interference_suite_wc_2.normalize(rho_tof_full_wc_2, N_atoms);

%Making the image square for processing purpose
z_res = size(rho_tof_full_wc_1, 1);
x_res = size(rho_tof_full_wc_1, 2);
Delta_res = x_res - z_res; 
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

rho_tof_full_wc_1 = rho_tof_full_wc_1(:,Delta_res/2+1:x_res  - Delta_res/2);
rho_tof_full_wc_2 = rho_tof_full_wc_2(:,Delta_res/2+1:x_res  - Delta_res/2);

%create artificial image
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
shift_calibrate = 2400;
img_rho_tof_wc_1 = shift_calibrate -img_rho_tof_wc_1;
img_rho_tof_wc_2 = shift_calibrate - img_rho_tof_wc_2;
coarse_z_res = size(img_rho_tof_wc_1,1);
condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);


%Fidelity stats
close all
load('fidelity_coh_stats_vs_tof.mat')

t_tof = t_tof*1e3;
median_woc = zeros(1,length(t_tof));
median_wc = zeros(1,length(t_tof));
median_woc_ref = zeros(1,length(t_tof));
median_wc_ref = zeros(1,length(t_tof));

iqr_woc = zeros(1,length(t_tof));
iqr_wc = zeros(1,length(t_tof));
iqr_woc_ref = zeros(1,length(t_tof));
iqr_wc_ref = zeros(1,length(t_tof));

for i = 1:length(t_tof)
    median_woc(i) = median(fidelity_woc_stats(i,:));
    median_wc(i) = median(fidelity_wc_stats(i,:));
    median_woc_ref(i) = median(fidelity_woc_stats_ref(i,:));
    median_wc_ref(i) = median(fidelity_wc_stats_ref(i,:));

    iqr_woc(i) = quantile(fidelity_woc_stats(i,:),0.75) - quantile(fidelity_woc_stats(i,:),0.25);
    iqr_wc(i)= quantile(fidelity_wc_stats(i,:),0.75) - quantile(fidelity_wc_stats(i,:),0.25);
    iqr_woc_ref(i) = quantile(fidelity_woc_stats_ref(i,:),0.75) - quantile(fidelity_woc_stats_ref(i,:),0.25);
    iqr_wc_ref(i) = quantile(fidelity_wc_stats_ref(i,:),0.75) - quantile(fidelity_wc_stats_ref(i,:),0.25);
end

%Plotting
f = tight_subplot(2,2,[.04 .04],[.05 .05],[.05 .05]);
axes(f(1))
imagesc(fine_grid, fine_grid, (rho_tof_full_wc_1')*1e-12)
xticks([])
yticks([])
title('\textbf{a}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(2))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_1)
xticks([])
yticks([])
title('\textbf{b}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

axes(f(3))
imagesc(fine_grid, fine_grid, (rho_tof_full_wc_2')*1e-12)
title('\textbf{c}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
yticks([])
xticks([])

axes(f(4))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_2)
yticks([])
xticks([])
title('\textbf{d}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

colormap(gge_colormap)
set(f, 'FontName', 'Times','FontSize', 18)