clear all
close all

addpath('../../../classes/')

load('SG_05_tof.mat')
input_05 = cg_input_relative_phase(1:1000,:);
output_woc_05 = ext_rel_phase_woc_15ms;
output_wc_05 = ext_rel_phase_wc_15ms;

load('SG_3_tof.mat')
input_3 = cg_input_relative_phase(1:1000,:);
output_woc_3 = ext_rel_phase_woc_15ms;
output_wc_3 = ext_rel_phase_wc_15ms;


corr_input_05 = class_1d_correlation(input_05);
corr_input_3 = class_1d_correlation(input_3);

corr_output_woc_05 = class_1d_correlation(output_woc_05);
corr_output_woc_3 = class_1d_correlation(output_woc_3);

corr_output_wc_05 = class_1d_correlation(output_wc_05);
corr_output_wc_3 = class_1d_correlation(output_wc_3);

%Referencing phase profiles
ref_input_05 = corr_input_05.reference_phase_profiles();
ref_input_3 = corr_input_3.reference_phase_profiles();
ref_output_woc_05 = corr_output_woc_05.reference_phase_profiles();
ref_output_woc_3 = corr_output_woc_3.reference_phase_profiles();
ref_output_wc_05 = corr_output_wc_05.reference_phase_profiles();
ref_output_wc_3 = corr_output_wc_3.reference_phase_profiles();


%Computing covariance matrix
cov_input_05 = corr_input_05.covariance_matrix(ref_input_05);
cov_input_3 = corr_input_3.covariance_matrix(ref_input_3);

cov_output_woc_05 = corr_output_woc_05.covariance_matrix(ref_output_woc_05);
cov_output_woc_3 = corr_output_woc_3.covariance_matrix(ref_output_woc_3);

cov_output_wc_05 = corr_output_wc_05.covariance_matrix(ref_output_wc_05);
cov_output_wc_3 = corr_output_wc_3.covariance_matrix(ref_output_wc_3);

%Saving covariance matrix data
save('cov_matrix_15ms.mat', 'cov_input_05', 'cov_input_3', 'cov_output_woc_05', 'cov_output_woc_3',...
    'cov_output_wc_3', 'cov_output_wc_05')