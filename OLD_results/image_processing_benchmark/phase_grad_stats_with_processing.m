clear all
close all
addpath('../input')
addpath('../classes')
addpath('../artificial_imaging')
addpath('../artificial_imaging/necessary_functions')
addpath('../artificial_imaging/utility')
load('thermal_cov_75nk.mat')


%Resolutions
z_res = size(cov_phase,1);
x_res = 1.2*z_res;
Delta_res = x_res - z_res;


condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 1e-6;
t_tof = 30e-3;
N_atoms = 10^4; 
num_samples = 200;
grid_dens = linspace(-condensate_length/2, condensate_length/2, z_res);

sampling_suite = class_gaussian_phase_sampling(cov_phase);

%Imaging setup
%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil


%Image resolution
img_res = 52;
shift_calibrate = 2400;

gradient_vec_wc_img = zeros(num_samples, img_res);
gradient_vec_woc_img = zeros(num_samples, img_res);
gradient_vec_wc = zeros(num_samples, img_res);
gradient_vec_woc = zeros(num_samples, img_res);

all_ext_phase_woc_img = zeros(num_samples, img_res);
all_ext_phase_wc_img = zeros(num_samples, img_res);
all_ext_phase_woc= zeros(num_samples, img_res);
all_ext_phase_wc = zeros(num_samples, img_res);

rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);

count = 0;
for i = 1:num_samples
    interference_suite_woc = class_interference_pattern(rel_phase(i,:), t_tof);
    interference_suite_wc = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof);
    cloud_widths = interference_suite_woc.compute_density_sigma_t(0, t_tof);
    
    rho_tof_woc = interference_suite_woc.tof_full_expansion();
    rho_tof_woc = interference_suite_woc.normalize(rho_tof_woc, N_atoms);
    rho_tof_wc = interference_suite_wc.tof_full_expansion();
    rho_tof_wc = interference_suite_wc.normalize(rho_tof_wc, N_atoms);

    %Making the image square for processing purpose
    rho_tof_woc = rho_tof_woc(:,Delta_res/2+1:x_res  - Delta_res/2);
    rho_tof_wc = rho_tof_wc(:,Delta_res/2+1:x_res  - Delta_res/2);

    %Processing the image
    img_rho_tof_woc = create_artificial_images(rho_tof_woc, ...
                                 grid_dens, ...
                                 cloud_widths, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);
    img_rho_tof_wc = create_artificial_images(rho_tof_wc, ...
                                 grid_dens, ...
                                 cloud_widths, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

    %calibrate, transpose, and resizing
    img_rho_tof_woc = shift_calibrate -img_rho_tof_woc;
    img_rho_tof_woc = img_rho_tof_woc';
    img_rho_tof_wc = shift_calibrate - img_rho_tof_wc;
    img_rho_tof_wc = img_rho_tof_wc';

    rho_tof_woc = imresize(rho_tof_woc, [img_res img_res]);
    rho_tof_wc = imresize(rho_tof_wc, [img_res img_res]);

    phase_ext_suite_woc_img = class_phase_extraction(img_rho_tof_woc, t_tof);
    phase_ext_suite_wc_img = class_phase_extraction(img_rho_tof_wc, t_tof);
    ext_phase_woc_img = phase_ext_suite_woc_img.fitting(phase_ext_suite_woc_img.init_phase_guess());
    ext_phase_wc_img = phase_ext_suite_wc_img.fitting(phase_ext_suite_wc_img.init_phase_guess());
    
    phase_ext_suite_woc = class_phase_extraction(rho_tof_woc, t_tof);
    phase_ext_suite_wc = class_phase_extraction(rho_tof_wc, t_tof);
    ext_phase_woc = phase_ext_suite_woc.fitting(phase_ext_suite_woc.init_phase_guess());
    ext_phase_wc = phase_ext_suite_wc.fitting(phase_ext_suite_wc.init_phase_guess());

    all_ext_phase_woc(i,:) = ext_phase_woc;
    all_ext_phase_wc(i,:) = ext_phase_wc;
    all_ext_phase_woc_img(i,:) = ext_phase_woc_img;
    all_ext_phase_wc_img(i,:) = ext_phase_wc_img;
    
    gradient_vec_woc(i,:) = gradient(ext_phase_woc);
    gradient_vec_wc(i,:) = gradient(ext_phase_wc);
    gradient_vec_woc_img(i,:) = gradient(ext_phase_woc_img);
    gradient_vec_wc_img(i,:) = gradient(ext_phase_wc_img);
    count = count +1;
    disp(count)
end

%Compute the correlation
corr_woc_img = class_1d_correlation(gradient_vec_woc_img);
corr_wc_img = class_1d_correlation(gradient_vec_wc_img);
cov_woc_img = corr_woc_img.covariance_matrix();
cov_wc_img = corr_wc_img.covariance_matrix();

corr_woc = class_1d_correlation(gradient_vec_woc);
corr_wc = class_1d_correlation(gradient_vec_wc);
cov_woc = corr_woc.covariance_matrix();
cov_wc = corr_wc.covariance_matrix();

save('phase_grad_stats_with_processing_25ms.mat', 'all_ext_phase_wc_img','all_ext_phase_woc_img','all_ext_phase_wc','all_ext_phase_woc',...
    'gradient_vec_woc', 'gradient_vec_wc','gradient_vec_wc_img','gradient_vec_wc_img','cov_wc', 'cov_woc')

if 0
f(1) = subplot(1,3,1);
imagesc(z_grid_coarse, z_grid_coarse, cov_in)
clim([-0.025,0.025])
ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex')
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
f(2) = subplot(1,3,2);
imagesc(z_grid_coarse, z_grid_coarse, cov1)
clim([-0.025,0.025])
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
f(3) = subplot(1,3,3);
imagesc(z_grid_coarse, z_grid_coarse, cov2)
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.09,0.01,0,-0.05];
set(get(cb,'YLabel'),'Interpreter','latex')
set(get(cb,'YLabel'),'String','$C_u(z,z^\prime)$')
set(get(cb,'YLabel'),'FontSize',10)
cb.Ruler.Exponent = -2;
clim([-0.025,0.025])
colormap(gge_colormap)
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
set(f, 'FontName', 'Times', 'FontSize', 10)
end

