if 0
clear all
close all

addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')

num_samples = 200;
sub_length_list = linspace(20,80,4);
gas_length = 80;
coarse_dim = 81;
t_tof = [7e-3, 15e-3,30e-3];

sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase_in = sampling_suite.generate_profiles(num_samples);
com_phase_in = sampling_suite.generate_profiles(num_samples);
rel_phase_in_cg = sampling_suite.coarse_grain(coarse_dim, rel_phase_in);

integrated_contrast_in = zeros(1,num_samples);

integrated_contrast_trans_1 = zeros(1, num_samples);
integrated_contrast_trans_2 = zeros(1, num_samples);
integrated_contrast_trans_3 = zeros(1, num_samples);

integrated_contrast_woc_1 = zeros(1, num_samples);
integrated_contrast_woc_2 = zeros(1, num_samples);
integrated_contrast_woc_3 = zeros(1, num_samples);

integrated_contrast_wc_1 = zeros(1, num_samples);
integrated_contrast_wc_2 = zeros(1, num_samples);
integrated_contrast_wc_3 = zeros(1, num_samples);


mid_point = floor(coarse_dim/2)+1;
end_idx_1 = mid_point-sub_length_list(4)*(coarse_dim-1)/(2*gas_length); 
end_idx_2 = mid_point+sub_length_list(4)*(coarse_dim-1)/(2*gas_length);

