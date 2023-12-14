clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')
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

t_tof_1 = 15e-3;
t_tof_2 = 30e-3;

gradient_vec_1_woc = zeros(num_samples, coarse_resolution_z);
gradient_vec_2_woc = zeros(num_samples, coarse_resolution_z);
gradient_vec_1_woc = zeros(num_samples, coarse_resolution_z);
gradient_vec_2_woc = zeros(num_samples, coarse_resolution_z);
gradient_vec_in = zeros(num_samples, coarse_resolution_z);
rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);
cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);
count = 0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_woc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion(); 
    rho_tof_woc_1 = imresize(rho_tof_woc_1, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_woc_2 = imresize(rho_tof_woc_2, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
    phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
    ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    gradient_vec_in(i,:) = gradient(cg_rel_phase(i,:));
    gradient_vec_1(i,:) = gradient(ext_phase_woc_1);
    gradient_vec_2(i,:) = gradient(ext_phase_woc_2);
    count = count +1;
    disp(count)
end

save('phase_grad_stats_with_common_phase.mat', 'gradient_vec_in', 'gradient_vec_1', 'gradient_vec_2')
end
load('phase_grad_stats_with_common_phase.mat')
%Compute the correlation
corr_in = class_1d_correlation(gradient_vec_in);
corr1 = class_1d_correlation(gradient_vec_1);
corr2 = class_1d_correlation(gradient_vec_2);
cov_in = corr_in.covariance_matrix();
cov1 = corr1.covariance_matrix();
cov2 = corr2.covariance_matrix();

f(1) = subplot(1,3,1);
imagesc(z_grid_coarse, z_grid_coarse, cov_in)
clim([-0.05,0.05])
ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex')
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
f(2) = subplot(1,3,2);
imagesc(z_grid_coarse, z_grid_coarse, cov1)
clim([-0.05,0.05])
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
f(3) = subplot(1,3,3);
imagesc(z_grid_coarse, z_grid_coarse, cov2)
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.09,0.01,0,-0.05];
set(get(cb,'YLabel'),'Interpreter','latex')
set(get(cb,'YLabel'),'String','$C_u(z,z^\prime)$')
set(get(cb,'YLabel'),'FontSize',10)
cb.Ruler.Exponent = -2;
clim([-0.05,0.05])
colormap(gge_colormap)
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
set(f, 'FontName', 'Times', 'FontSize', 10)


