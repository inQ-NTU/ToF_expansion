clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 1e-6;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
%coarse_resolution = 100;
coarse_resolution = longitudinal_resolution;


z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
num_samples = 1000;
gradient_vec_in = zeros(num_samples, coarse_resolution);
rel_phase = sampling_suite.generate_profiles(num_samples);
%rel_phase = sampling_suite.coarse_grain(coarse_resolution, rel_phase);


for i = 1:num_samples
    gradient_vec_in(i,:) = gradient(rel_phase(i,:));
end

gradient_vec_in = gradient_vec_in*coarse_resolution/condensate_length;

corr_in = class_1d_correlation(gradient_vec_in);
cov_in = corr_in.covariance_matrix();

