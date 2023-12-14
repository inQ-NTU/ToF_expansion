addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')
coarse_dim =50;

%phase sampling

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
common_phase = phase_sampling_suite.generate_profiles(1);
common_phase = phase_sampling_suite.coarse_grain(common_phase, coarse_dim);
%phase_samples = [common_phase; zeros(1,coarse_dim)];
phase_samples = [zeros(1,coarse_dim); common_phase];

%interference class
interference_suite = class_interference_pattern(phase_samples);
tof = interference_suite.tof_full_expansion();

imagesc(tof)
colormap(gge_colormap)
colorbar