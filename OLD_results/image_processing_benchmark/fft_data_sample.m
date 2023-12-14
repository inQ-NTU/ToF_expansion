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
load('thermal_cov_50nk.mat')
cov_phase = cov_phase_fine;

%Number of atoms
N_atoms = 10^4;
condensate_length = 100e-6;
t_tof = 15e-3;
num_samples = 100;

%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
shift_calibrate = 2400;                     %the calibration value when there is no absorption
img_res = 52;
fine_res = 100;

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles(num_samples);
com_phase = phase_sampling_suite.generate_profiles(num_samples);

%initialize interference pattern class
%woc = without common phase
%wc = with common phase

amp_fft_trans = zeros(num_samples, fine_res);
amp_fft_woc = zeros(num_samples, img_res);
amp_fft_wc = zeros(num_samples, img_res);
amp_fft_woc_ref = zeros(num_samples, fine_res);
amp_fft_wc_ref = zeros(num_samples, fine_res);
count = 0;
for i = 1:num_samples
    interference_suite_woc = class_interference_pattern(rel_phase(i,:), t_tof);
    interference_suite_wc = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof);

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

    %rho tof without processing for reference
    rho_tof_full_woc = imresize(rho_tof_full_woc, [fine_res fine_res]);
    rho_tof_full_wc = imresize(rho_tof_full_wc, [fine_res fine_res]);
    rho_tof_trans = imresize(rho_tof_trans, [fine_res fine_res]);


    %phase extraction
    extraction_suite_woc = class_phase_extraction(img_rho_tof_woc', t_tof);
    extraction_suite_wc = class_phase_extraction(img_rho_tof_wc', t_tof);
    extraction_suite_trans = class_phase_extraction(rho_tof_trans, t_tof);
    extraction_suite_woc_ref = class_phase_extraction(rho_tof_full_woc, t_tof);
    extraction_suite_wc_ref = class_phase_extraction(rho_tof_full_wc, t_tof);
    

    ext_phase_woc = extraction_suite_woc.fitting(extraction_suite_woc.init_phase_guess());
    ext_phase_wc = extraction_suite_wc.fitting(extraction_suite_wc.init_phase_guess());
    ext_phase_trans = extraction_suite_trans.fitting(extraction_suite_trans.init_phase_guess());
    ext_phase_woc_ref = extraction_suite_woc_ref.fitting(extraction_suite_woc_ref.init_phase_guess());
    ext_phase_wc_ref = extraction_suite_wc_ref.fitting(extraction_suite_wc_ref.init_phase_guess());

    amp_fft_trans(i,:) = abs(fft(ext_phase_trans)/fine_res).^2;
    amp_fft_woc(i,:) = abs(fft(ext_phase_woc)/img_res).^2;
    amp_fft_wc(i,:) = abs(fft(ext_phase_wc)/img_res).^2;
    amp_fft_woc_ref(i,:) = abs(fft(ext_phase_woc_ref)/fine_res).^2;
    amp_fft_wc_ref(i,:) = abs(fft(ext_phase_wc_ref)/fine_res).^2;
    count = count +1;
    disp(count)
end

mean_fourier_amp_trans = zeros(1,fine_res);
mean_fourier_amp_woc = zeros(1,img_res);
mean_fourier_amp_wc = zeros(1, img_res);
mean_fourier_amp_woc_ref = zeros(1,fine_res);
mean_fourier_amp_wc_ref = zeros(1, fine_res);

for i = 1:img_res
    mean_fourier_amp_trans(i) = mean(amp_fft_trans(:,i));
    mean_fourier_amp_woc(i) = mean(amp_fft_woc(:,i));
    mean_fourier_amp_wc(i) = mean(amp_fft_wc(:,i));
    mean_fourier_amp_woc_ref(i) = mean(amp_fft_woc_ref(:,i));
    mean_fourier_amp_wc_ref(i) = mean(amp_fft_wc_ref(:,i));

end

%save('fft_stats_50nk_15ms.mat', 'mean_fourier_amp_wc', 'mean_fourier_amp_woc', 'mean_fourier_amp_trans', 'amp_fft_wc',...
%'amp_fft_woc', 'amp_fft_trans')

%save('fft_input_sample.mat', 'rel_phase', 'com_phase')
