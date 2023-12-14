clear all
close all

addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')

num_samples = 1000;
sub_length_list = linspace(20,80,4);
gas_length = 80;
coarse_dim = 81;
t_tof = [7e-3, 15e-3,30e-3];

sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase_in = sampling_suite.generate_profiles(num_samples);
integrated_contrast_in = zeros(1,num_samples);
rel_phase_in_cg = sampling_suite.coarse_grain(coarse_dim, rel_phase_in);

mid_point = floor(coarse_dim/2)+1;
end_idx_1 = mid_point-60*(coarse_dim-1)/(2*gas_length); 
end_idx_2 = mid_point+60*(coarse_dim-1)/(2*gas_length);

for i = 1: num_samples
    in_phase = rel_phase_in_cg(i,:);
    cut_in_phase = in_phase(end_idx_1:end_idx_2);
    exp_in_phase = arrayfun(@(x) exp(1j*x), cut_in_phase);
    integrated_contrast_in(i) = trapz(gas_length/(coarse_dim-1),exp_in_phase);
end

squared_contrast_in = abs(integrated_contrast_in).^2;
squared_contrast_in = squared_contrast_in/mean(squared_contrast_in);

histogram(squared_contrast_in,'BinWidth',0.15,'Normalization','pdf','FaceColor',[0,0.5,0])
%xlim([0,2])
%ylim([0,1])
xlabel('$\alpha$', 'Interpreter','latex')
ylabel('$P(\alpha)$','Interpreter','latex')
title('Input','Interpreter','latex')