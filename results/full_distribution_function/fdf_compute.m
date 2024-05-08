clear all
load('phase_extraction_bank_75nk.mat')
sublength = 50;
coarse_dim = 52;
num_samples = 1000;
gas_length = 100; 
pixel_size = gas_length/(coarse_dim-1);

mid_point = floor(coarse_dim/2);
end_idx_1 = floor(mid_point-sublength*(coarse_dim-1)/(2*gas_length)); 
end_idx_2 = floor(mid_point+sublength*(coarse_dim-1)/(2*gas_length));

integrated_contrast_in = zeros(1,num_samples);
integrated_contrast_trans = zeros(1,num_samples);

integrated_contrast_woc_1 = zeros(1, num_samples);
integrated_contrast_woc_2 = zeros(1, num_samples);
integrated_contrast_woc_3 = zeros(1, num_samples);

integrated_contrast_wc_1 = zeros(1, num_samples);
integrated_contrast_wc_2 = zeros(1, num_samples);
integrated_contrast_wc_3 = zeros(1, num_samples);

integrated_contrast_woc_2_wp = zeros(1,num_samples);
integrated_contrast_wc_2_wp = zeros(1,num_samples);

for i = 1:num_samples
    cut_in_phase = cg_rel_phase(i,end_idx_1:end_idx_2);
    exp_in_phase = arrayfun(@(x) exp(1j*x), cut_in_phase);
    integrated_contrast_in(i) = trapz(pixel_size,exp_in_phase);

    cut_ext_phase_trans = ext_phase_trans(i, end_idx_1:end_idx_2);
    exp_phase_trans = arrayfun(@(x) exp(1j*x), cut_ext_phase_trans);
    integrated_contrast_trans(i) = trapz(pixel_size, exp_phase_trans);

    cut_ext_phase_woc_1 = ext_phase_woc_1(i, end_idx_1:end_idx_2);
    exp_phase_woc_1 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_1);
    integrated_contrast_woc_1(i) = trapz(pixel_size, exp_phase_woc_1);

    cut_ext_phase_woc_2 = ext_phase_woc_2(i, end_idx_1:end_idx_2);
    exp_phase_woc_2 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_2);
    integrated_contrast_woc_2(i) = trapz(pixel_size, exp_phase_woc_2);

    cut_ext_phase_woc_3 = ext_phase_woc_3(i, end_idx_1:end_idx_2);
    exp_phase_woc_3 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_3);
    integrated_contrast_woc_3(i) = trapz(pixel_size, exp_phase_woc_3);

    cut_ext_phase_wc_1 = ext_phase_wc_1(i, end_idx_1:end_idx_2);
    exp_phase_wc_1 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_1);
    integrated_contrast_wc_1(i) = trapz(pixel_size, exp_phase_wc_1);

    cut_ext_phase_wc_2 = ext_phase_wc_2(i, end_idx_1:end_idx_2);
    exp_phase_wc_2 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_2);
    integrated_contrast_wc_2(i) = trapz(pixel_size, exp_phase_wc_2);

    cut_ext_phase_wc_3 = ext_phase_wc_3(i, end_idx_1:end_idx_2);
    exp_phase_wc_3 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_3);
    integrated_contrast_wc_3(i) = trapz(pixel_size, exp_phase_wc_3);

    cut_ext_phase_woc_2_wp = ext_phase_woc_2_wp(i, end_idx_1:end_idx_2);
    exp_phase_woc_2_wp = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_2_wp);
    integrated_contrast_woc_2_wp(i) = trapz(pixel_size,  exp_phase_woc_2_wp);

    cut_ext_phase_wc_2_wp = ext_phase_wc_2_wp(i, end_idx_1:end_idx_2);
    exp_phase_wc_2_wp = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_2_wp);
    integrated_contrast_wc_2_wp(i) = trapz(pixel_size,  exp_phase_wc_2_wp);

end

integrated_contrast_in = abs(integrated_contrast_in).^2;
integrated_contrast_in = integrated_contrast_in/mean(integrated_contrast_in);

integrated_contrast_trans = abs(integrated_contrast_trans).^2;
integrated_contrast_trans = integrated_contrast_trans/mean(integrated_contrast_trans);

integrated_contrast_woc_1 = abs(integrated_contrast_woc_1).^2;
integrated_contrast_woc_1 = integrated_contrast_woc_1/mean(integrated_contrast_woc_1);

integrated_contrast_woc_2 = abs(integrated_contrast_woc_2).^2;
integrated_contrast_woc_2 = integrated_contrast_woc_2/mean(integrated_contrast_woc_2);

integrated_contrast_woc_3 = abs(integrated_contrast_woc_3).^2;
integrated_contrast_woc_3 = integrated_contrast_woc_3/mean(integrated_contrast_woc_3);

integrated_contrast_wc_1 = abs(integrated_contrast_wc_1).^2;
integrated_contrast_wc_1 = integrated_contrast_wc_1/mean(integrated_contrast_wc_1);

integrated_contrast_wc_2 = abs(integrated_contrast_wc_2).^2;
integrated_contrast_wc_2 = integrated_contrast_wc_2/mean(integrated_contrast_wc_2);

integrated_contrast_wc_3 = abs(integrated_contrast_wc_3).^2;
integrated_contrast_wc_3 = integrated_contrast_wc_3/mean(integrated_contrast_wc_3);

integrated_contrast_woc_2_wp = abs(integrated_contrast_woc_2_wp).^2;
integrated_contrast_woc_2_wp = integrated_contrast_woc_2_wp/mean(integrated_contrast_woc_2_wp);

integrated_contrast_wc_2_wp = abs(integrated_contrast_wc_2_wp).^2;
integrated_contrast_wc_2_wp = integrated_contrast_wc_2_wp/mean(integrated_contrast_wc_2_wp);

%save('integrated_medium_length.mat','integrated_contrast_in', 'integrated_contrast_trans',...
%'integrated_contrast_woc_1','integrated_contrast_woc_2', 'integrated_contrast_woc_3',...
%'integrated_contrast_wc_1', 'integrated_contrast_wc_2', 'integrated_contrast_wc_3', 'integrated_contrast_woc_2_wp', ...
%'integrated_contrast_wc_2_wp')