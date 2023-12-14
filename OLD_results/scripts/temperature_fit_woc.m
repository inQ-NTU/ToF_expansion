clear all
close all

%Fourier Data Analysis
clear all
close all
addpath('../input')
addpath('../classes')
addpath('../results_draft2/')
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

load('phase_extraction_and_fourier_spectrum_75nK_500samples.mat')
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

    mean_fourier_wc_1(i,:) = mean(fourier_amp_wc_1(:,i).^2)*100;
    mean_fourier_wc_2(i,:) = mean(fourier_amp_wc_2(:,i).^2)*100;
    mean_fourier_wc_3(i,:) = mean(fourier_amp_wc_3(:,i).^2)*100;

    mean_fourier_input(i,:) = mean(fourier_amp_in(:,i).^2)*100;
end


%Temperature Data Analysis
load('temp_fitting_25nK.MAT')
coeffvals_input_25nk = coeffvals_input;
coeffvals_woc_1_25nk = coeffvals_woc_1;
coeffvals_woc_2_25nk = coeffvals_woc_2;
coeffvals_woc_3_25nk = coeffvals_woc_3;

coeffvals_wc_1_25nk = coeffvals_wc_1;
coeffvals_wc_2_25nk = coeffvals_wc_2;
coeffvals_wc_3_25nk = coeffvals_wc_3;

load('temp_fitting_50nK.mat')
coeffvals_input_50nk = coeffvals_input;
coeffvals_woc_1_50nk = coeffvals_woc_1;
coeffvals_woc_2_50nk = coeffvals_woc_2;
coeffvals_woc_3_50nk = coeffvals_woc_3;

coeffvals_wc_1_50nk = coeffvals_wc_1;
coeffvals_wc_2_50nk = coeffvals_wc_2;
coeffvals_wc_3_50nk = coeffvals_wc_3;

load('temp_fitting_75nk.mat')
coeffvals_input_75nk = coeffvals_input;
coeffvals_woc_1_75nk = coeffvals_woc_1;
coeffvals_woc_2_75nk = coeffvals_woc_2;
coeffvals_woc_3_75nk = coeffvals_woc_3;

coeffvals_wc_1_75nk = coeffvals_wc_1;
coeffvals_wc_2_75nk = coeffvals_wc_2;
coeffvals_wc_3_75nk = coeffvals_wc_3;

load('temp_fitting_100nk.mat')
coeffvals_input_100nk = coeffvals_input;
coeffvals_woc_1_100nk = coeffvals_woc_1;
coeffvals_woc_2_100nk = coeffvals_woc_2;
coeffvals_woc_3_100nk = coeffvals_woc_3;

coeffvals_wc_1_100nk = coeffvals_wc_1;
coeffvals_wc_2_100nk = coeffvals_wc_2;
coeffvals_wc_3_100nk = coeffvals_wc_3;

temp_list = [25,50,75,100];
data_woc_1 = [coeffvals_woc_1_25nk, coeffvals_woc_1_50nk, coeffvals_woc_1_75nk, coeffvals_woc_1_100nk];
data_woc_2 = [coeffvals_woc_2_25nk, coeffvals_woc_2_50nk, coeffvals_woc_2_75nk, coeffvals_woc_2_100nk];
data_woc_3 = [coeffvals_woc_1_25nk, coeffvals_woc_3_50nk, coeffvals_woc_3_75nk, coeffvals_woc_3_100nk];

data_wc_1 = [coeffvals_wc_1_25nk, coeffvals_wc_1_50nk, coeffvals_wc_1_75nk, coeffvals_wc_1_100nk];
data_wc_2 = [coeffvals_wc_2_25nk, coeffvals_wc_2_50nk, coeffvals_wc_2_75nk, coeffvals_wc_2_100nk];
data_wc_3 = [coeffvals_wc_1_25nk, coeffvals_wc_3_50nk, coeffvals_wc_3_75nk, coeffvals_wc_3_100nk];

data_input = [coeffvals_input_25nk, coeffvals_input_50nk, coeffvals_input_75nk, coeffvals_input_100nk];
%Linear fitting
x = linspace(25,100);
fitfun = fittype(@(a,b,x) a*x+b);
fit_input = fit(temp_list', data_input', fitfun);
fit_woc_1 = fit(temp_list', data_woc_1', fitfun);
fit_woc_2 = fit(temp_list', data_woc_2', fitfun);
fit_woc_3 = fit(temp_list', data_woc_3', fitfun);

fit_wc_1 = fit(temp_list', data_wc_1', fitfun);
fit_wc_2 = fit(temp_list', data_wc_2', fitfun);
fit_wc_3 = fit(temp_list', data_wc_3', fitfun);

%Plotting combination

% Compute wavevector
k = 2*pi*(1:momentum_cutoff)/100;

% Plotting
figure;
f(1) = subplot(2,2,1); % Modify subplot span
%title('a','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex');
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
%xlabel('$k \; (\rm \mu m^{-1})$','Interpreter','latex')
xticks([])
% Define the position and size of the inset plot
insetPos = [0.28 0.7 0.2 0.2]; % [left bottom width height]
%annotation('textbox', [0.05, 0.9, 0.05, 0.05], 'String', 'a', 'FontName', 'Times', 'FontSize', 16, 'EdgeColor', 'None');
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

