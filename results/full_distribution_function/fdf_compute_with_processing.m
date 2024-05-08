clear all
close all
load('ext_phase_5000samples_15ms_75nK_with_processing.mat')

coarse_dim = length(coarse_grid);
fine_dim = length(fine_grid);
num_samples = size(rel_phase, 1);
gas_length = 100;
sublength = 9.8;
pixel_size_fine = gas_length/(fine_dim-1);
pixel_size_coarse = gas_length/(coarse_dim - 1);

mid_point_coarse = floor(coarse_dim/2);
mid_point_fine = floor(fine_dim/2);
end_idx_fine_1 = floor(mid_point_fine-sublength*(fine_dim-1)/(2*gas_length)); 
end_idx_fine_2 = floor(mid_point_fine+sublength*(fine_dim-1)/(2*gas_length));

end_idx_coarse_1 = floor(mid_point_coarse-sublength*(coarse_dim-1)/(2*gas_length)); 
end_idx_coarse_2 = floor(mid_point_coarse+sublength*(coarse_dim-1)/(2*gas_length));

integrated_contrast_in = zeros(1,num_samples);

integrated_contrast_wop_woc = zeros(1, num_samples);
integrated_contrast_wop_wc = zeros(1, num_samples);

integrated_contrast_wp_woc = zeros(1,num_samples);
integrated_contrast_wp_wc = zeros(1,num_samples);

for i = 1:num_samples
    cut_in_phase = rel_phase(i,end_idx_fine_1:end_idx_fine_2);
    exp_in_phase = arrayfun(@(x) exp(1j*x), cut_in_phase);
    integrated_contrast_in(i) = trapz(pixel_size_fine,exp_in_phase);

    cut_wop_woc_phase = ext_phase_wop_woc(i,end_idx_fine_1:end_idx_fine_2);
    cut_wop_wc_phase = ext_phase_wop_wc(i,end_idx_fine_1:end_idx_fine_2);
    cut_wp_woc_phase = ext_phase_wp_woc(i, end_idx_coarse_1:end_idx_coarse_2);
    cut_wp_wc_phase = ext_phase_wp_wc(i, end_idx_coarse_1:end_idx_coarse_2);


    exp_in_phase = arrayfun(@(x) exp(1j*x), cut_in_phase);
    exp_wop_woc_phase = arrayfun(@(x) exp(1j*x), cut_wop_woc_phase);
    exp_wop_wc_phase = arrayfun(@(x) exp(1j*x), cut_wop_wc_phase);
    exp_wp_woc_phase = arrayfun(@(x) exp(1j*x), cut_wp_woc_phase);
    exp_wp_wc_phase = arrayfun(@(x) exp(1j*x), cut_wp_wc_phase);

    integrated_contrast_in(i) = trapz(pixel_size_fine,exp_in_phase);
    integrated_contrast_wop_woc(i) = trapz(pixel_size_fine, exp_wop_woc_phase);
    integrated_contrast_wop_wc(i) = trapz(pixel_size_fine, exp_wop_wc_phase);
    integrated_contrast_wp_woc(i) = trapz(pixel_size_coarse, exp_wp_woc_phase);
    integrated_contrast_wp_wc(i) = trapz(pixel_size_coarse, exp_wp_wc_phase);
end

integrated_contrast_in = abs(integrated_contrast_in).^2;
integrated_contrast_in = integrated_contrast_in/mean(integrated_contrast_in);

integrated_contrast_wop_woc = abs(integrated_contrast_wop_woc).^2;
integrated_contrast_wop_woc = integrated_contrast_wop_woc/mean(integrated_contrast_wop_woc);

integrated_contrast_wop_wc = abs(integrated_contrast_wop_wc).^2;
integrated_contrast_wop_wc = integrated_contrast_wop_wc/mean(integrated_contrast_wop_wc);

integrated_contrast_wp_woc = abs(integrated_contrast_wp_woc).^2;
integrated_contrast_wp_woc = integrated_contrast_wp_woc/mean(integrated_contrast_wp_woc);

integrated_contrast_wp_wc = abs(integrated_contrast_wp_wc).^2;
integrated_contrast_wp_wc = integrated_contrast_wp_wc/mean(integrated_contrast_wp_wc);

%save('integrated_contrast_short_length.mat', 'integrated_contrast_in', 'integrated_contrast_wop_woc', 'integrated_contrast_wop_wc',...
%    'integrated_contrast_wp_woc', 'integrated_contrast_wp_wc')