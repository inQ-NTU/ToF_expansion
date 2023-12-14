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
momentum_cutoff = 32;
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3; 

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
    mean_fourier_woc_1(i,:) = mean(fourier_amp_woc_1(:,i).^2)*100;
    mean_fourier_woc_2(i,:) = mean(fourier_amp_woc_2(:,i).^2)*100;
    mean_fourier_woc_3(i,:) = mean(fourier_amp_woc_3(:,i).^2)*100;

    mean_fourier_wc_1(i,:) = mean(fourier_amp_wc_1(:,i));
    mean_fourier_wc_2(i,:) = mean(fourier_amp_wc_2(:,i));
    mean_fourier_wc_3(i,:) = mean(fourier_amp_wc_3(:,i));

    mean_fourier_input(i,:) = mean(fourier_amp_in(:,i).^2)*100;
end
% Compute wavevector
k = 2*pi*(1:momentum_cutoff)/100;

% Plotting
figure;
f(1) = subplot(1,1,1); % Modify subplot span
title('a','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
% Plot main data
plot(k(5:momentum_cutoff), mean_fourier_input(5:momentum_cutoff), 'Black','LineWidth', 1.2)
hold on
plot(k(5:momentum_cutoff), mean_fourier_woc_1(5:momentum_cutoff), '-o','Color', 'Blue', 'MarkerSize', 4)
plot(k(5:momentum_cutoff), mean_fourier_woc_2(5:momentum_cutoff), '-x','Color','Red')
plot(k(5:momentum_cutoff), mean_fourier_woc_3(5:momentum_cutoff), '-^','Color',[0,0.7,0], 'MarkerSize', 4)
xlim([0,2])
ax = gca;
ax.YRuler.Exponent = 2;
ylabel('$\langle|\Phi_k|^2\rangle$', 'Interpreter','latex')
xlabel('$k \; (\rm \mu m^{-1})$','Interpreter','latex')
% Define the position and size of the inset plot
insetPos = [0.55 0.6 0.5 0.5]; % [left bottom width height]

% Create the inset plot
insetAxes = axes('Position', insetPos);
plot(k, abs(mean_fourier_woc_1(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)),'-o', 'Color','Blue','MarkerSize', 2)
hold on
plot(k, abs(mean_fourier_woc_2(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)),'x-', 'Color','Red','MarkerSize',3)
plot(k, abs(mean_fourier_woc_3(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)),'^-', 'Color',[0,0.7,0],'MarkerSize' ,2)
xlim([0,1.5])
ax = gca;
ax.YRuler.Exponent = 2;
xlabel('$k \; (\rm \mu m^{-1})$','Interpreter','latex')
ylabel('$|\Delta_k|$','Interpreter','latex')
set(f, 'FontName', 'Times', 'FontSize', 16)

% Adjust the main plot to make space for the inset plot
mainAxes = gca;
mainAxes.Position(3) = mainAxes.Position(3) * (1 - insetPos(3));
mainAxes.Position(4) = mainAxes.Position(4) * (1 - insetPos(4));


