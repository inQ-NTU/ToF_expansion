%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
close all
clear all
addpath('../classes')
addpath('../input')
addpath('Data/')
load('thermal_cov_50nk.mat')
%load('vary_conv2d_fidelity_stats_and_cov.mat')
%thermal_cov_50nk file contains two files: cov_phase_fine (400 x 400)
%and cov_phase_coarse (50 x 50)
convolution_strength = linspace(0.002,0.03,15);
SNR = 100;
nmb_sampled_phases = 500;
coarse_dim = 50;
ref_cov = cov_phase_coarse;


%initiate gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
relative_phase_samples = phase_sampling_suite.generate_profiles(nmb_sampled_phases);
common_phase_samples = phase_sampling_suite.generate_profiles(nmb_sampled_phases);

%coarse graining
relative_phase_coarse = phase_sampling_suite.coarse_grain(relative_phase_samples, coarse_dim);
%common_phase_samples = phase_sampling_suite.coarse_grain(common_phase_samples, coarse_dim);

%Initializing fidelity matrix
%fidelities_1 -> fidelity for the case of convolution and common phase 
%fidelities_2 -> fidelity for the case of all systematic erros: common
%phase + noise + convolution
%Similarly for other variables
fidelities_1 = zeros(length(convolution_strength),nmb_sampled_phases);
fidelities_2 = zeros(length(convolution_strength),nmb_sampled_phases);
cov_distance_1 = zeros(1,length(convolution_strength));
cov_distance_2 = zeros(1,length(convolution_strength));
%Looping through every samples
outer_count = 0;
for j = 1:length(convolution_strength)
    inner_count = 0;
    extracted_relative_phases_1 = zeros(nmb_sampled_phases, coarse_dim);
    extracted_relative_phases_2 = zeros(nmb_sampled_phases,coarse_dim);
    for i = 1:nmb_sampled_phases
        phase_sample = [relative_phase_samples(i,:); common_phase_samples(i,:)];
        %initializing interference suite
        interference_suite = class_interference_pattern(phase_sample);

        %calculating rho tof
        rho_tof = interference_suite.tof_full_expansion();
        rho_tof_1 = interference_suite.convolution2d(rho_tof, convolution_strength(j));
        rho_tof_1 = imresize(rho_tof_1, [coarse_dim, 1.2*coarse_dim]);

        rho_tof_2 = interference_suite.convolution2d(rho_tof, convolution_strength(j));
        rho_tof_2 = imresize(rho_tof_2, [coarse_dim, 1.2*coarse_dim]);
        rho_tof_2 = interference_suite.add_gaussian_noise(rho_tof_2, 1/SNR);

        
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
        f1 = extraction_suite_1.fidelity_coh(relative_phase_coarse(i,:), final_phase_1)
        f2 = extraction_suite_2.fidelity_coh(relative_phase_coarse(i,:), final_phase_2)
        fidelities_1(j,i) = f1;
        fidelities_2(j,i) = f2;
        inner_count = inner_count+1;
        disp(inner_count)
    end
    %Initialize 1d correlation class
    correlation_suite_1 = class_1d_correlation(extracted_relative_phases_1);
    correlation_suite_2 = class_1d_correlation(extracted_relative_phases_2);
    cov1 = correlation_suite_1.cov_matrix;
    cov2 = correlation_suite_2.cov_matrix;
    cov_distance_1(j)= sum(svd(cov1 - ref_cov))/sum(svd(ref_cov))
    cov_distance_2(j)= sum(svd(cov2 - ref_cov))/sum(svd(ref_cov))
    outer_count = outer_count+1;
    disp(outer_count)
end

%reconstructing covariance matrix

%save the data
save('500_samples_repeat_again_vary_conv2d_fidelity_stats_and_cov.mat','fidelities_1','fidelities_2','cov_distance_1','cov_distance_2',...
    'relative_phase_samples','common_phase_samples')


mean_fidelities_1 = zeros(1,length(convolution_strength));
mean_fidelities_2 = zeros(1,length(convolution_strength));
for i = 1:length(convolution_strength)
    mean_fidelities_1(i) = mean(fidelities_1(i,:));
    mean_fidelities_2(i) = mean(fidelities_2(i,:));
end

x0 = [0.5,0.5,0.5,0.5];
fitfun = fittype( @(a,b,c,d,x) a*tanh(b*x+c)+d);
[fitted_fidelity1,gof_fidelity1] = fit(convolution_strength',mean_fidelities_1',fitfun,'StartPoint',x0);
[fitted_fidelity2,gof_fidelity2] = fit(convolution_strength',mean_fidelities_2',fitfun,'StartPoint',x0);

x0 = [-0.1,100,-1, 0.5];
[fitted_cov1, gof_cov1] = fit(convolution_strength(1:end-1)', cov_distance_1(1:end-1)', fitfun, 'StartPoint',x0);
[fitted_cov2, gof_cov2] = fit(convolution_strength', cov_distance_2', fitfun, 'StartPoint',x0);

%Plotting the result
fontsize = 16;
fontname = 'Times';
img = figure;
f = tight_subplot(1,2,[0.1,0.12],[0.2, 0.2],[0.11, 0.11]);

axes(f(1))
plot(convolution_strength, mean_fidelities_1, 'or')
hold on
plot(convolution_strength, mean_fidelities_2,'ob')
plot(fitted_fidelity1,'red')
plot(fitted_fidelity2,'blue')
xlabel('$\sigma_{2D}/L$', 'Interpreter','latex','Fontsize', fontsize)
ylabel('$\bar{F}_{\varphi}$', 'Interpreter','latex', 'FontSize',fontsize)
yticks([0.9,0.91,0.92])
ylim([0.895,0.925])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.23,0.85]);
legend off

axes(f(2))
plot(convolution_strength, cov_distance_1, 'xr')
hold on
plot(convolution_strength, cov_distance_2,'.b','MarkerSize', 14)
plot(fitted_cov1,'red')
plot(fitted_cov2,'blue')
xlabel('$\sigma_{2D}/L$', 'Interpreter','latex','Fontsize', fontsize)
ylabel('$D_{\Gamma}$', 'Interpreter','latex', 'FontSize',fontsize)
%ylim([0.4,0.8])
yticks([0.4,0.5,0.6,0.7,0.8])
legend off
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.22,0.85]);

set(f, 'FontName',fontname,'FontSize',fontsize)
