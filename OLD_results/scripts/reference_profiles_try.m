close all
clear all
%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
phase_profiles = phase_sampling_suite.generate_profiles(50);
phase_profiles = phase_sampling_suite.reference_profiles();

plot((phase_profiles)')