%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_60nk.mat')

%initialize gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

%generate 500 phase profiles and coarse-graining them to size of 50
nmb_samples = 500 ;
coarse_dim = 50;
all_samples = phase_sampling_suite.generate_profiles(nmb_samples);
coarse_samples = phase_sampling_suite.coarse_grain(coarse_dim, all_samples);


%initialize 1d correlation class
correlation_suite = class_1d_correlation(coarse_samples);

%extract covariance matrix
cov_mat = correlation_suite.covariance_matrix;

%display the true and reconstructed covariance matrix
subplot(1,2,1)
imagesc(cov_phase)
colorbar

subplot(1,2,2)
imagesc(cov_mat)
colorbar