close all
clear all
addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

l = 80;
coarse_dim = 80;
fine_dim = 400;
x_scale = 1.2;

%phase sampling
sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
rel_phase = sampling_suite.generate_profiles();

%interference
interference_suite = class_interference_pattern(rel_phase);
rho_tof_full = interference_suite.tof_full_expansion();
cg_rho_tof_full = imresize(rho_tof_full, [coarse_dim x_scale*coarse_dim]);

%Fitting
fitting_suite = class_phase_extraction(cg_rho_tof_full);
ext_phase = fitting_suite.fitting(fitting_suite.init_phase_guess());

%Plotting
tlo = tiledlayout(2,1);

nexttile
imagesc(linspace(-l/2,l/2,fine_dim),linspace(-x_scale*l/2, x_scale*l/2, fine_dim), rho_tof_full')
xticks([])
ylabel('$x\; (\mu m)$', 'Interpreter', 'latex')
colormap(gge_colormap)
set(gca, 'FontName', 'Times', 'FontSize', 16)

nexttile
plot(linspace(-l/2,l/2,fine_dim), rel_phase, '--','LineWidth',1.2)
hold on
plot(linspace(-l/2,l/2, coarse_dim), ext_phase,'LineWidth',1.2)
xlabel('$z\; (\mu m)$','Interpreter','latex')
ylabel('$\varphi_{-}(z)$', 'Interpreter', 'latex')
set(gca, 'FontName', 'Times', 'FontSize', 16)

tlo.TileSpacing = 'compact';