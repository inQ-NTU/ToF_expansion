addpath('../classes')
addpath('../input')
load('thermal_cov_25nk.mat')
coarse_dim =50;

%phase sampling

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
phase_samples = phase_sampling_suite.generate_profiles(2);

%interference class
interference_suite = class_interference_pattern(phase_samples);
tof = interference_suite.tof_full_expansion();

imagesc(tof)
colormap(gge_colormap)
colorbar