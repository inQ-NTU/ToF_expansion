%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_15nk.mat')
%thermal_cov_15nk file contains two files: cov_phase_fine (400 x 400)
%and cov_phase_coarse (50 x 50)

convolution_strength = linspace(0.002,0.03,16);
SNR = 100;
nmb_sampled_phases = 500;
coarse_dim = 50;
ref_cov = cov_phase_coarse;
%initiate gaussian phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
relative_phase_samples = phase_sampling_suite.generate_profiles(nmb_sampled_phases);
common_phase_samples = phase_sampling_suite.generate_profiles(nmb_sampled_phases);

%coarse graining
relative_phase_samples = phase_sampling_suite.coarse_grain(relative_phase_samples, coarse_dim);
common_phase_samples = phase_sampling_suite.coarse_grain(common_phase_samples, coarse_dim);

%Initializing fidelity matrix
%fidelities_1 -> fidelity for the case of only convolution (no common phase
%no noise)
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
        phase_sample_1 = relative_phase_samples(i,:);
        phase_sample_2 = [relative_phase_samples(i,:); common_phase_samples(i,:)];

        %initializing interference suite
        interference_suite_1 = class_interference_pattern(phase_sample_1);
        interference_suite_2 = class_interference_pattern(phase_sample_2);

        %calculating rho tof
        rho_tof_1 = interference_suite_1.tof_full_expansion();
        rho_tof_1 = interference_suite_1.convolution2d(rho_tof_1, convolution_strength(j));

        rho_tof_2 = interference_suite_2.tof_full_expansion();
        rho_tof_2 = interference_suite_2.convolution2d(rho_tof_2, convolution_strength(j));
        rho_tof_2 = interference_suite_2.add_gaussian_noise(rho_tof_2, 1/SNR);
        
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
save('vary_conv2d_fidelity_stats_and_cov.mat','fidelities_1','fidelities_2','cov_distance_1','cov_distance_2',...
    'relative_phase_samples','common_phase_samples')
if 0
%Plotting the result
fontsize = 28;
fontname = 'Times';
lower_clim = min(min(cov1,[],'all'), min(cov2, [],'all'));
upper_clim = max(max(cov1,[],'all'), max(cov2, [],'all'));
z_grid = linspace(0,100, coarse_dim);

img = figure;

f(1) = subplot(1,3,1);
histogram(fidelities_1, 'Normalization','probability','BinWidth',0.01)
hold on
histogram(fidelities_2, 'Normalization','probability','BinWidth',0.01)
hold off
xlabel('Fidelities ($F$)','Interpreter','latex')
ylabel('Probability','Interpreter','latex')
xlim([0.8,1])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
yticks([0,0.1,0.2,0.3])

g(1) = axes('Position',[.17 .625 .09 .25] );
box on
histogram(delta_fidelities, 'Normalization','probability','FaceColor',"#EDB120")
xlabel('$\Delta F$','Interpreter','latex')
xlim([-0.02,0.02])


f(2) = subplot(1,3,2);
imagesc(z_grid, z_grid, cov1)
xlabel('$z^\prime \; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
ylabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([0,50,100])
clim([lower_clim, upper_clim])

f(3) = subplot(1,3,3);
imagesc(z_grid, z_grid, cov2)
yticks([])
xlabel('$z^\prime\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
clim([lower_clim, upper_clim])
cb = colorbar;
cb.Position = cb.Position + [0.1,0,0,-0.05];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\Gamma_{\phi\phi}$')
set(get(cb,'Title'),'FontSize',fontsize)


title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

colormap(gge_colormap)
set(f, 'FontName',fontname,'FontSize',fontsize)
set(g, 'FontName',fontname,'FontSize',14)
end
