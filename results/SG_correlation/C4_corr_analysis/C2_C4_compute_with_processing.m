clear all
close all
addpath('../../../classes/')
addpath('../../../input/')
load('SG_05_tof.mat')
%load('ext_phase_SG_3_transverse_expansion_only.mat')

wp_trans_corr = class_1d_correlation(ext_phase_wp_trans);
ref_phases_wp_trans = wp_trans_corr.reference_phase_profiles();

wp_woc_corr = class_1d_correlation(ext_phase_wp_woc);
ref_phases_wp_woc = wp_woc_corr.reference_phase_profiles();

wp_wc_corr = class_1d_correlation(ext_phase_wp_wc);
ref_phases_wp_wc = wp_wc_corr.reference_phase_profiles();

%Compute second order correlation C2
cov_trans = wp_trans_corr.covariance_matrix();
cov_woc = wp_woc_corr.covariance_matrix();
cov_wc = wp_wc_corr.covariance_matrix();

save('C2_q05_data_with_processing.mat', 'cov_trans', 'cov_woc', 'cov_wc')

%Computing full C4 (fourth order correlation) cut
z3_idx = 26+6;
z4_idx = 26-6;

C4_trans = wp_trans_corr.fourth_order_corr(z3_idx, z4_idx, ref_phases_wp_trans);
C4_output_woc = wp_woc_corr.fourth_order_corr(z3_idx, z4_idx, ref_phases_wp_woc);
C4_output_wc = wp_wc_corr.fourth_order_corr(z3_idx, z4_idx, ref_phases_wp_wc);

save('C4_q05_11p5microns_wp_data.mat', 'C4_trans', 'C4_output_woc', 'C4_output_wc')