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
num_samples = 200;
t_tof = linspace(7,31,9)*1e-3;

%Imaging setup
imaging_intensity   = 0.25*16.6933;         % use 25% of saturation intensity
no_push_subdivisions= 20;                   % number of discretization steps in push simulation
imaging_system      = 'VAndor';             % string specifying the imaging system being simulated
shotnoise_flag      = true;                 % if true, account for photonic shotnoise
recoil_flag         = true;                 % if true, account for photon emmision recoil
shift_calibrate = 2400;                     %the calibration value when there is no absorption
img_res = 52;                               %number of pixels after processing
ref_res = 101;                              %ref refers to unprocessed image - we made it to be 101 so that TOF simulation is faster

n = 10; %n for the wavenumber k = 2 pi (n-1)/L

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles(num_samples);
com_phase = phase_sampling_suite.generate_profiles(num_samples);

%Input resolution and Fourier statistics
input_res = size(rel_phase,2);              %input resolution      
input_fft = zeros(1,num_samples);
for i = 1:num_samples
    fourier = abs(fft(rel_phase(i,:))/input_res).^2;
    input_fft(i) = fourier(n);
end

mean_amp_input = mean(input_fft);
%initialize interference pattern class
%woc = without common phase
%wc = with common phase

mean_amp_woc = zeros(1,length(t_tof));
mean_amp_wc = zeros(1,length(t_tof));
mean_amp_woc_ref = zeros(1,length(t_tof));
mean_amp_wc_ref = zeros(1,length(t_tof));

outer = "----------------------------------------";
for j = 1:length(t_tof)
    amp_woc = zeros(1,num_samples);
    amp_wc = zeros(1,num_samples);
    amp_woc_ref = zeros(1,num_samples);
    amp_wc_ref = zeros(1,num_samples);
    count = 0;
    for i = 1:num_samples
        %Input samples fft coefficients
        %amp_fft_input(i,:) = abs(fft(rel_phase(i,:))/input_res).^2;

        %TOF reconstruction
        interference_suite_woc = class_interference_pattern(rel_phase(i,:), t_tof(j));
        interference_suite_wc = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof(j));

        %initial width
        cloud_widths = interference_suite_woc.compute_density_sigma_t(0, t_tof(j));

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

        %rho tof without processing for reference
        rho_tof_full_woc = imresize(rho_tof_full_woc, [ref_res ref_res]);
        rho_tof_full_wc = imresize(rho_tof_full_wc, [ref_res ref_res]);

        %phase extraction
        extraction_suite_woc = class_phase_extraction(img_rho_tof_woc', t_tof(j));
        extraction_suite_wc = class_phase_extraction(img_rho_tof_wc', t_tof(j));
        extraction_suite_woc_ref = class_phase_extraction(rho_tof_full_woc, t_tof(j));
        extraction_suite_wc_ref = class_phase_extraction(rho_tof_full_wc, t_tof(j));

        ext_phase_woc = extraction_suite_woc.fitting(extraction_suite_woc.init_phase_guess());
        ext_phase_wc = extraction_suite_wc.fitting(extraction_suite_wc.init_phase_guess()); 
        ext_phase_woc_ref = extraction_suite_woc_ref.fitting(extraction_suite_woc_ref.init_phase_guess());
        ext_phase_wc_ref = extraction_suite_wc_ref.fitting(extraction_suite_wc_ref.init_phase_guess());

        amp_fft_woc = abs(fft(ext_phase_woc)/img_res).^2;
        amp_fft_wc = abs(fft(ext_phase_wc)/img_res).^2;
        amp_fft_woc_ref = abs(fft(ext_phase_woc_ref)/ref_res).^2;
        amp_fft_wc_ref = abs(fft(ext_phase_wc_ref)/ref_res).^2;

        amp_woc(i) = amp_fft_woc(n);
        amp_wc(i) = amp_fft_wc(n);
        amp_woc_ref(i) = amp_fft_woc_ref(n);
        amp_wc_ref(i) = amp_fft_wc_ref(n);
        count = count +1;
        disp(count)
    end
    mean_amp_woc(j) = mean(amp_woc);
    mean_amp_wc(j) = mean(amp_wc);
    mean_amp_woc_ref(j) = mean(amp_woc_ref);
    mean_amp_wc_ref(j) = mean(amp_wc_ref);
    disp(outer)
end

mean_fourier_amp_woc = zeros(1,img_res/2);
mean_fourier_amp_wc = zeros(1, img_res/2);
mean_fourier_amp_woc_ref = zeros(1,img_res/2);
mean_fourier_amp_wc_ref = zeros(1, img_res/2);
mean_fourier_amp_input = zeros(1,img_res/2);

for i = 1:img_res/2
    mean_fourier_amp_woc(i) = mean(amp_fft_woc(:,i));
    mean_fourier_amp_wc(i) = mean(amp_fft_wc(:,i));
    mean_fourier_amp_woc_ref(i) = mean(amp_fft_woc_ref(:,i));
    mean_fourier_amp_wc_ref(i) = mean(amp_fft_wc_ref(:,i));
end

%save('fft_stats_50nk_15ms.mat', 'mean_fourier_amp_wc_ref', 'amp_fft_wc_ref', 'mean_fourier_amp_woc_ref', 'mean_fourier_amp_woc', 'mean_fourier_amp_wc','amp_fft_woc', 'amp_fft_wc')
%save('fft_stats_input', 'rel_phase', 'com_phase','amp_fft_input', 'mean_fourier_amp_input')