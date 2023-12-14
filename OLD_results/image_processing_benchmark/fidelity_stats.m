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

N_atoms = 10^4;
condensate_length = 100e-6;
t_tof = linspace(6,16,11).*1e-3;
num_samples = 200;
width_flag = 1;

%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
shift_calibrate = 2400;                     %the calibration value when there is no absorption
img_res = 52;

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles(num_samples);
com_phase = phase_sampling_suite.generate_profiles(num_samples);

fidelity_woc_stats = zeros(length(t_tof), num_samples);
fidelity_wc_stats = zeros(length(t_tof), num_samples);
fidelity_woc_stats_ref = zeros(length(t_tof), num_samples);
fidelity_wc_stats_ref = zeros(length(t_tof), num_samples);
cg_rel_phase = phase_sampling_suite.coarse_grain(img_res, rel_phase);
%initialize interference pattern class
%woc = without common phase
%wc = with common phase
outer_count  = 0;
for i = 1:length(t_tof)
    inner_count = 0;
    for j = 1:num_samples
        interference_suite_woc = class_interference_pattern(rel_phase(j,:), t_tof(i));
        interference_suite_wc = class_interference_pattern([rel_phase(j,:); com_phase(j,:)], t_tof(i));

        %initial width
        cloud_widths = interference_suite_woc.compute_density_sigma_t(0, t_tof);

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
        
        rho_tof_full_woc = rho_tof_full_woc(:,Delta_res/2+1:x_res  - Delta_res/2);
        rho_tof_full_wc = rho_tof_full_wc(:,Delta_res/2+1:x_res  - Delta_res/2);


        %create artificial image
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


        %Calibrating and defining grids
        img_rho_tof_woc = shift_calibrate -img_rho_tof_woc;
        img_rho_tof_wc = shift_calibrate - img_rho_tof_wc;

        %coarse graining without processing 
        coarse_z_res = size(img_rho_tof_woc,1);
        rho_tof_full_woc = imresize(rho_tof_full_woc, [coarse_z_res coarse_z_res]);
        rho_tof_full_wc = imresize(rho_tof_full_wc, [coarse_z_res coarse_z_res]);

        %phase extraction
        extraction_suite_woc = class_phase_extraction(img_rho_tof_woc', t_tof(i), width_flag);
        extraction_suite_wc = class_phase_extraction(img_rho_tof_wc', t_tof(i), width_flag);

        extraction_suite_woc_ref = class_phase_extraction(rho_tof_full_woc, t_tof(i), width_flag);
        extraction_suite_wc_ref = class_phase_extraction(rho_tof_full_wc, t_tof(i), width_flag);

        ext_phase_woc = extraction_suite_woc.fitting(extraction_suite_woc.init_phase_guess());
        ext_phase_wc = extraction_suite_wc.fitting(extraction_suite_wc.init_phase_guess());
        ext_phase_woc_ref = extraction_suite_woc_ref.fitting(extraction_suite_woc_ref.init_phase_guess());
        ext_phase_wc_ref = extraction_suite_wc_ref.fitting(extraction_suite_wc_ref.init_phase_guess());

        fidelity_woc_stats(i,j) = extraction_suite_woc.fidelity_coh(ext_phase_woc, cg_rel_phase(j,:));
        fidelity_wc_stats(i,j) = extraction_suite_wc.fidelity_coh(ext_phase_wc, cg_rel_phase(j,:));
        fidelity_woc_stats_ref(i,j)= extraction_suite_woc_ref.fidelity_coh(ext_phase_woc_ref, cg_rel_phase(j,:));
        fidelity_wc_stats_ref(i,j) = extraction_suite_wc_ref.fidelity_coh(ext_phase_wc_ref, cg_rel_phase(j,:));

        inner_count = inner_count +1;
        disp(inner_count)
    end
    outer_count = outer_count +1;
    disp(outer_count)
    
end
save('fidelity_coh_stats_vs_tof.mat', 'rel_phase','com_phase', 'fidelity_woc_stats_ref', ...
    'fidelity_wc_stats_ref', 'fidelity_wc_stats','fidelity_woc_stats','t_tof')