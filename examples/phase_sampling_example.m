%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_60nk.mat')

%initiate gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

%generate 10 phase profiles samples - if the argument is empty, it will give 1 sample
nmb_samples = 10;
all_samples = phase_sampling_suite.generate_profiles(nmb_samples);

%the default dimension for each sample is determined by the size of
%covariance matrix. Here, the default is 400 (because input cov_phase is 400 x
%400 matrix)

%Coarse-graining each sample to the size of 50
coarse_dim = 50;
coarse_samples = phase_sampling_suite.coarse_grain(coarse_dim, all_samples);

%Plotting representative phase profile and its coarse-graining (assume 100
%microns gas)

fine_grid = linspace(0,100,400);
coarse_grid = linspace(0,100, coarse_dim);
plot(fine_grid, all_samples(1,:))
hold on
plot(coarse_grid, coarse_samples(1,:),'o')
