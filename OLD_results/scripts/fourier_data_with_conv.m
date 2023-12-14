close all
clear all

%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_25nk.mat')

%generate sample and coarse-graining it
coarse_dim = 100;
nmb_sampled_phases = 100;
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3;

%if 0
%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase_profiles = phase_sampling_suite.generate_profiles(nmb_sampled_phases);
coarse_rel_profiles = phase_sampling_suite.coarse_grain(coarse_dim, rel_phase_profiles);

all_input_fourier = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_out_fourier_1 = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_out_fourier_2 = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_out_fourier_3 = zeros(nmb_sampled_phases, coarse_dim/2+1);
count = 0;
for i = 1:nmb_sampled_phases
    %Compute input fourier spectrum
    fourier_input = abs(fft(coarse_rel_profiles(i,:))/sqrt(coarse_dim));
    fourier_input = fourier_input(1:coarse_dim/2+1);% Single sampling plot
    all_input_fourier(i,:) = fourier_input;

    interference_suite_1 = class_interference_pattern(rel_phase_profiles(i,:), t_tof_1);
    interference_suite_2 = class_interference_pattern(rel_phase_profiles(i,:), t_tof_2);
    interference_suite_3 = class_interference_pattern(rel_phase_profiles(i,:), t_tof_3);

    rho_tof_full_1 = interference_suite_1.tof_full_expansion();
    rho_tof_full_1 = imresize(rho_tof_full_1, [coarse_dim, 1.2*coarse_dim]);
    rho_tof_full_1 = interference_suite_1.convolution2d(rho_tof_full_1);

    rho_tof_full_2 = interference_suite_2.tof_full_expansion();
    rho_tof_full_2 = imresize(rho_tof_full_2, [coarse_dim, 1.2*coarse_dim]);
    rho_tof_full_2 = interference_suite_2.convolution2d(rho_tof_full_2);

    rho_tof_full_3 = interference_suite_3.tof_full_expansion();
    rho_tof_full_3 = imresize(rho_tof_full_3, [coarse_dim, 1.2*coarse_dim]);
    rho_tof_full_3 = interference_suite_3.convolution2d(rho_tof_full_3);

    phase_extraction_suite_1 = class_phase_extraction(rho_tof_full_1, t_tof_1);
    phase_extraction_suite_2 = class_phase_extraction(rho_tof_full_2, t_tof_2);
    phase_extraction_suite_3 = class_phase_extraction(rho_tof_full_3, t_tof_3);

    ext_phase_1 = phase_extraction_suite_1.fitting(phase_extraction_suite_1.init_phase_guess());
    ext_phase_2 = phase_extraction_suite_2.fitting(phase_extraction_suite_2.init_phase_guess());
    ext_phase_3 = phase_extraction_suite_3.fitting(phase_extraction_suite_3.init_phase_guess());

    %compute fourier coeff
    fourier_1 = abs(fft(ext_phase_1)/sqrt(coarse_dim));
    fourier_1 = fourier_1(1:coarse_dim/2+1);
    fourier_2 = abs(fft(ext_phase_2)/sqrt(coarse_dim));
    fourier_2 = fourier_2(1:coarse_dim/2+1);
    fourier_3 = abs(fft(ext_phase_3)/sqrt(coarse_dim));
    fourier_3 = fourier_3(1:coarse_dim/2+1);

    all_out_fourier_1(i,:) = fourier_1;
    all_out_fourier_2(i,:) = fourier_2;
    all_out_fourier_3(i,:) = fourier_3;

    count =  count+1;
    disp(count)
end

save('fourier_data_25nk_2dconv_5percent.mat','all_input_fourier','all_out_fourier_1','all_out_fourier_2', 'all_out_fourier_3')
%end

%analysis
%load('fourier_data_25nk_2dconv_2percent.mat')
mean_squared_fourier_input = zeros(1,coarse_dim/2+1);
mean_squared_fourier_amp_1 = zeros(1,coarse_dim/2+1);
mean_squared_fourier_amp_2 = zeros(1,coarse_dim/2+1);
mean_squared_fourier_amp_3 = zeros(1,coarse_dim/2+1);
for n = 1:coarse_dim/2+1
    mean_squared_fourier_input(n) = mean(all_input_fourier(:,n));
    mean_squared_fourier_amp_1(n) = mean(all_out_fourier_1(:,n));
    mean_squared_fourier_amp_2(n) = mean(all_out_fourier_2(:,n));
    mean_squared_fourier_amp_3(n) = mean(all_out_fourier_3(:,n));
end

fourier_diff_1 = mean_squared_fourier_amp_1 - mean_squared_fourier_input;
fourier_diff_2 = mean_squared_fourier_amp_2 - mean_squared_fourier_input;
fourier_diff_3 = mean_squared_fourier_amp_3 - mean_squared_fourier_input;


figure
plot(fourier_diff_1,'--o')
hold on
plot(fourier_diff_2,'--x')
plot(fourier_diff_3,'--^')



