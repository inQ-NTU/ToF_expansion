clear all
close all
addpath('../../../classes/')
addpath('../../../input/')
load('ext_phase_SG_3_bank.mat')
load('ext_phase_SG_3_transverse_expansion_only.mat')

%Defining correlation suite and referencing
input_corr = class_1d_correlation(cg_rel_phase);
ref_phases_input = input_corr.reference_phase_profiles();

%trans_corr = class_1d_correlation(ext_phase_wop_trans);
%ref_phases_trans = trans_corr.reference_phase_profiles();


wop_woc_corr = class_1d_correlation(ext_phase_wop_woc);
ref_phases_wop_woc = wop_woc_corr.reference_phase_profiles();


wop_wc_corr = class_1d_correlation(ext_phase_wop_wc);
ref_phases_wop_wc = wop_wc_corr.reference_phase_profiles();


%Computing C2 (second order correlation)
input_cov = input_corr.covariance_matrix(ref_phases_input);
%trans_cov = trans_corr.covariance_matrix(ref_phases_trans);
wop_woc_cov = wop_woc_corr.covariance_matrix(ref_phases_wop_woc);
wop_wc_cov = wop_wc_corr.covariance_matrix(ref_phases_wop_wc);


if 0
%save('C2_q05_data.mat', 'input_cov', 'wop_wc_cov', 'wop_woc_cov', 'trans_cov')

%Computing full C4 (fourth order correlation) cut
boundary_cut_idx = 5;
z3_idx = floor((200 - boundary_cut_idx+1)/2)+30;
z4_idx = floor((200 - boundary_cut_idx+1)/2)-30;


C4_input = input_corr.fourth_order_corr(z3_idx, z4_idx, ref_phases_input(:,boundary_cut_idx:end-boundary_cut_idx));
C4_output_woc = wop_woc_corr.fourth_order_corr(z3_idx, z4_idx, ref_phases_wop_woc(:, boundary_cut_idx:end-boundary_cut_idx));
C4_output_wc = wop_wc_corr.fourth_order_corr(z3_idx, z4_idx, ref_phases_wop_wc(:, boundary_cut_idx:end-boundary_cut_idx));
C4_trans = trans_corr.fourth_order_corr(z3_idx, z4_idx, ref_phases_trans(:, boundary_cut_idx:end-boundary_cut_idx));

save('C4_q05_15microns_wop_data.mat', 'C4_input', 'C4_output_woc', 'C4_output_wc', 'C4_trans')
end