clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_25nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 1e-6;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = transversal_length/pixel_width;
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z+1).*1e6;
num_samples = 500;
momentum_cutoff = 40;
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3; 
if 0
%Generate samples
rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);


ext_phase_woc_1_all = zeros(num_samples, coarse_resolution_z);
ext_phase_woc_2_all = zeros(num_samples, coarse_resolution_z);
ext_phase_woc_3_all = zeros(num_samples, coarse_resolution_z);

ext_phase_wc_1_all = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_2_all = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_3_all = zeros(num_samples, coarse_resolution_z);

%Fourier amplitude
fourier_amp_woc_1 = zeros(num_samples, coarse_resolution_z);
fourier_amp_woc_2 = zeros(num_samples, coarse_resolution_z);
fourier_amp_woc_3 = zeros(num_samples, coarse_resolution_z);

fourier_amp_wc_1 = zeros(num_samples, coarse_resolution_z);
fourier_amp_wc_2 = zeros(num_samples, coarse_resolution_z);
fourier_amp_wc_3 = zeros(num_samples, coarse_resolution_z);

fourier_amp_in = zeros(num_samples, coarse_resolution_z);

%input fourier
cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);
count = 0;
for i = 1:num_samples
    %without common phase
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t_tof_2);
    interference_suite_woc_3 = class_interference_pattern(rel_phase(i,:), t_tof_3);
    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_woc_1 = imresize(rho_tof_woc_1, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_woc_2 = imresize(rho_tof_woc_2, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_woc_3 = interference_suite_woc_3.tof_full_expansion();
    rho_tof_woc_3 = imresize(rho_tof_woc_3, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
    phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
    phase_ext_suite_woc_3 = class_phase_extraction(rho_tof_woc_3, t_tof_3);
    ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    ext_phase_woc_3 = phase_ext_suite_woc_3.fitting(phase_ext_suite_woc_3.init_phase_guess());
    %with common phase
    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    interference_suite_wc_3 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_3);
    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_wc_1 = imresize(rho_tof_wc_1, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
    rho_tof_wc_2 = imresize(rho_tof_wc_2, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_wc_3 = interference_suite_wc_3.tof_full_expansion();
    rho_tof_wc_3 = imresize(rho_tof_wc_3, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
    phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);
    phase_ext_suite_wc_3 = class_phase_extraction(rho_tof_wc_3, t_tof_3);
    ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());
    ext_phase_wc_3 = phase_ext_suite_wc_3.fitting(phase_ext_suite_wc_3.init_phase_guess());
    %Saving the extracted phase
    ext_phase_woc_1_all(i,:) = ext_phase_woc_1;
    ext_phase_woc_2_all(i,:) = ext_phase_woc_2;
    ext_phase_woc_3_all(i,:) = ext_phase_woc_3;
    ext_phase_wc_1_all(i,:) = ext_phase_wc_1;
    ext_phase_wc_2_all(i,:) = ext_phase_wc_2;
    ext_phase_wc_3_all(i,:) = ext_phase_wc_3;
    %Compute the fourier coefficient
    fourier_amp_woc_1(i,:) = abs(fft(ext_phase_woc_1)/sqrt(coarse_resolution_z));
    fourier_amp_woc_2(i,:) = abs(fft(ext_phase_woc_2)/sqrt(coarse_resolution_z));
    fourier_amp_woc_3(i,:) = abs(fft(ext_phase_woc_3)/sqrt(coarse_resolution_z));
    fourier_amp_wc_1(i,:) = abs(fft(ext_phase_wc_1)/sqrt(coarse_resolution_z));
    fourier_amp_wc_2(i,:) = abs(fft(ext_phase_wc_2)/sqrt(coarse_resolution_z));
    fourier_amp_wc_3(i,:) = abs(fft(ext_phase_wc_3)/sqrt(coarse_resolution_z));
    fourier_amp_in(i,:) = abs(fft(cg_rel_phase(i,:))/sqrt(coarse_resolution_z));
    count = count+1;
    disp(count)
end

save('phase_extraction_and_fourier_spectrum_25nK_500samples.mat', 'rel_phase', 'com_phase', 'cg_rel_phase', 'ext_phase_woc_1_all', 'ext_phase_woc_2_all', 'ext_phase_woc_3_all',...
    'ext_phase_wc_1_all', 'ext_phase_wc_2_all', 'ext_phase_wc_3_all', 'fourier_amp_in', 'fourier_amp_woc_1', 'fourier_amp_woc_2', 'fourier_amp_woc_3',...
    'fourier_amp_wc_1', 'fourier_amp_wc_2', 'fourier_amp_wc_3')
end
load('phase_extraction_and_fourier_spectrum_25nk_500samples.mat')
%Compute mean fourier coefficients
mean_fourier_woc_1 = zeros(1,coarse_resolution_z);
mean_fourier_woc_2 = zeros(1, coarse_resolution_z);
mean_fourier_woc_3 = zeros(1,coarse_resolution_z);

mean_fourier_wc_1 = zeros(1,coarse_resolution_z);
mean_fourier_wc_2 = zeros(1, coarse_resolution_z);
mean_fourier_wc_3 = zeros(1,coarse_resolution_z);

mean_fourier_input = zeros(1,coarse_resolution_z);

for i = 1:coarse_resolution_z
    mean_fourier_woc_1(i,:) = mean(fourier_amp_woc_1(:,i).^2);
    mean_fourier_woc_2(i,:) = mean(fourier_amp_woc_2(:,i).^2);
    mean_fourier_woc_3(i,:) = mean(fourier_amp_woc_3(:,i).^2);

    mean_fourier_wc_1(i,:) = mean(fourier_amp_wc_1(:,i).^2);
    mean_fourier_wc_2(i,:) = mean(fourier_amp_wc_2(:,i).^2);
    mean_fourier_wc_3(i,:) = mean(fourier_amp_wc_3(:,i).^2);

    mean_fourier_input(i,:) = mean(fourier_amp_in(:,i).^2);
end
%Compute wavevector
k = 2*pi*(1:momentum_cutoff)/100;
%Plotting
f(1) = subplot(2,2,1);
plot(k(5:momentum_cutoff), mean_fourier_input(5:momentum_cutoff), 'Black','LineWidth', 1.2)
hold on
plot(k(5:momentum_cutoff), mean_fourier_woc_1(5:momentum_cutoff), '-o','Color', 'Blue', 'MarkerSize', 4)
plot(k(5:momentum_cutoff), mean_fourier_woc_2(5:momentum_cutoff), '-x','Color','Red')
plot(k(5:momentum_cutoff), mean_fourier_woc_3(5:momentum_cutoff), '-^','Color',[0,0.7,0], 'MarkerSize', 4)
xlim([0,2.5])
xticks([])
ax = gca();
ax.YRuler.Exponent = -1;
yticks([0,0.1,0.2])
ylabel('$|\Phi_k|$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.25,0.85]);
f(2) = subplot(2,2,2);
plot(k(5:momentum_cutoff), mean_fourier_input(5:momentum_cutoff), 'Black','LineWidth', 1.2)
hold on
plot(k(5:momentum_cutoff), mean_fourier_wc_1(5:momentum_cutoff), '-o','Color','Blue', 'MarkerSize', 4)
plot(k(5:momentum_cutoff), mean_fourier_wc_2(5:momentum_cutoff), '-x','Color','Red')
plot(k(5:momentum_cutoff), mean_fourier_wc_3(5:momentum_cutoff), '-^','Color',[0,0.7,0], 'MarkerSize', 4)
xlim([0,2.5])
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
f(3) = subplot(2,2,3);
plot(k, abs(mean_fourier_woc_1(2:momentum_cutoff+1)-mean_fourier_input(2:momentum_cutoff+1)),'-o', 'Color','Blue','MarkerSize', 4)
hold on
plot(k, abs(mean_fourier_woc_2(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)),'x-', 'Color','Red')
plot(k, abs(mean_fourier_woc_3(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)),'^-', 'Color',[0,0.7,0],'MarkerSize' ,4)
xlim([0,2.5])
%ylim([0,0.08])
ax = gca();
ax.YRuler.Exponent = -2;
yticks([0,0.04,0.08])
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.25,0.85]);
xlabel('$k \; (\rm \mu m^{-1})$','Interpreter','latex')
ylabel('$||\Phi_{k}^{\rm (ext)}|-|\Phi_{k}^{\rm (in)}||$','Interpreter','latex')
f(4) = subplot(2,2,4);
plot(k, abs(mean_fourier_wc_1(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)), '-o', 'Color', 'Blue', 'MarkerSize', 4)
hold on
plot(k, abs(mean_fourier_wc_2(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)), 'x-','Color','Red')
plot(k, abs(mean_fourier_wc_3(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)), '^-', 'Color',[0,0.7,0],'MarkerSize',4)
xlim([0,2.5])
%ylim([0,0.08])
yticks([])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xlabel('$k \; (\rm \mu m^{-1})$', 'Interpreter','latex')
set(f, 'FontName', 'Times', 'FontSize', 10)