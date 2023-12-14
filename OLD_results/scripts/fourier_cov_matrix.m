close all
clear all
%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);

%generate sample and coarse-graining it
coarse_dim = 60;
nmb_sampled_phases = 200;
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3;
n_cutoff = 20;

rel_phase_profiles = phase_sampling_suite.generate_profiles(nmb_sampled_phases);
com_phase_profiles = phase_sampling_suite.generate_profiles(nmb_sampled_phases);

reference_rel_profiles = phase_sampling_suite.reference_profiles(rel_phase_profiles);
reference_com_profiles = phase_sampling_suite.reference_profiles(com_phase_profiles);

coarse_rel_profiles = phase_sampling_suite.coarse_grain(coarse_dim, reference_rel_profiles);
coarse_com_profiles = phase_sampling_suite.coarse_grain(coarse_dim, reference_com_profiles);

all_fitted_phase_1_trans = zeros(nmb_sampled_phases, coarse_dim);
all_fitted_phase_1_woc = zeros(nmb_sampled_phases, coarse_dim);
all_fitted_phase_1_wc = zeros(nmb_sampled_phases, coarse_dim);

all_fitted_phase_2_trans = zeros(nmb_sampled_phases, coarse_dim);
all_fitted_phase_2_woc = zeros(nmb_sampled_phases, coarse_dim);
all_fitted_phase_2_wc = zeros(nmb_sampled_phases, coarse_dim);

all_fitted_phase_3_trans = zeros(nmb_sampled_phases, coarse_dim);
all_fitted_phase_3_woc = zeros(nmb_sampled_phases, coarse_dim);
all_fitted_phase_3_wc = zeros(nmb_sampled_phases, coarse_dim);

count = 0;
for i = 1:nmb_sampled_phases
    %initialize interference pattern class
    interference_suite_1_woc = class_interference_pattern(coarse_rel_profiles(i,:), t_tof_1);
    interference_suite_1_wc = class_interference_pattern([coarse_rel_profiles(i,:); coarse_com_profiles(i,:)], t_tof_1);
    
    interference_suite_2_woc = class_interference_pattern(coarse_rel_profiles(i,:), t_tof_2);
    interference_suite_2_wc = class_interference_pattern([coarse_rel_profiles(i,:); coarse_com_profiles(i,:)], t_tof_2);
    
    interference_suite_3_woc = class_interference_pattern(coarse_rel_profiles(i,:), t_tof_3);
    interference_suite_3_wc = class_interference_pattern([coarse_rel_profiles(i,:); coarse_com_profiles(i,:)], t_tof_3);
    
    %generate rho tof
    rho_tof_1_trans = interference_suite_1_woc.tof_transversal_expansion();
    rho_tof_1_woc = interference_suite_1_woc.tof_full_expansion();
    rho_tof_1_wc = interference_suite_1_wc.tof_full_expansion();

    rho_tof_2_trans = interference_suite_2_woc.tof_transversal_expansion();
    rho_tof_2_woc = interference_suite_2_woc.tof_full_expansion();
    rho_tof_2_wc = interference_suite_2_wc.tof_full_expansion();

    rho_tof_3_trans = interference_suite_3_woc.tof_transversal_expansion();
    rho_tof_3_woc = interference_suite_3_woc.tof_full_expansion();
    rho_tof_3_wc = interference_suite_3_wc.tof_full_expansion();

    
    %initialize phase extraction class
    phase_extraction_suite_1_trans = class_phase_extraction(rho_tof_1_trans, t_tof_1);
    phase_extraction_suite_1_woc = class_phase_extraction(rho_tof_1_woc, t_tof_1);
    phase_extraction_suite_1_wc = class_phase_extraction(rho_tof_1_wc, t_tof_1);

    phase_extraction_suite_2_trans = class_phase_extraction(rho_tof_2_trans, t_tof_2);
    phase_extraction_suite_2_woc = class_phase_extraction(rho_tof_2_woc, t_tof_2);
    phase_extraction_suite_2_wc = class_phase_extraction(rho_tof_2_wc, t_tof_2);

    phase_extraction_suite_3_trans = class_phase_extraction(rho_tof_3_trans, t_tof_3);
    phase_extraction_suite_3_woc = class_phase_extraction(rho_tof_3_woc, t_tof_3);
    phase_extraction_suite_3_wc = class_phase_extraction(rho_tof_3_wc, t_tof_3);

    %perform fitting
    fitted_phase_1_trans = phase_extraction_suite_1_trans.fitting(phase_extraction_suite_1_trans.init_phase_guess());
    fitted_phase_1_woc = phase_extraction_suite_1_woc.fitting(phase_extraction_suite_1_woc.init_phase_guess());
    fitted_phase_1_wc = phase_extraction_suite_1_wc.fitting(phase_extraction_suite_1_wc.init_phase_guess());
    
    fitted_phase_2_trans = phase_extraction_suite_2_trans.fitting(phase_extraction_suite_2_trans.init_phase_guess());
    fitted_phase_2_woc = phase_extraction_suite_2_woc.fitting(phase_extraction_suite_2_woc.init_phase_guess());
    fitted_phase_2_wc = phase_extraction_suite_2_wc.fitting(phase_extraction_suite_2_wc.init_phase_guess());

    fitted_phase_3_trans = phase_extraction_suite_3_trans.fitting(phase_extraction_suite_3_trans.init_phase_guess());
    fitted_phase_3_woc = phase_extraction_suite_3_woc.fitting(phase_extraction_suite_3_woc.init_phase_guess());
    fitted_phase_3_wc = phase_extraction_suite_3_wc.fitting(phase_extraction_suite_3_wc.init_phase_guess());

    %save the result
    all_fitted_phase_1_trans(i,:) = fitted_phase_1_trans;
    all_fitted_phase_1_woc(i,:) = fitted_phase_1_woc;
    all_fitted_phase_1_wc(i,:) = fitted_phase_1_wc;

    all_fitted_phase_2_trans(i,:) = fitted_phase_2_trans;
    all_fitted_phase_2_woc(i,:) = fitted_phase_2_woc;
    all_fitted_phase_2_wc(i,:) = fitted_phase_2_wc;

    all_fitted_phase_3_trans(i,:) = fitted_phase_1_trans;
    all_fitted_phase_3_woc(i,:) = fitted_phase_1_woc;
    all_fitted_phase_3_wc(i,:) = fitted_phase_1_wc;
    count = count+1;
    disp(count)
