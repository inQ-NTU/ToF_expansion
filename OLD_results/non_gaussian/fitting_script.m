clear all
close all
addpath('../classes')
addpath('../input')
%load phase profiles data
%load('OU_profiles.mat')
load('SG_profiles.mat')
load('thermal_cov_50nk.mat')
cov_phase = cov_phase_fine;
%define parameters
dim = 100;
trans_scaling_factor = 1.2;
num_shots = 1000;
t_tof = 30e-3; 

%sample common phase
sampling_suite = class_gaussian_phase_sampling(cov_phase);
com_phase = sampling_suite.generate_profiles(num_shots);

%SG relative phase
input_profiles = imresize(phase_SG_2', [num_shots, size(com_phase,2)]);

%coarse-graining relative profile
input_profiles = sampling_suite.coarse_grain(size(com_phase,2), input_profiles);

%obtain fitted profiles
fit_profiles_full = zeros(num_shots, dim);
fit_profiles_trans = zeros(num_shots, dim);
count = 0;
for i = 1:num_shots
    interference_suite = class_interference_pattern([input_profiles(i,:); com_phase(i,:)], t_tof);
    rho_tof_full = interference_suite.tof_full_expansion();
    rho_tof_full = imresize(rho_tof_full, [dim, trans_scaling_factor*dim]);
    rho_tof_trans = interference_suite.tof_transversal_expansion();
    rho_tof_trans = imresize(rho_tof_trans, [dim, trans_scaling_factor*dim]);

    extraction_full = class_phase_extraction(rho_tof_full, t_tof);
    extraction_trans = class_phase_extraction(rho_tof_trans, t_tof);

    fit_phase_full = extraction_full.fitting(extraction_full.init_phase_guess());
    fit_phase_trans = extraction_trans.fitting(extraction_trans.init_phase_guess());

    fit_profiles_full(i,:) = fit_phase_full;
    fit_profiles_trans(i,:) = fit_phase_trans;

    count = count +1;
    disp(count)
end

save('fit_phase_SG_2_t30_wc.mat', 'fit_profiles_trans', 'fit_profiles_full','com_phase')