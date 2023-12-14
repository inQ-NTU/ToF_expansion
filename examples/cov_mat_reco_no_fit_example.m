%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

%initialize gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);

%generate 500 phase profiles and coarse-graining them
nmb_samples = 10000 ;
coarse_dim = 50;
all_samples = phase_sampling_suite.generate_profiles(nmb_samples);
coarse_samples = phase_sampling_suite.coarse_grain(all_samples, coarse_dim);


%initialize 1d correlation class
correlation_suite = class_1d_correlation(coarse_samples);

%correlation function
corr_data = correlation_suite.correlation_func(2);

%extract covariance matrix
%cov_mat = correlation_suite.cov_matrix;

%display the true and reconstructed covariance matrix
subplot(1,3,1)
imagesc(cov_phase_fine)
colorbar

subplot(1,3,2)
imagesc(corr_data)
colorbar