f(2) = subplot(2,2,2);
plot(x, fit_input(x), 'Color','black','Linewidth',1.2)
hold on
plot(temp_list, data_woc_1, 'o', 'Color','blue','Linewidth',1.2)
plot(x, fit_woc_1(x), 'Color','blue','Linewidth',1.2)
plot(temp_list, data_woc_2, 'x', 'Color', 'red','Linewidth',1.2)
plot(x, fit_woc_2(x), 'Color','red')
plot(temp_list, data_woc_3, '^','Color',[0,0.7,0],'Linewidth',1.2)
plot(x, fit_woc_3(x), 'Color',[0,0.7,0],'Linewidth',1.2)
plot(temp_list, data_input, '.','Color','black','Linewidth',1.2)
ylim([20,140])
%xlabel('$T\; \rm (nK)$', 'Interpreter','latex')
ylabel('$C(T)$','Interpreter', 'latex')
yticks([20,60,100,140])
xticks([])
%xticks([25,50,75,100])
ax = gca;
ax.YRuler.Exponent = 2;
%annotation('textbox', [0.48, 0.9, 0.05, 0.05], 'String', 'b', 'FontName', 'Times', 'FontSize', 16, 'EdgeColor', 'None')
legend({'Input', '$t = 7 \; \rm{ms}$', '', '$t = 15 \; \rm{ms}$', '', '$t = 30 \; \rm{ms}$'},'Interpreter', 'latex', 'FontSize', 10)

f(3) = subplot(2,2,3); % Modify subplot span
%title('a','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex');
% Plot main data
plot(k(5:momentum_cutoff), mean_fourier_input(5:momentum_cutoff), 'Black','LineWidth', 1.2)
hold on
plot(k(5:momentum_cutoff), mean_fourier_wc_1(5:momentum_cutoff), '-o','Color', 'Blue', 'MarkerSize', 4)
plot(k(5:momentum_cutoff), mean_fourier_wc_2(5:momentum_cutoff), '-x','Color','Red')
plot(k(5:momentum_cutoff), mean_fourier_wc_3(5:momentum_cutoff), '-^','Color',[0,0.7,0], 'MarkerSize', 4)
xlim([0,2])
ax = gca;
ax.YRuler.Exponent = 2;
ylabel('$\langle|\Phi_k|^2\rangle$', 'Interpreter','latex')
xlabel('$k \; (\rm \mu m^{-1})$','Interpreter','latex')
% Define the position and size of the inset plot
insetPos = [0.28 0.23 0.2 0.2]; % [left bottom width height]
%annotation('textbox', [0.05, 0.9, 0.05, 0.05], 'String', 'a', 'FontName', 'Times', 'FontSize', 16, 'EdgeColor', 'None');
% Create the inset plot
insetAxes = axes('Position', insetPos);
plot(k, abs(mean_fourier_wc_1(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)),'-o', 'Color','Blue','MarkerSize', 2)
hold on
plot(k, abs(mean_fourier_wc_2(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)),'x-', 'Color','Red','MarkerSize',3)
plot(k, abs(mean_fourier_wc_3(2:momentum_cutoff+1) - mean_fourier_input(2:momentum_cutoff+1)),'^-', 'Color',[0,0.7,0],'MarkerSize' ,2)
xlim([0,1.5])
ax = gca;
ax.YRuler.Exponent = 2;
xlabel('$k \; (\rm \mu m^{-1})$','Interpreter','latex')
ylabel('$|\Delta_k|$','Interpreter','latex')
set(f, 'FontName', 'Times', 'FontSize', 16)
ylim([0,200])
% Adjust the main plot to make space for the inset plot
mainAxes = gca;
mainAxes.Position(3) = mainAxes.Position(3) * (1 - insetPos(3));
mainAxes.Position(4) = mainAxes.Position(4) * (1 - insetPos(4));

f(4) = subplot(2,2,4);
plot(x, fit_input(x), 'Color','black','Linewidth',1.2)
hold on
plot(temp_list, data_wc_1, 'o', 'Color','blue','Linewidth',1.2)
plot(x, fit_woc_1(x), 'Color','blue','Linewidth',1.2)
plot(temp_list, data_wc_2, 'x', 'Color', 'red','Linewidth',1.2)
plot(x, fit_woc_2(x), 'Color','red')
plot(temp_list, data_wc_3, '^','Color',[0,0.7,0],'Linewidth',1.2)
plot(x, fit_woc_3(x), 'Color',[0,0.7,0],'Linewidth',1.2)
plot(temp_list, data_input, '.','Color','black','Linewidth',1.2)
ylim([20,260])
xlabel('$T\; \rm (nK)$', 'Interpreter','latex')
ylabel('$C(T)$','Interpreter', 'latex')
yticks([20,80,140,200,260])
xticks([25,50,75,100])
ax = gca;
ax.YRuler.Exponent = 2;
%annotation('textbox', [0.48, 0.9, 0.05, 0.05], 'String', 'b', 'FontName', 'Times', 'FontSize', 16, 'EdgeColor', 'None')
set(f, 'FontName', 'Times', 'FontSize', 16)
legend({'Input', '$t = 7 \; \rm{ms}$','', '$t = 15 \; \rm{ms}$', '', '$t = 30 \; \rm{ms}$'},  'Interpreter', 'latex', 'FontSize', 10)
