clear all
close all
addpath('../../input')
addpath('../../classes')
load('thermal_cov_75nk.mat')
%cov_phase = cov_phase_fine;
condensate_length = 100e-6; 
pixel_width = 1e-6;
pixnumz = floor(condensate_length/pixel_width);
z_grid = linspace(-condensate_length/2, condensate_length/2, pixnumz);

pixnumz = floor(condensate_length/pixel_width);
num_samples = 200;

t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 20e-3;

%Generate samples
sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);

rel_phase = sampling_suite.coarse_grain(pixnumz, rel_phase);
com_phase = sampling_suite.coarse_grain(pixnumz, com_phase);

ext_phase_woc_1_all = zeros(num_samples, pixnumz);
ext_phase_woc_2_all = zeros(num_samples, pixnumz);
ext_phase_woc_3_all = zeros(num_samples, pixnumz);

ext_phase_wc_1_all = zeros(num_samples, pixnumz);
ext_phase_wc_2_all = zeros(num_samples, pixnumz);
ext_phase_wc_3_all = zeros(num_samples, pixnumz);

ext_phase_trans_all = zeros(num_samples, pixnumz);

%Fourier amplitude
fourier_amp_woc_1 = zeros(num_samples, pixnumz);
fourier_amp_woc_2 = zeros(num_samples, pixnumz);
fourier_amp_woc_3 = zeros(num_samples, pixnumz);

fourier_amp_wc_1 = zeros(num_samples, pixnumz);
fourier_amp_wc_2 = zeros(num_samples, pixnumz);
fourier_amp_wc_3 = zeros(num_samples, pixnumz);

fourier_amp_in = zeros(num_samples, pixnumz);
fourier_amp_trans = zeros(num_samples, pixnumz);

count = 0;
for i = 1:num_samples
    
    %full expansion without common phase
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t_tof_2);
    interference_suite_woc_3 = class_interference_pattern(rel_phase(i,:), t_tof_3);
    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_woc_3 = interference_suite_woc_3.tof_full_expansion();

    phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
    phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
    phase_ext_suite_woc_3 = class_phase_extraction(rho_tof_woc_3, t_tof_3);
    ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    ext_phase_woc_3 = phase_ext_suite_woc_3.fitting(phase_ext_suite_woc_3.init_phase_guess());
    
    %transversal expansion
    rho_tof_trans = interference_suite_woc_1.tof_transversal_expansion();
    phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t_tof_1);
    ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());
    
    %full expansion with common phase
    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    interference_suite_wc_3 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_3);
    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
    rho_tof_wc_3 = interference_suite_wc_3.tof_full_expansion();
    phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
    phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);
    phase_ext_suite_wc_3 = class_phase_extraction(rho_tof_wc_3, t_tof_3);
    ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());
    ext_phase_wc_3 = phase_ext_suite_wc_3.fitting(phase_ext_suite_wc_3.init_phase_guess());
    
    %Saving the extracted phase
    ext_phase_woc_1_all(i,:) = ext_phase_woc_1;
    ext_phase_woc_2_all(i,:) = ext_phase_woc_2;
    ext_phase_woc_3_all(i,:) = ext_phase_woc_3;
    ext_phase_wc_1_all(i,:) = ext_phase_wc_1;
    ext_phase_wc_2_all(i,:) = ext_phase_wc_2;
    ext_phase_wc_3_all(i,:) = ext_phase_wc_3;
    ext_phase_trans_all(i,:) = ext_phase_trans;
    %Compute the fourier coefficient
    fourier_amp_woc_1(i,:) = abs(fft(ext_phase_woc_1)/pixnumz).^2;
    fourier_amp_woc_2(i,:) = abs(fft(ext_phase_woc_2)/pixnumz).^2;
    fourier_amp_woc_3(i,:) = abs(fft(ext_phase_woc_3)/pixnumz).^2;
    fourier_amp_wc_1(i,:) = abs(fft(ext_phase_wc_1)/pixnumz).^2;
    fourier_amp_wc_2(i,:) = abs(fft(ext_phase_wc_2)/pixnumz).^2;
    fourier_amp_wc_3(i,:) = abs(fft(ext_phase_wc_3)/pixnumz).^2;
    fourier_amp_in(i,:) = abs(fft(rel_phase(i,:))/pixnumz).^2;
    fourier_amp_trans(i,:) = abs(fft(ext_phase_trans)/pixnumz).^2;
    count = count+1;
    disp(count)
end

%save('phase_extraction_and_fourier_spectrum_75nK_200samples.mat', 'rel_phase', 'com_phase', 'cg_rel_phase', 'ext_phase_woc_1_all', 'ext_phase_woc_2_all', 'ext_phase_woc_3_all',...
%    'ext_phase_wc_1_all', 'ext_phase_wc_2_all', 'ext_phase_wc_3_all', 'fourier_amp_in', 'fourier_amp_woc_1', 'fourier_amp_woc_2', 'fourier_amp_woc_3',...
%    'fourier_amp_wc_1', 'fourier_amp_wc_2', 'fourier_amp_wc_3', 'fourier_amp_trans','ext_phase_trans_all')