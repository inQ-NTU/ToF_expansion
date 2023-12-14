%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
close all
addpath('../classes')
addpath('../input')
addpath('Data/')
load('thermal_cov_50nk.mat')
load('vary_SNR_fidelity_stats_and_cov.mat')
%thermal_cov_50nk file contains two files: cov_phase_fine (400 x 400)
%and cov_phase_coarse (50 x 50)
SNR = [3000,2000,1000,800,400,100,90,80,70,60,50,40,30,20,10];
log_SNR = log10(SNR);
nmb_sampled_phases = 200;
coarse_dim = 50;
ref_cov = cov_phase_coarse;
if 0
%initiate gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
relative_phase_samples = phase_sampling_suite.generate_profiles(nmb_sampled_phases);
common_phase_samples = phase_sampling_suite.generate_profiles(nmb_sampled_phases);

%coarse graining
relative_phase_samples = phase_sampling_suite.coarse_grain(relative_phase_samples, coarse_dim);
common_phase_samples = phase_sampling_suite.coarse_grain(common_phase_samples, coarse_dim);

%Initializing fidelity matrix
%fidelities_1 -> fidelity for the case of noise and common phase 
%fidelities_2 -> fidelity for the case of all systematic erros: common
%phase + noise + convolution
%Similarly for other variables
fidelities_1 = zeros(length(SNR),nmb_sampled_phases);
fidelities_2 = zeros(length(SNR),nmb_sampled_phases);
cov_distance_1 = zeros(1,length(SNR));
cov_distance_2 = zeros(1,length(SNR));
%Looping through every samples
outer_count = 0;
for j = 1:length(SNR)
    inner_count = 0;
    extracted_relative_phases_1 = zeros(nmb_sampled_phases, coarse_dim);
    extracted_relative_phases_2 = zeros(nmb_sampled_phases,coarse_dim);
    for i = 1:nmb_sampled_phases
        phase_sample = [relative_phase_samples(i,:); common_phase_samples(i,:)];
        %initializing interference suite
        interference_suite = class_interference_pattern(phase_sample);

        %calculating rho tof
        rho_tof = interference_suite.tof_full_expansion();
        rho_tof_1 = interference_suite.add_gaussian_noise(rho_tof,1/SNR(j));

        rho_tof_2 = interference_suite.convolution2d(rho_tof);
        rho_tof_2 = interference_suite.add_gaussian_noise(rho_tof_2, 1/SNR(j));
        
        %phase extraction suite
        extraction_suite_1 = class_phase_extraction(rho_tof_1);
        extraction_suite_2 = class_phase_extraction(rho_tof_2);

        init_phase_1 = extraction_suite_1.init_phase_guess();
        final_phase_1 = extraction_suite_1.fitting(init_phase_1);
        init_phase_2 = extraction_suite_2.init_phase_guess();
        final_phase_2 = extraction_suite_2.fitting(init_phase_2);

        %saving the extracted phase profiles
        extracted_relative_phases_1(i,:) = final_phase_1;
        extracted_relative_phases_2(i,:) = final_phase_2;

        %compute fidelities
        fidelities_1(j,i) = extraction_suite_1.fidelity_coh(relative_phase_samples(i,:), final_phase_1);
        fidelities_2(j,i) = extraction_suite_2.fidelity_coh(relative_phase_samples(i,:), final_phase_2);
        inner_count = inner_count+1;
        disp(inner_count)
    end
    %Initialize 1d correlation class
    correlation_suite_1 = class_1d_correlation(extracted_relative_phases_1);
    correlation_suite_2 = class_1d_correlation(extracted_relative_phases_2);
    cov1 = correlation_suite_1.cov_matrix;
    cov2 = correlation_suite_2.cov_matrix;
    cov_distance_1(j)= norm(cov1 - ref_cov)/norm(ref_cov);
    cov_distance_2(j)= norm(cov2 - ref_cov)/norm(ref_cov);
    outer_count = outer_count+1;
    disp(outer_count)
end

%reconstructing covariance matrix

%save the data
%save('vary_SNR_fidelity_stats_and_cov.mat','fidelities_1','fidelities_2','cov_distance_1','cov_distance_2',...
%    'relative_phase_samples','common_phase_samples')
end

%Calculate the mean fidelities
mean_fidelities_1 = zeros(1,length(SNR));
mean_fidelities_2 = zeros(1,length(SNR));
for i = 1:length(SNR)
    mean_fidelities_1(i) = mean(fidelities_1(i,:));
    mean_fidelities_2(i) = mean(fidelities_2(i,:));
end
%Fitting the data with exponential function
% Define Start points, fit-function and fit curve
x0 = [2,1,-1];
fitfun = fittype( @(a,b,c,x) a*exp(-b*x)+c);
[fitted_fidelity1,gof_fidelity1] = fit(log_SNR',mean_fidelities_1',fitfun,'StartPoint',x0);
[fitted_fidelity2,gof_fidelity2] = fit(log_SNR',mean_fidelities_2',fitfun,'StartPoint',x0);

x0 = [1,1,1];
[fitted_cov1, gof_cov1] = fit(log_SNR', cov_distance_1', fitfun, 'StartPoint',x0);
[fitted_cov2, gof_cov2] = fit(log_SNR', cov_distance_2', fitfun, 'StartPoint',x0);
%Plotting the result
fontsize = 16;
fontname = 'Times';
img = figure;
f = tight_subplot(1,2,[0.1,0.12],[0.2, 0.2],[0.11, 0.11]);

axes(f(1))
plot(log_SNR, mean_fidelities_1, 'or')
hold on
plot(log_SNR, mean_fidelities_2,'ob')
plot(fitted_fidelity1,'red')
plot(fitted_fidelity2,'blue')
xlim([1,3.5])
ylim([0.82, 0.94])
yticks([0.82, 0.86, 0.9, 0.94])
xticks([1,2,3])
xlabel('$\log_{10}(SNR)$', 'Interpreter','latex','Fontsize', fontsize)
ylabel('$\bar{F}_{\varphi}$', 'Interpreter','latex', 'FontSize',fontsize)
legend off
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.23,0.85]);


axes(f(2))
plot(log_SNR, cov_distance_1, 'xr','MarkerSize',8)
hold on
plot(log_SNR, cov_distance_2,'.b','MarkerSize', 14)
plot(fitted_cov1,'red')
plot(fitted_cov2,'blue')
xlim([1,3.5])
ylim([0.05,0.7])
yticks([0.1,0.3,0.5,0.7])
xticks([0,1,2,3])
xlabel('$\log_{10}(SNR)$', 'Interpreter','latex','Fontsize', fontsize)
ylabel('$D_{\Gamma}$', 'Interpreter','latex', 'FontSize',fontsize)
legend off
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.22,0.85]);

set(f, 'FontName',fontname,'FontSize',fontsize)
set(gcf,'PaperType','A4')