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

load('ripple_rel_com_phase.mat')
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
load('fidelity_stats_vs_tof.mat')

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

tiledlayout(2,4, 'TileSpacing','compact')
nexttile

imagesc(fine_grid, fine_grid, (rho_tof_full_wc_1')*1e-12)
xticks([])
yticks([])
title('\textbf{a}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.65],'FontSize', 14);

nexttile


imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_1)
xticks([])
yticks([])

nexttile(5)
imagesc(fine_grid, fine_grid, (rho_tof_full_wc_2')*1e-12)
xticks([])
yticks([])

nexttile(6)
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc_2)
xticks([])
yticks([])

colormap(gge_colormap)
f(1) = nexttile([2 2]);
errorbar(t_tof,median_woc,iqr_woc, 'o-','Color','red');
hold on
errorbar(t_tof, median_wc, iqr_wc, 'x--','Color','red')
errorbar(t_tof,median_woc_ref,iqr_woc_ref, 'o-','Color','black')
errorbar(t_tof,median_wc_ref, iqr_wc_ref, 'x--','Color','black')
ylim([-0.6,1.1])
xlabel('$t\; (\rm ms)$', 'Interpreter','latex','FontSize',14)
ylabel('$\langle\phi^{\rm (in)}_-, \phi^{\rm (out)}_-\rangle$', 'Interpreter','latex','FontSize',14)
yticks([-0.6,-0.2,0.2,0.6,1])
xlim([5.8,16.2])
title('\textbf{b}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85],'FontSize',14);
%Inset
g(1) = axes('Position',[.73 .35 .15 .3]);
box on
plot(t_tof,median_woc,'o-','Color','red','MarkerSize', 4)
hold on
plot(t_tof,median_wc, 'x--', 'Color','red','MarkerSize',5)
plot(t_tof,median_woc_ref,'o-','Color','black','MarkerSize',4)
plot(t_tof,median_wc_ref, 'x--', 'Color','black', 'MarkerSize', 5)
ylim([0.9,0.96])
xticks([6,10,14])
xlabel('$t\; (\rm ms)$', 'Interpreter','latex','FontSize',12)
set(g(1), 'FontSize', 12,'FontName', 'Times')
set(f(1), 'FontSize', 14,'FontName', 'Times')



colormap(gge_colormap)