end

%compute fourier correlation
corr_input_suite = class_1d_correlation(coarse_rel_profiles);

corr_fit1_suite_trans = class_1d_correlation(all_fitted_phase_1_trans);
corr_fit1_suite_woc = class_1d_correlation(all_fitted_phase_1_woc);
corr_fit1_suite_wc = class_1d_correlation(all_fitted_phase_1_wc);

corr_fit2_suite_trans = class_1d_correlation(all_fitted_phase_2_trans);
corr_fit2_suite_woc = class_1d_correlation(all_fitted_phase_2_woc);
corr_fit2_suite_wc = class_1d_correlation(all_fitted_phase_2_wc);

corr_fit3_suite_trans = class_1d_correlation(all_fitted_phase_1_trans);
corr_fit3_suite_woc = class_1d_correlation(all_fitted_phase_1_woc);
corr_fit3_suite_wc = class_1d_correlation(all_fitted_phase_1_wc);

fourier_cov_input = corr_input_suite.fourier_correlation();
fourier_cov_1_trans = corr_fit1_suite_trans.fourier_correlation();
fourier_cov_1_woc = corr_fit1_suite_woc.fourier_correlation();
fourier_cov_1_wc = corr_fit1_suite_wc.fourier_correlation();

fourier_cov_2_trans = corr_fit2_suite_trans.fourier_correlation();
fourier_cov_2_woc = corr_fit2_suite_woc.fourier_correlation();
fourier_cov_2_wc = corr_fit2_suite_wc.fourier_correlation();

fourier_cov_3_trans = corr_fit3_suite_trans.fourier_correlation();
fourier_cov_3_woc = corr_fit3_suite_woc.fourier_correlation();
fourier_cov_3_wc = corr_fit3_suite_wc.fourier_correlation();

diag_cov_input = zeros(1,n_cutoff);

diag_cov1_trans = zeros(1,n_cutoff);
diag_cov1_woc = zeros(1,n_cutoff);
diag_cov1_wc = zeros(1,n_cutoff);

diag_cov2_trans = zeros(1,n_cutoff);
diag_cov2_woc = zeros(1,n_cutoff);
diag_cov2_wc = zeros(1,n_cutoff);

diag_cov3_trans = zeros(1,n_cutoff);
diag_cov3_woc = zeros(1,n_cutoff);
diag_cov3_wc = zeros(1,n_cutoff);

for i = 2:n_cutoff+1
    diag_cov_input(i-1) = fourier_cov_input(i,i);
    diag_cov1_trans(i-1) = fourier_cov_1_trans(i,i);
    diag_cov1_woc(i-1) = fourier_cov_1_woc(i,i);
    diag_cov1_wc(i-1) = fourier_cov_1_wc(i,i);
    diag_cov2_trans(i-1) = fourier_cov_2_trans(i,i);
    diag_cov2_woc(i-1) = fourier_cov_2_woc(i,i);
    diag_cov2_wc(i-1) = fourier_cov_1_wc(i,i);
    diag_cov3_trans(i-1) = fourier_cov_3_trans(i,i);
    diag_cov3_woc(i-1) = fourier_cov_3_woc(i,i);
    diag_cov3_wc(i-1) = fourier_cov_3_wc(i,i);
end 

f(1) = subplot(1,3,1);
plot(diag_cov_input, 'Color', 'black', 'LineWidth', 1.2)
hold on
plot(diag_cov1_trans, 'o','Color', 'blue')
plot(diag_cov2_trans, 'x', 'MarkerSize', 8, 'Color', 'red', 'LineWidth', 1.2)
plot(diag_cov3_trans, '^', 'Color', [0,0.7,0])

f(2) = subplot(1,3,2);
plot(diag_cov_input, 'Color', 'black', 'LineWidth', 1.2)
hold on
plot(diag_cov1_woc, 'o','Color', 'blue')
plot(diag_cov2_woc, 'x', 'MarkerSize', 8, 'Color', 'red', 'LineWidth', 1.2)
plot(diag_cov3_woc, '^', 'Color', [0,0.7,0])

f(3) = subplot(1,3,3);
plot(diag_cov_input, 'Color', 'black', 'LineWidth', 1.2)
hold on
plot(diag_cov1_wc,'o', 'Color', 'blue')
plot(diag_cov2_wc, 'x', 'MarkerSize', 8, 'Color', 'red', 'LineWidth', 1.2)
plot(diag_cov3_wc, '^', 'Color', [0,0.7,0])