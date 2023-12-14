close all
clear all
addpath('../classes')
addpath('../input')
load('thermal_cov_25nk.mat')

%sampling phase
num_samples = 200;
coarse_dim = 81;
t1 = 7e-3;
t2 = 15e-3;
t3 = 30e-3;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = sampling_suite.generate_profiles(num_samples);

cg_rel_phase = sampling_suite.coarse_grain(coarse_dim, rel_phase);
ext_phase_trans_1 = zeros(num_samples, coarse_dim);
ext_phase_trans_2 = zeros(num_samples, coarse_dim);
ext_phase_trans_3 = zeros(num_samples, coarse_dim);

ext_phase_full_1 = zeros(num_samples, coarse_dim);
ext_phase_full_2 = zeros(num_samples, coarse_dim);
ext_phase_full_3 = zeros(num_samples, coarse_dim);

count = 0;
for i = 1:num_samples
    interference_suite_1 = class_interference_pattern(cg_rel_phase(i,:), t1);
    interference_suite_2 = class_interference_pattern(cg_rel_phase(i,:), t2);
    interference_suite_3 = class_interference_pattern(cg_rel_phase(i,:), t3);

    rho_tof_full_1 = interference_suite_1.tof_full_expansion();
    rho_tof_full_2 = interference_suite_2.tof_full_expansion();
    rho_tof_full_3 = interference_suite_3.tof_full_expansion();

    rho_tof_trans_1 = interference_suite_1.tof_transversal_expansion();
    rho_tof_trans_2 = interference_suite_2.tof_transversal_expansion();
    rho_tof_trans_3 = interference_suite_3.tof_transversal_expansion();

    extraction_suite_full_1 = class_phase_extraction(rho_tof_full_1, t1);
    extraction_suite_full_2 = class_phase_extraction(rho_tof_full_2, t2);
    extraction_suite_full_3 = class_phase_extraction(rho_tof_full_3, t3);

    extraction_suite_trans_1 = class_phase_extraction(rho_tof_trans_1, t1);
    extraction_suite_trans_2 = class_phase_extraction(rho_tof_trans_2, t2);
    extraction_suite_trans_3= class_phase_extraction(rho_tof_trans_3, t3);

    ext_phase_trans_1(i,:) = extraction_suite_trans_1.fitting(extraction_suite_trans_1.init_phase_guess());
    ext_phase_trans_2(i,:) = extraction_suite_trans_2.fitting(extraction_suite_trans_2.init_phase_guess());
    ext_phase_trans_3(i,:) = extraction_suite_trans_3.fitting(extraction_suite_trans_3.init_phase_guess());

    ext_phase_full_1(i,:) = extraction_suite_full_1.fitting(extraction_suite_full_1.init_phase_guess());
    ext_phase_full_2(i,:) = extraction_suite_full_2.fitting(extraction_suite_full_2.init_phase_guess());
    ext_phase_full_3(i,:) = extraction_suite_full_3.fitting(extraction_suite_full_3.init_phase_guess());

    count = count +1;
    disp(count)
end

%Computing local derivative
dlocal_in = zeros(num_samples, coarse_dim-1);

dlocal_trans_1 = zeros(num_samples, coarse_dim-1);
dlocal_trans_2 = zeros(num_samples, coarse_dim-1);
dlocal_trans_3 = zeros(num_samples, coarse_dim-1);

dlocal_full_1 = zeros(num_samples, coarse_dim-1);
dlocal_full_2 = zeros(num_samples, coarse_dim-1);
dlocal_full_3 = zeros(num_samples, coarse_dim-1);

for i = 1:num_samples
    for j = 1:coarse_dim-1
        dlocal_in(i,j) = cg_rel_phase(i,j+1) - cg_rel_phase(i,j);
        dlocal_trans_1(i,j) = ext_phase_trans_1(i,j+1) - ext_phase_trans_1(i,j);
        dlocal_trans_2(i,j) = ext_phase_trans_2(i,j+1) - ext_phase_trans_2(i,j);
        dlocal_trans_3(i,j) = ext_phase_trans_3(i,j+1) - ext_phase_trans_3(i,j);

        dlocal_full_1(i,j) = ext_phase_full_1(i,j+1) - ext_phase_full_1(i,j);
        dlocal_full_2(i,j) = ext_phase_full_2(i,j+1) - ext_phase_full_2(i,j);
        dlocal_full_3(i,j) = ext_phase_full_3(i,j+1) - ext_phase_full_3(i,j);
    end
end

%Computing correlation and covariance matrix
input_corr = class_1d_correlation(dlocal_in);
trans1_corr = class_1d_correlation(dlocal_trans_1);
trans2_corr = class_1d_correlation(dlocal_trans_2);
trans3_corr = class_1d_correlation(dlocal_trans_3);

full1_corr = class_1d_correlation(dlocal_full_1);
full2_corr = class_1d_correlation(dlocal_full_2);
full3_corr = class_1d_correlation(dlocal_full_3);

in_cov = input_corr.covariance_matrix;
trans1_cov = trans1_corr.covariance_matrix;
trans2_cov = trans2_corr.covariance_matrix;
trans3_cov = trans3_corr.covariance_matrix;

full1_cov = full1_corr.covariance_matrix;
full2_cov = full2_corr.covariance_matrix;
full3_cov = full3_corr.covariance_matrix;

%Saving data
save('dlocal_thermal_25nk.mat', 'cg_rel_phase','ext_phase_trans_1', 'ext_phase_trans_2', 'ext_phase_trans_3',...
'ext_phase_full_1', 'ext_phase_full_2','ext_phase_full_3', 'dlocal_in','dlocal_trans_1', 'dlocal_trans_2',...
'dlocal_trans_3', 'dlocal_full_1', 'dlocal_full_2', 'dlocal_full_3', 'in_cov', 'trans1_cov','trans2_cov','trans3_cov',...
'full1_cov','full2_cov', 'full3_cov')

%Plotting
figure
imagesc(in_cov)
colorbar
colormap(gge_colormap)
clim([-0.02,0.02])
figure
f(1) = subplot(2,3,1);
imagesc(full1_cov)
colorbar
clim([-0.02,0.02])
f(2) = subplot(2,3,2);
imagesc(full2_cov)
colorbar
clim([-0.02,0.02])
f(3) = subplot(2,3,3);
imagesc(full3_cov)
colorbar
clim([-0.02,0.02])
f(4) = subplot(2,3,4);
imagesc(trans1_cov)
colorbar
clim([-0.02,0.02])
f(5) = subplot(2,3,5);
imagesc(trans2_cov)
colorbar
clim([-0.02,0.02])
f(6) = subplot(2,3,6);
imagesc(trans3_cov)
colorbar
clim([-0.02,0.02])
colormap(gge_colormap)


