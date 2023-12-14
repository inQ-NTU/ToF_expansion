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
coarse_dim = 80;
nmb_sampled_phases = 200;
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3;
%n_cutoff = 30;

rel_phase_profiles = phase_sampling_suite.generate_profiles(nmb_sampled_phases);
com_phase_profiles = phase_sampling_suite.generate_profiles(nmb_sampled_phases);

reference_rel_profiles = phase_sampling_suite.reference_profiles(rel_phase_profiles);
reference_com_profiles = phase_sampling_suite.reference_profiles(com_phase_profiles);

coarse_rel_profiles = phase_sampling_suite.coarse_grain(coarse_dim, reference_rel_profiles);
coarse_com_profiles = phase_sampling_suite.coarse_grain(coarse_dim, reference_com_profiles);


all_input_fourier = zeros(nmb_sampled_phases, coarse_dim/2+1);

all_trans_fourier_1 = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_woc_fourier_1 = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_wc_fourier_1 = zeros(nmb_sampled_phases, coarse_dim/2+1);

all_trans_fourier_2 = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_woc_fourier_2 = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_wc_fourier_2 = zeros(nmb_sampled_phases, coarse_dim/2+1);

all_trans_fourier_3 = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_woc_fourier_3 = zeros(nmb_sampled_phases, coarse_dim/2+1);
all_wc_fourier_3 = zeros(nmb_sampled_phases, coarse_dim/2+1);

count = 0;
for i = 1:nmb_sampled_phases
    %Compute input fourier spectrum
    fourier_input = abs(fft(coarse_rel_profiles(i,:))/sqrt(coarse_dim));
    fourier_input = fourier_input(1:coarse_dim/2+1);% Single sampling plot

    all_input_fourier(i,:) = fourier_input;

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
    fourier_trans_1 = abs(fft(fitted_phase_1_trans)/sqrt(coarse_dim));
    all_trans_fourier_1(i,:) = fourier_trans_1(1:coarse_dim/2+1);
    fourier_trans_2 = abs(fft(fitted_phase_2_trans))/sqrt(coarse_dim);
    all_trans_fourier_2(i,:) = fourier_trans_2(1:coarse_dim/2+1);
    fourier_trans_3 = abs(fft(fitted_phase_3_trans))/sqrt(coarse_dim);
    all_trans_fourier_3(i,:) = fourier_trans_3(1:coarse_dim/2+1);

    fourier_woc_1 = abs(fft(fitted_phase_1_woc))/sqrt(coarse_dim);
    all_woc_fourier_1(i,:) = fourier_woc_1(1:coarse_dim/2+1);
    fourier_woc_2 = abs(fft(fitted_phase_2_woc))/sqrt(coarse_dim);
    all_woc_fourier_2(i,:) = fourier_woc_2(1:coarse_dim/2+1);
    fourier_woc_3 = abs(fft(fitted_phase_3_woc))/sqrt(coarse_dim);
    all_woc_fourier_3(i,:) = fourier_woc_3(1:coarse_dim/2+1);

    fourier_wc_1 = abs(fft(fitted_phase_1_wc))/sqrt(coarse_dim);
    all_wc_fourier_1(i,:) = fourier_wc_1(1:coarse_dim/2+1);
    fourier_wc_2 = abs(fft(fitted_phase_2_wc))/sqrt(coarse_dim);
    all_wc_fourier_2(i,:) = fourier_wc_2(1:coarse_dim/2+1);
    fourier_wc_3 = abs(fft(fitted_phase_3_wc))/sqrt(coarse_dim);
    all_wc_fourier_3(i,:) = fourier_wc_3(1:coarse_dim/2+1);
    
    count = count+1;
    disp(count)
end

%analysis
%Compute fourier RMSE
rmse_trans_1 = zeros(1, coarse_dim/2+1);
rmse_trans_2 = zeros(1, coarse_dim/2+1);
rmse_trans_3 = zeros(1, coarse_dim/2+1);

rmse_woc_1 = zeros(1, coarse_dim/2+1);
rmse_woc_2 = zeros(1, coarse_dim/2+1);
rmse_woc_3 = zeros(1, coarse_dim/2+1);

rmse_wc_1 = zeros(1, coarse_dim/2+1);
rmse_wc_2 = zeros(1, coarse_dim/2+1);
rmse_wc_3 = zeros(1, coarse_dim/2+1);

for i = 1:coarse_dim/2+1
    rmse_trans_1(i) = rmse(all_input_fourier(:,i), all_trans_fourier_1(:,i));
    rmse_trans_2(i) = rmse(all_input_fourier(:,i), all_trans_fourier_2(:,i));
    rmse_trans_3(i) = rmse(all_input_fourier(:,i), all_trans_fourier_3(:,i));

    rmse_woc_1(i) = rmse(all_input_fourier(:,i), all_woc_fourier_1(:,i));
    rmse_woc_2(i) = rmse(all_input_fourier(:,i), all_woc_fourier_2(:,i));
    rmse_woc_3(i) = rmse(all_input_fourier(:,i), all_woc_fourier_3(:,i));

    rmse_wc_1(i) = rmse(all_input_fourier(:,i), all_wc_fourier_1(:,i));
    rmse_wc_2(i) = rmse(all_input_fourier(:,i), all_wc_fourier_2(:,i));
    rmse_wc_3(i) = rmse(all_input_fourier(:,i), all_wc_fourier_3(:,i));
end

%Plotting the root mean square
f(1) = subplot(1,3,1);
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_trans_1,'o-','Color', 'blue')
hold on
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_trans_2,'x-','Color', 'red')
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_trans_3,'^-','Color',[0,0.7,0])
ylim([0,1])
ylabel('RMSE $\Delta \varphi_n$','Interpreter','latex')
xlabel('$n$','Interpreter','latex')
title('Transversal','Interpreter','latex')
f(2) = subplot(1,3,2);
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_woc_1,'o-', 'Color','blue')
hold on
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_woc_2,'x-','Color','red')
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_woc_3,'^-','Color', [0,0.7,0])
ylim([0,1])
yticks([])
xlabel('$n$','Interpreter','latex')
title('Full with $\varphi_c = 0$','Interpreter','latex')

f(3) = subplot(1,3,3);
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_wc_1,'o-','Color', 'blue')
hold on
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_wc_2,'x-', 'Color', 'red')
plot(linspace(0,coarse_dim/2, coarse_dim/2+1), rmse_wc_3,'^-','Color', [0,0.7,0])
ylim([0,1])
xlabel('$n$','Interpreter','latex')
title('Full with $\varphi_c \neq 0$','Interpreter','latex')
yticks([])

set(f, 'FontName','Times','FontSize', 16)
save('fourier_RMSE.mat', 'all_input_fourier','all_trans_fourier_1', 'all_trans_fourier_2',...
'all_trans_fourier_3','all_wc_fourier_1', 'all_wc_fourier_2','all_wc_fourier_3', 'all_woc_fourier_1',...
'all_woc_fourier_2','all_woc_fourier_3', 'rmse_trans_1','rmse_trans_2', 'rmse_trans_3',...
'rmse_woc_1', 'rmse_woc_2', 'rmse_woc_3', 'rmse_wc_1', 'rmse_wc_2', 'rmse_wc_3')