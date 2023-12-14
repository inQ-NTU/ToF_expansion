clear all
close all

load('phase_extraction_bank.mat')
sublength = 15;
coarse_dim = 81;
num_samples = 10000;
gas_length = 80; 

mid_point = floor(coarse_dim/2)+1;
end_idx_1 = floor(mid_point-sublength*(coarse_dim-1)/(2*gas_length)); 
end_idx_2 = floor(mid_point+sublength*(coarse_dim-1)/(2*gas_length));

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

for i = 1:num_samples
    cut_in_phase = rel_phase_in_cg(i,end_idx_1:end_idx_2);
    exp_in_phase = arrayfun(@(x) exp(1j*x), cut_in_phase);
    integrated_contrast_in(i) = trapz(gas_length/(coarse_dim-1),exp_in_phase);

    %cut_ext_phase_trans_1 = ext_phase_trans_1(i, end_idx_1:end_idx_2);
    %exp_phase_trans_1 = arrayfun(@(x) exp(1j*x), cut_ext_phase_trans_1);
    %integrated_contrast_trans_1(i) = trapz(gas_length/(coarse_dim-1), exp_phase_trans_1);

    cut_ext_phase_trans_2 = ext_phase_trans_2(i, end_idx_1:end_idx_2);
    exp_phase_trans_2 = arrayfun(@(x) exp(1j*x), cut_ext_phase_trans_2);
    integrated_contrast_trans_2(i) = trapz(gas_length/(coarse_dim-1), exp_phase_trans_2);

    cut_ext_phase_trans_3 = ext_phase_trans_3(i, end_idx_1:end_idx_2);
    exp_phase_trans_3 = arrayfun(@(x) exp(1j*x), cut_ext_phase_trans_3);
    integrated_contrast_trans_3(i) = trapz(gas_length/(coarse_dim-1), exp_phase_trans_3);

    cut_ext_phase_woc_1 = ext_phase_woc_1(i, end_idx_1:end_idx_2);
    exp_phase_woc_1 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_1);
    integrated_contrast_woc_1(i) = trapz(gas_length/(coarse_dim-1), exp_phase_woc_1);

    cut_ext_phase_woc_2 = ext_phase_woc_2(i, end_idx_1:end_idx_2);
    exp_phase_woc_2 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_2);
    integrated_contrast_woc_2(i) = trapz(gas_length/(coarse_dim-1), exp_phase_woc_2);

    cut_ext_phase_woc_3 = ext_phase_woc_3(i, end_idx_1:end_idx_2);
    exp_phase_woc_3 = arrayfun(@(x) exp(1j*x), cut_ext_phase_woc_3);
    integrated_contrast_woc_3(i) = trapz(gas_length/(coarse_dim-1), exp_phase_woc_3);

    cut_ext_phase_wc_1 = ext_phase_wc_1(i, end_idx_1:end_idx_2);
    exp_phase_wc_1 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_1);
    integrated_contrast_wc_1(i) = trapz(gas_length/(coarse_dim-1), exp_phase_wc_1);

    cut_ext_phase_wc_2 = ext_phase_wc_2(i, end_idx_1:end_idx_2);
    exp_phase_wc_2 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_2);
    integrated_contrast_wc_2(i) = trapz(gas_length/(coarse_dim-1), exp_phase_wc_2);

    cut_ext_phase_wc_3 = ext_phase_wc_3(i, end_idx_1:end_idx_2);
    exp_phase_wc_3 = arrayfun(@(x) exp(1j*x), cut_ext_phase_wc_3);
    integrated_contrast_wc_3(i) = trapz(gas_length/(coarse_dim-1), exp_phase_wc_3);
end

squared_contrast_in = abs(integrated_contrast_in).^2;
squared_contrast_in = squared_contrast_in/mean(squared_contrast_in);

%squared_contrast_trans_1 = abs(integrated_contrast_trans_1).^2;
%squared_contrast_trans_1 = squared_contrast_trans_1/mean(squared_contrast_trans_1);

%squared_contrast_trans_2 = abs(integrated_contrast_trans_2).^2;
%squared_contrast_trans_2 = squared_contrast_trans_2/mean(squared_contrast_trans_2);

%squared_contrast_trans_3 = abs(integrated_contrast_trans_3).^2;
%squared_contrast_trans_3 = squared_contrast_trans_3/mean(squared_contrast_trans_3);

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
f(1) = subplot(1,3,1);
histogram(squared_contrast_in,'Normalization','pdf','FaceColor',[0,0.5,0])
xlabel('$\alpha$', 'Interpreter','latex')
ylabel('$P(\alpha)$','Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
%title('Input','Interpreter','latex')
ylim([0,0.7])
%ylim([0,3])
%f(2) = subplot(1,4,2);
%histogram(squared_contrast_trans_3,'Normalization','pdf')
%hold on
%histogram(squared_contrast_trans_2,'Normalization','pdf')
%histogram(squared_contrast_trans_1,'Normalization','pdf')
%yticks([])
%xlabel('$\alpha$', 'Interpreter','latex')
%legend({'$t = 30 \; ms$','$t = 15 \; ms$', '$t = 7 \; ms$'},'Interpreter','latex')
%title('Transversal','Interpreter','latex')
%ylim([0,0.8])
f(2) = subplot(1,3,2);
histogram(squared_contrast_woc_3,'Normalization','pdf')
hold on
histogram(squared_contrast_woc_2,'Normalization','pdf')
histogram(squared_contrast_woc_1,'Normalization','pdf')
yticks([])
xlabel('$\alpha$', 'Interpreter','latex')
%title('Full with $\varphi_c = 0$','Interpreter','latex')
%ylim([0,3])
ylim([0,0.7])
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
f(3) = subplot(1,3,3);
histogram(squared_contrast_wc_3,'Normalization','pdf')
hold on
histogram(squared_contrast_wc_2,'Normalization','pdf')
histogram(squared_contrast_wc_1,'Normalization','pdf')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
yticks([])
xlabel('$\alpha$', 'Interpreter','latex')
%title('Full with $\varphi_c \neq 0$','Interpreter','latex')
%ylim([0,3])
ylim([0,0.7])
sgtitle('$\mathbf{L = 30\; \mu m}$', 'Interpreter','latex', 'FontSize',18)
set(f, 'FontName','Times','FontSize', 14)