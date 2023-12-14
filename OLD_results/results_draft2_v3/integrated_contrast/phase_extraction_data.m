clear all
close all

addpath('../../input')
addpath('../../classes')
addpath('../../artificial_imaging')
addpath('../../artificial_imaging/necessary_functions')
addpath('../../artificial_imaging/utility')

load('thermal_cov_75nk.mat')


%Number of atoms
N_atoms = 10^4;
condensate_length = 100e-6;
img_res = 52; 
init_res = size(cov_phase, 1);
num_samples = 10;

t1 = 7e-3;
t2 = 15e-3;
t3 = 30e-3;


%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
grid_dens = linspace(-condensate_length/2, condensate_length/2, init_res);
shift_calibrate = 2400;

sampling_suite = class_gaussian_phase_sampling(cov_phase);
coarse_z_grid = linspace(-condensate_length/2,condensate_length/2, img_res).*1e6;

ext_phase_woc_1 = zeros(num_samples,img_res);
ext_phase_woc_2 = zeros(num_samples, img_res);
ext_phase_woc_3 = zeros(num_samples, img_res);
ext_phase_wc_1 = zeros(num_samples, img_res);
ext_phase_wc_2 = zeros(num_samples, img_res);
ext_phase_wc_3 = zeros(num_samples, img_res);
ext_phase_trans = zeros(num_samples, img_res);

ext_phase_woc_2_wp = zeros(num_samples, img_res);
ext_phase_wc_2_wp = zeros(num_samples, img_res);

rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);

cg_rel_phase = sampling_suite.coarse_grain(img_res, rel_phase);
cg_com_phase = sampling_suite.coarse_grain(img_res, com_phase);
count = 0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t2);
    interference_suite_woc_3 = class_interference_pattern(rel_phase(i,:), t3);
    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t2);
    interference_suite_wc_3 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t3);
    
    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_woc_1 = interference_suite_woc_1.normalize(rho_tof_woc_1, N_atoms);
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_woc_2 = interference_suite_woc_2.normalize(rho_tof_woc_2, N_atoms);
    rho_tof_woc_3 = interference_suite_woc_3.tof_full_expansion();
    rho_tof_woc_3 = interference_suite_woc_3.normalize(rho_tof_woc_3, N_atoms);

    rho_tof_trans = interference_suite_woc_2.tof_transversal_expansion();
    rho_tof_trans = interference_suite_woc_2.normalize(rho_tof_trans, N_atoms);
    
    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_wc_1 = interference_suite_wc_1.normalize(rho_tof_wc_1, N_atoms);
    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
    rho_tof_wc_2 = interference_suite_wc_2.normalize(rho_tof_wc_2, N_atoms);
    rho_tof_wc_3 = interference_suite_wc_3.tof_full_expansion();
    rho_tof_wc_3 = interference_suite_wc_3.normalize(rho_tof_wc_3, N_atoms);


    %Image processing only for t = 15 ms
    cloud_width_2 = interference_suite_woc_2.compute_density_sigma_t(0, t2);

    img_rho_tof_woc_2 = create_artificial_images(rho_tof_woc_2, ...
                                 grid_dens, ...
                                 cloud_width_2, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);
   
    img_rho_tof_wc_2 = create_artificial_images(rho_tof_wc_2, ...
                                 grid_dens, ...
                                 cloud_width_2, ... 
                                 imaging_intensity, ... 
                                 no_push_subdivisions, ...
                                 imaging_system, ... 
                                 shotnoise_flag, ... 
                                 recoil_flag);

    img_rho_tof_woc_2 = shift_calibrate -img_rho_tof_woc_2;
    img_rho_tof_wc_2 = shift_calibrate - img_rho_tof_wc_2;

    %Coarse graining without processing
    rho_tof_woc_1 = imresize(rho_tof_woc_1, [img_res img_res]);
    rho_tof_woc_2 = imresize(rho_tof_woc_2, [img_res img_res]);
    rho_tof_woc_3 = imresize(rho_tof_woc_3, [img_res img_res]);

    rho_tof_wc_1 = imresize(rho_tof_wc_1, [img_res img_res]);
    rho_tof_wc_2 = imresize(rho_tof_wc_2, [img_res img_res]);
    rho_tof_wc_3 = imresize(rho_tof_wc_3, [img_res img_res]);

    rho_tof_trans = imresize(rho_tof_trans, [img_res img_res]);
    
    phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t1);
    phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t2);
    phase_ext_suite_woc_3 = class_phase_extraction(rho_tof_woc_3, t3);

    phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t1);
    phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t2);
    phase_ext_suite_wc_3 = class_phase_extraction(rho_tof_wc_3, t3);

    phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t2);
    phase_ext_suite_woc_2_wp = class_phase_extraction(img_rho_tof_woc_2', t2);
    phase_ext_suite_wc_2_wp = class_phase_extraction(img_rho_tof_wc_2', t2);

    ext_phase_woc_1(i,:) = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2(i,:) = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    ext_phase_woc_3(i,:) = phase_ext_suite_woc_3.fitting(phase_ext_suite_woc_3.init_phase_guess());

    ext_phase_wc_1(i,:) = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2(i,:) = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());
    ext_phase_wc_3(i,:) = phase_ext_suite_wc_3.fitting(phase_ext_suite_wc_3.init_phase_guess());

    ext_phase_trans(i,:) = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());
    ext_phase_woc_2_wp(i,:) = phase_ext_suite_woc_2_wp.fitting(phase_ext_suite_woc_2_wp.init_phase_guess());
    ext_phase_wc_2_wp(i,:) = phase_ext_suite_wc_2_wp.fitting(phase_ext_suite_wc_2_wp.init_phase_guess());

    count = count +1;
    disp(count)
end

save('phase_extraction_bank_75nk.mat', 'rel_phase', 'com_phase', 'cg_rel_phase','cg_com_phase', 'ext_phase_woc_1', 'ext_phase_woc_2',...
    'ext_phase_woc_3', 'ext_phase_wc_1','ext_phase_wc_2', 'ext_phase_wc_3','ext_phase_trans', 'ext_phase_woc_2_wp', 'ext_phase_wc_2_wp')