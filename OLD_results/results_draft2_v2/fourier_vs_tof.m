%clear all
%close al

addpath('../input')
addpath('../classes')
load('thermal_cov_50nk.mat')
cov_phase = cov_phase_fine;
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 1e-6;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = transversal_length/pixel_width;
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z+1).*1e6;
num_samples = 200;
momentum_idx = 10;
t_tof = linspace(7,31,9).*1e-3;

%Fourier amplitude
fourier_amp_woc = zeros(1, length(t_tof));
fourier_amp_wc = zeros(1, length(t_tof));
fourier_amp_trans = zeros(1,length(t_tof));


%Generate samples
rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);

cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);
%Calculate input fourier amp
fourier_amp_in_stats = zeros(1,num_samples);
for i = 1:num_samples
    fourier_coeff_in = fft(cg_rel_phase(i,:));
    fourier_amp_in_stats(i) = abs(fourier_coeff_in(momentum_idx))^2;
end

int_count = 0;
ext_count = 0;
for j = 1:length(t_tof)
    fourier_amp_woc_stats = zeros(1,num_samples);
    fourier_amp_wc_stats = zeros(1, num_samples);
    fourier_amp_trans_stats = zeros(1,num_samples);
    for i = 1:num_samples
    %3D expansion
    interference_suite_woc = class_interference_pattern(rel_phase(i,:), t_tof(j));
    interference_suite_wc = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof(j));
    rho_tof_woc = interference_suite_woc.tof_full_expansion();
    rho_tof_woc = imresize(rho_tof_woc, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_wc = interference_suite_wc.tof_full_expansion();
    rho_tof_wc = imresize(rho_tof_wc, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite_woc = class_phase_extraction(rho_tof_woc, t_tof(j));
    phase_ext_suite_wc = class_phase_extraction(rho_tof_wc, t_tof(j));
    ext_phase_woc = phase_ext_suite_woc.fitting(phase_ext_suite_woc.init_phase_guess());
    ext_phase_wc = phase_ext_suite_wc.fitting(phase_ext_suite_wc.init_phase_guess());
    
    %2D Transversal expansion
    rho_tof_trans = interference_suite_woc.tof_transversal_expansion();
    rho_tof_trans = imresize(rho_tof_trans, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t_tof(j));
    ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());
    
    %Compute the fourier coefficient
    fourier_coeff_woc = fft(ext_phase_woc);
    fourier_coeff_wc = fft(ext_phase_wc);
    fourier_coeff_trans = fft(ext_phase_trans);
    fourier_coeff_in = fft(cg_rel_phase(i,:));

    fourier_amp_woc_stats(i) = abs(fourier_coeff_woc(momentum_idx))^2;
    fourier_amp_wc_stats(i) = abs(fourier_coeff_wc(momentum_idx))^2;
    fourier_amp_trans_stats(i) = abs(fourier_coeff_trans(momentum_idx))^2;
    int_count = int_count+1;
    disp(int_count)
    end
    fourier_amp_woc(j) = mean(fourier_amp_woc_stats);
    fourier_amp_wc(j) = mean(fourier_amp_wc_stats);
    fourier_amp_trans(j) = mean(fourier_amp_trans_stats);
    ext_count = ext_count+1;
    disp(ext_count)
end
save('fourier_vs_tof_50nk_n10_higher_res.mat','rel_phase', 'com_phase','fourier_amp_in_stats', 'fourier_amp_woc', 'fourier_amp_wc', 'fourier_amp_trans')