count = 0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern(rel_phase_in(i,:),t_tof(1));
    interference_suite_woc_2 = class_interference_pattern(rel_phase_in(i,:),t_tof(2));
    interference_suite_woc_3 = class_interference_pattern(rel_phase_in(i,:),t_tof(3));

    interference_suite_wc_1 = class_interference_pattern([rel_phase_in(i,:); com_phase_in(i,:)], t_tof(1));
    interference_suite_wc_2 = class_interference_pattern([rel_phase_in(i,:); com_phase_in(i,:)], t_tof(2));
    interference_suite_wc_3 = class_interference_pattern([rel_phase_in(i,:); com_phase_in(i,:)], t_tof(3));

    rho_trans_1 = imresize(interference_suite_woc_1.tof_transversal_expansion(),[coarse_dim, 1.2*coarse_dim]);
    rho_trans_2 = imresize(interference_suite_woc_2.tof_transversal_expansion(),[coarse_dim, 1.2*coarse_dim]);
    rho_trans_3 = imresize(interference_suite_woc_3.tof_transversal_expansion(),[coarse_dim, 1.2*coarse_dim]);
    
    rho_full_woc_1 = imresize(interference_suite_woc_1.tof_full_expansion(), [coarse_dim, 1.2*coarse_dim]);
    rho_full_woc_2 = imresize(interference_suite_woc_2.tof_full_expansion(), [coarse_dim, 1.2*coarse_dim]);
    rho_full_woc_3 = imresize(interference_suite_woc_3.tof_full_expansion(), [coarse_dim, 1.2*coarse_dim]);

    rho_full_wc_1 = imresize(interference_suite_wc_1.tof_full_expansion(), [coarse_dim, 1.2*coarse_dim]);
    rho_full_wc_2 = imresize(interference_suite_wc_2.tof_full_expansion(), [coarse_dim, 1.2*coarse_dim]);
    rho_full_wc_3 = imresize(interference_suite_wc_3.tof_full_expansion(), [coarse_dim, 1.2*coarse_dim]);
    
    ext_suite_trans_1 = class_phase_extraction(rho_trans_1, t_tof(1));
    ext_suite_trans_2 = class_phase_extraction(rho_trans_2, t_tof(2));
    ext_suite_trans_3 = class_phase_extraction(rho_trans_3, t_tof(3));
    
    ext_suite_woc_1 = class_phase_extraction(rho_full_woc_1, t_tof(1));
    ext_suite_woc_2 = class_phase_extraction(rho_full_woc_2, t_tof(2));
    ext_suite_woc_3 = class_phase_extraction(rho_full_woc_3, t_tof(3));

    ext_suite_wc_1 = class_phase_extraction(rho_full_wc_1, t_tof(1));
    ext_suite_wc_2 = class_phase_extraction(rho_full_wc_2, t_tof(2));
    ext_suite_wc_3 = class_phase_extraction(rho_full_wc_3, t_tof(3));

    ext_phase_trans_1 = ext_suite_trans_1.fitting(ext_suite_trans_1.init_phase_guess());
    ext_phase_trans_2 = ext_suite_trans_2.fitting(ext_suite_trans_2.init_phase_guess());
    ext_phase_trans_3 = ext_suite_trans_3.fitting(ext_suite_trans_3.init_phase_guess());

    ext_phase_woc_1 = ext_suite_woc_1.fitting(ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2 = ext_suite_woc_2.fitting(ext_suite_woc_2.init_phase_guess());
    ext_phase_woc_3 = ext_suite_woc_3.fitting(ext_suite_woc_3.init_phase_guess());
    
    ext_phase_wc_1 = ext_suite_wc_1.fitting(ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2 = ext_suite_wc_2.fitting(ext_suite_wc_2.init_phase_guess());
    ext_phase_wc_3 = ext_suite_wc_3.fitting(ext_suite_wc_3.init_phase_guess());

    cut_ext_phase_trans_1 = ext_phase_trans_1(end_idx_1:end_idx_2);
    exp_phase_trans_1 = arrayfun(@(x) exp(1j*x), cut_ext_phase_trans_1);
    integrated_contrast_trans_1(i) = trapz(gas_length/(coarse_dim-1), exp_phase_trans_1);

    cut_ext_phase_trans_2 = ext_phase_trans_2(end_idx_1:end_idx_2);
    exp_phase_trans_2 = arrayfun(@(x) exp(1j*x), cut_ext_phase_trans_2);
    integrated_contrast_trans_2(i) = trapz(gas_length/(coarse_dim-1), exp_phase_trans_2);

    cut_ext_phase_trans_3 = ext_phase_trans_3(end_idx_1:end_idx_2);
    exp_phase_trans_3 = arrayfun(@(x) exp(1j*x), cut_ext_phase_trans_3);
    integrated_contrast_trans_3(i) = trapz(gas_length/(coarse_dim-1), exp_phase_trans_3);

    cut_ext_phase_woc_1 = ext_phase_woc_1(end_idx_1:end_idx_2);
    exp_phase_woc_1 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_1);
    integrated_contrast_woc_1(i) = trapz(gas_length/(coarse_dim-1), exp_phase_woc_1);

    cut_ext_phase_woc_2 = ext_phase_woc_2(end_idx_1:end_idx_2);
    exp_phase_woc_2 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_2);
    integrated_contrast_woc_2(i) = trapz(gas_length/(coarse_dim-1), exp_phase_woc_2);

    cut_ext_phase_woc_3 = ext_phase_woc_3(end_idx_1:end_idx_2);
    exp_phase_woc_3 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_3);
    integrated_contrast_woc_3(i) = trapz(gas_length/(coarse_dim-1), exp_phase_woc_3);

    cut_ext_phase_wc_1 = ext_phase_wc_1(end_idx_1:end_idx_2);
    exp_phase_wc_1 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_1);
    integrated_contrast_wc_1(i) = trapz(gas_length/(coarse_dim-1), exp_phase_wc_1);

    cut_ext_phase_wc_2 = ext_phase_wc_2(end_idx_1:end_idx_2);
    exp_phase_wc_2 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_2);
    integrated_contrast_wc_2(i) = trapz(gas_length/(coarse_dim-1), exp_phase_wc_2);

    cut_ext_phase_wc_3 = ext_phase_wc_3(end_idx_1:end_idx_2);
    exp_phase_wc_3 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_3);
    integrated_contrast_wc_3(i) = trapz(gas_length/(coarse_dim-1), exp_phase_wc_3);

    in_phase = rel_phase_in_cg(i,:);
    cut_in_phase = in_phase(end_idx_1:end_idx_2);
    exp_in_phase = arrayfun(@(x) exp(1j*x), cut_in_phase);
    integrated_contrast_in(i) = trapz(gas_length/(coarse_dim-1),exp_in_phase);
    count = count+1;
    disp(count)
end
save('integrated_contrast_75nk_80microns_200samples.mat', 'integrated_contrast_in', 'integrated_contrast_trans_1',...
    'integrated_contrast_trans_2', 'integrated_contrast_trans_3', 'integrated_contrast_woc_1', 'integrated_contrast_woc_2',...
    'integrated_contrast_woc_3','integrated_contrast_wc_1', 'integrated_contrast_wc_2', 'integrated_contrast_wc_3');
