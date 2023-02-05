%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
close all
addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')
load('fidelity_stats_and_cov.mat')
if 0
%initiate gaussian phase sampling class
nmb_sampled_phases = 500;
coarse_dim = 50;
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
relative_phase_samples = phase_sampling_suite.generate_profiles(nmb_sampled_phases);
common_phase_samples = phase_sampling_suite.generate_profiles(nmb_sampled_phases);

%coarse graining
relative_phase_samples = phase_sampling_suite.coarse_grain(relative_phase_samples, coarse_dim);
common_phase_samples = phase_sampling_suite.coarse_grain(common_phase_samples, coarse_dim);

%Initializing fidelities
fidelities_1 = zeros(1,nmb_sampled_phases);
fidelities_2 = zeros(1,nmb_sampled_phases);
delta_fidelities = zeros(1,nmb_sampled_phases);

extracted_relative_phases_1 = zeros(size(relative_phase_samples));
extracted_relative_phases_2 = zeros(size(relative_phase_samples));

%Looping through every samples
count = 0;
for i = 1:nmb_sampled_phases
    phase_sample_1 = relative_phase_samples(i,:);
    phase_sample_2 = [relative_phase_samples(i,:); common_phase_samples(i,:)];

    %initializing interference suite
    interference_suite_1 = class_interference_pattern(phase_sample_1);
    interference_suite_2 = class_interference_pattern(phase_sample_2);

    %calculating rho tof
    rho_tof_1 = interference_suite_1.tof_full_expansion();
    rho_tof_2 = interference_suite_2.tof_full_expansion();

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
    f1 = extraction_suite_1.fidelity_coh(relative_phase_samples(i,:), final_phase_1)
    f2 = extraction_suite_2.fidelity_coh(relative_phase_samples(i,:), final_phase_2)
    delta_fidelities(i) = f2 - f1;
    fidelities_1(i) = f1;
    fidelities_2(i) = f2;
    count = count+1;
    disp(count)
end

%reconstructing covariance matrix
correlation_suite_1 = class_1d_correlation(extracted_relative_phases_1);
correlation_suite_2 = class_1d_correlation(extracted_relative_phases_2);
cov1 = correlation_suite_1.cov_matrix;
cov2 = correlation_suite_2.cov_matrix;
%save the data
save('fidelity_stats_and_cov.mat','fidelities_2','fidelities_1','delta_fidelities', ...
    'relative_phase_samples','common_phase_samples','extracted_relative_phases_2', ...
    'extracted_relative_phases_1', 'cov1', 'cov2')
end
%Plotting the result
fontsize = 16;
fontname = 'Times';
coarse_dim = 50;
z_grid = linspace(0,100, coarse_dim);

img = figure;
f = tight_subplot(1,2,[0.1,0.1],[0.15, 0.15],[0.15, 0.15]);

axes(f(1))
histogram(fidelities_1, 'Normalization','probability','BinWidth',0.02)
hold on
histogram(fidelities_2, 'Normalization','probability','BinWidth',0.02)
hold off
xlabel('Fidelities ($F$)','Interpreter','latex')
ylabel('Probability','Interpreter','latex')
xlim([0.8,1])
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([0,0.1,0.2,0.3])

g(1) = axes('Position',[.18 .625 .09 .2] );
box on
histogram(delta_fidelities, 'Normalization','probability','FaceColor',"#EDB120",'BinWidth', 0.01)
xlabel('$\Delta F$','Interpreter','latex')
xlim([-0.05,0.05])

axes(f(2))
imagesc(z_grid, z_grid, cov2)
yticks([0,50,100])
xlabel('$z^\prime\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
ylb = ylabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize);
ylb.Position(1) = ylb.Position(1)+2;
cb = colorbar;
clim([0,3])
cb.Position = cb.Position + [0.1,0,0,0];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\Gamma_{\varphi\varphi}$')
set(get(cb,'Title'),'FontSize',fontsize+4)
set(cb,'YTick',[0,1,2,3])
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

colormap(gge_colormap)
set(f, 'FontName',fontname,'FontSize',fontsize)
set(g, 'FontName',fontname,'FontSize',fontsize-6)
