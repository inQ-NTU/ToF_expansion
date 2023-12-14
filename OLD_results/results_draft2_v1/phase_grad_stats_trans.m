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
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = transversal_length/pixel_width;
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z+1).*1e6;
num_samples = 500;
gradient_vec_trans = zeros(num_samples, coarse_resolution_z);
rel_phase = sampling_suite.generate_profiles(num_samples);
count = 0;
for i = 1:num_samples
    interference_suite = class_interference_pattern(rel_phase(i,:)); 
    rho_tof = interference_suite.tof_transversal_expansion();
    rho_tof = imresize(rho_tof, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite = class_phase_extraction(rho_tof);
    ext_phase = phase_ext_suite.fitting(phase_ext_suite.init_phase_guess());
    gradient_vec_trans(i,:) = gradient(ext_phase);
    count = count +1;
    disp(count)
end
save('phase_grad_stats_trans.mat', 'gradient_vec_trans')