end
%if 0
%load('integrated_contrast_75nk_20microns_200samples.mat')
%Analysis
squared_contrast_in = abs(integrated_contrast_in).^2;
squared_contrast_in = squared_contrast_in/mean(squared_contrast_in);

squared_contrast_trans_1 = abs(integrated_contrast_trans_1).^2;
squared_contrast_trans_1 = squared_contrast_trans_1/mean(squared_contrast_trans_1);

squared_contrast_trans_2 = abs(integrated_contrast_trans_2).^2;
squared_contrast_trans_2 = squared_contrast_trans_2/mean(squared_contrast_trans_2);

squared_contrast_trans_3 = abs(integrated_contrast_trans_3).^2;
squared_contrast_trans_3 = squared_contrast_trans_3/mean(squared_contrast_trans_3);

squared_contrast_woc_1 = abs(integrated_contrast_woc_1).^2;
squared_contrast_woc_1 = squared_contrast_woc_1/mean(squared_contrast_woc_1);

squared_contrast_woc_2 = abs(integrated_contrast_woc_2).^2;
squared_contrast_woc_2 = squared_contrast_woc_2/mean(squared_contrast_woc_2);

squared_contrast_woc_3 = abs(integrated_contrast_woc_3).^2;
squared_contrast_woc_3 = squared_contrast_woc_3/mean(squared_contrast_woc_3);

squared_contrast_wc_1 = abs(integrated_contrast_wc_1).^2;
squared_contrast_wc_1 = squared_contrast_wc_1/mean(squared_contrast_wc_1);

squared_contrast_wc_2 = abs(integrated_contrast_wc_2).^2;
squared_contrast_wc_2 = squared_contrast_wc_2/mean(squared_contrast_wc_2);

squared_contrast_wc_3 = abs(integrated_contrast_wc_3).^2;
squared_contrast_wc_3 = squared_contrast_wc_3/mean(squared_contrast_wc_3);
%Plotting
f(1) = subplot(1,4,1);
histogram(squared_contrast_in,'BinWidth',0.2,'Normalization','pdf','FaceColor',[0,0.5,0])
xlim([0,2])
ylim([0,1])
xlabel('$\alpha$', 'Interpreter','latex')
ylabel('$P(\alpha)$','Interpreter','latex')
title('Input','Interpreter','latex')
f(2) = subplot(1,4,2);
histogram(squared_contrast_trans_3,'BinWidth',0.2,'Normalization','pdf')
hold on
histogram(squared_contrast_trans_2,'BinWidth',0.2,'Normalization','pdf')
histogram(squared_contrast_trans_1,'BinWidth',0.2,'Normalization','pdf')
xlim([0,2])
ylim([0,1])
yticks([])
xlabel('$\alpha$', 'Interpreter','latex')
legend({'$t = 30 \; ms$','$t = 15 \; ms$', '$t = 7 \; ms$'},'Interpreter','latex')
title('Transversal','Interpreter','latex')
f(3) = subplot(1,4,3);
histogram(squared_contrast_woc_3,'BinWidth',0.2,'Normalization','pdf')
hold on
histogram(squared_contrast_woc_2,'BinWidth',0.2,'Normalization','pdf')
histogram(squared_contrast_woc_1,'BinWidth',0.2,'Normalization','pdf')
xlim([0,2])
ylim([0,1])
yticks([])
xlabel('$\alpha$', 'Interpreter','latex')
title('Full with $\varphi_c = 0$','Interpreter','latex')
f(4) = subplot(1,4,4);
histogram(squared_contrast_wc_3,'BinWidth',0.2,'Normalization','pdf')
hold on
histogram(squared_contrast_wc_2,'BinWidth',0.2,'Normalization','pdf')
histogram(squared_contrast_wc_1,'BinWidth',0.2,'Normalization','pdf')
xlim([0,2])
ylim([0,1])
yticks([])
xlabel('$\alpha$', 'Interpreter','latex')
title('Full with $\varphi_c \neq 0$','Interpreter','latex')

sgtitle('$\mathbf{T = 100\; nK, \; L = 20\; \mu m}$', 'Interpreter','latex', 'FontSize',18)
set(f, 'FontName','Times','FontSize', 16)
%end