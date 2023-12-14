clear all
close all

addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

load('density_common_phase_cov.mat')
input_corr = corr_t7;
grid = linspace(-40,40, size(input_corr,1));

%Defining some parameters
coarse_dim = 80;
z=linspace(-40,40,coarse_dim);
x = linspace(-48, 48, 1.2*coarse_dim);
%num_shots = 200;

%gaussian phase sampling
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);
phase_sample = phase_sampling_suite.generate_profiles(2);
phase_sample = phase_sampling_suite.coarse_grain(coarse_dim, phase_sample);
%generate rho tof
interference_suite = class_interference_pattern(phase_sample);

rho_tof_full = interference_suite.tof_full_expansion();
rho_tof_trans = interference_suite.tof_transversal_expansion();

%perform phase extraction
extraction_full = class_phase_extraction(rho_tof_full);
extraction_trans = class_phase_extraction(rho_tof_trans);

ext_phase_full = extraction_full.fitting(extraction_full.init_phase_guess());
ext_phase_trans = extraction_trans.fitting(extraction_trans.init_phase_guess());

%extract amplitude
ext_amp_full = extraction_full.normalization_amplitudes;
ext_amp_trans = extraction_trans.normalization_amplitudes;
if 0
%Plotting
figure
plot(z, phase_sample(1,:),'Color','black');
hold on
plot(z, phase_sample(2,:), 'LineStyle', '--', 'Color', 'black');
xlabel('$z \; (\mu m)$','Interpreter', 'latex')
ylabel('$\varphi(z)$','Interpreter', 'latex')
set(gca, 'FontName','Times', 'FontSize', 16)
end
imageData = imread('density_enhancement_and_depletion.png');
imageData = imresize(imageData, [1200,1000]);
figure
tlo = tiledlayout(2,2);
nexttile
imagesc(z,x,rho_tof_full')
ylabel('$x\; (\mu m)$', 'Interpreter','latex')
xticks([])
colormap(gge_colormap)
set(gca, 'FontName','Times', 'FontSize', 16)

nexttile
imagesc(grid, grid, input_corr.*1e-15)
ylabel('$z\; (\mu m)$','Interpreter','latex')
xlabel('$z^\prime\; (\mu m)$','Interpreter','latex')
title('$\langle \partial_z\varphi_{+}(z)\Delta A(z^\prime)\rangle (\times 10^{15})$','Interpreter','latex')
colorbar
colormap(gge_colormap)
set(gca, 'FontName','Times', 'FontSize',16)

nexttile
plot(z, ext_amp_trans)
hold on
plot(z, ext_amp_full);
xlabel('$z\; (\mu m)$', 'Interpreter','latex')
ylabel('$A(z)$', 'Interpreter','latex')
set(gca, 'FontName','Times', 'FontSize', 16)

nexttile % Fourth tile (contains the PNG figure)
imagesc(imageData); % Display the image in this tile
xticks([])
yticks([])
tlo.TileSpacing = 'tight'; 