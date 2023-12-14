clear all
%close all

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
t_tof = 9e-3; 

%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil

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
rho_tof_trans = interference_suite_woc.normalize(rho_tof_trans, N_atoms);

%full expansion (transversal and longitudinal)
rho_tof_full_woc = interference_suite_woc.tof_full_expansion();
rho_tof_full_woc = interference_suite_woc.normalize(rho_tof_full_woc, N_atoms);

rho_tof_full_wc = interference_suite_wc.tof_full_expansion();
rho_tof_full_wc = interference_suite_wc.normalize(rho_tof_full_wc, N_atoms);

%Making the image square for processing purpose
z_res = size(rho_tof_full_woc, 1);
x_res = size(rho_tof_full_woc, 2);
Delta_res = x_res - z_res; 
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

rho_tof_trans = rho_tof_trans(:,Delta_res/2+1:x_res  - Delta_res/2);
rho_tof_full_woc = rho_tof_full_woc(:,Delta_res/2+1:x_res  - Delta_res/2);
rho_tof_full_wc = rho_tof_full_wc(:,Delta_res/2+1:x_res  - Delta_res/2);


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
shift_calibrate = 2400;
img_rho_tof_woc = shift_calibrate -img_rho_tof_woc;
img_rho_tof_wc = shift_calibrate - img_rho_tof_wc;
img_rho_tof_trans = shift_calibrate - img_rho_tof_trans;
coarse_z_res = size(img_rho_tof_wc,1);
condensate_length = 1e6*condensate_length;
fine_grid = linspace(-condensate_length/2, condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);

figure
f(1) = subplot(2,3,1);
imagesc(fine_grid, fine_grid, (rho_tof_trans')*1e-12)
xticks([])
ylabel('$x \; (\rm \mu m)$', 'Interpreter', 'latex')
title('\textbf{a}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
clim([0,12])


f(2) = subplot(2,3,2);
imagesc(fine_grid, fine_grid, (rho_tof_full_woc')*1e-12)
xticks([])
yticks([])
title('\textbf{b}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);
clim([0,12])

f(3) = subplot(2,3,3);
imagesc(fine_grid, fine_grid, (rho_tof_full_wc')*1e-12)
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0,0,0];
set(get(cb,'YLabel'),'Interpreter','latex')
set(get(cb,'YLabel'),'String','$\rho_{\rm TOF}\; (\rm \mu m^{-2})$')
set(get(cb,'YLabel'),'FontSize',12)
xticks([])
yticks([])
title('\textbf{c}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);
clim([0,12])

f(4) = subplot(2,3,4);
imagesc(coarse_grid, coarse_grid, img_rho_tof_trans)
ylabel('$x \; (\rm \mu m)$', 'Interpreter', 'latex')
xlabel('$z\; (\rm \mu m)$', 'Interpreter', 'latex')
title('\textbf{d}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);

f(5) = subplot(2,3,5);
imagesc(coarse_grid, coarse_grid, img_rho_tof_woc)
yticks([])
xlabel('$z\; (\rm \mu m)$', 'Interpreter', 'latex')
title('\textbf{e}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

f(6) = subplot(2,3,6);
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc)
cb = colorbar(f(6),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0,0,0];
cb.Ruler.Exponent =3;
yticks([])
xlabel('$z\; (\rm \mu m)$', 'Interpreter', 'latex')
title('\textbf{f}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);

colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 12)