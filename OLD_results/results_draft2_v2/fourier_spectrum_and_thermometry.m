clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_50nk.mat')
cov_phase = cov_phase_fine;
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 1e-6;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = transversal_length/pixel_width;
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z+1).*1e6;
num_samples = 200;
momentum_cutoff = 30;
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3;

if 0
%Generate samples
rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);


ext_phase_woc_1_all = zeros(num_samples, coarse_resolution_z);
ext_phase_woc_2_all = zeros(num_samples, coarse_resolution_z);
ext_phase_woc_3_all = zeros(num_samples, coarse_resolution_z);

ext_phase_wc_1_all = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_2_all = zeros(num_samples, coarse_resolution_z);
ext_phase_wc_3_all = zeros(num_samples, coarse_resolution_z);

ext_phase_trans_all = zeros(num_samples, coarse_resolution_z);

%Fourier amplitude
fourier_amp_woc_1 = zeros(num_samples, coarse_resolution_z);
fourier_amp_woc_2 = zeros(num_samples, coarse_resolution_z);
fourier_amp_woc_3 = zeros(num_samples, coarse_resolution_z);

fourier_amp_wc_1 = zeros(num_samples, coarse_resolution_z);
fourier_amp_wc_2 = zeros(num_samples, coarse_resolution_z);
fourier_amp_wc_3 = zeros(num_samples, coarse_resolution_z);

fourier_amp_in = zeros(num_samples, coarse_resolution_z);
fourier_amp_trans = zeros(num_samples, coarse_resolution_z);
%input fourier
cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);
count = 0;
for i = 1:num_samples
    %3D without common phase
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t_tof_2);
    interference_suite_woc_3 = class_interference_pattern(rel_phase(i,:), t_tof_3);
    rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_woc_1 = imresize(rho_tof_woc_1, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_woc_2 = imresize(rho_tof_woc_2, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_woc_3 = interference_suite_woc_3.tof_full_expansion();
    rho_tof_woc_3 = imresize(rho_tof_woc_3, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
    phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
    phase_ext_suite_woc_3 = class_phase_extraction(rho_tof_woc_3, t_tof_3);
    ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
    ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());
    ext_phase_woc_3 = phase_ext_suite_woc_3.fitting(phase_ext_suite_woc_3.init_phase_guess());
    
    %2D Transversal expansion
    rho_tof_trans = interference_suite_woc_1.tof_transversal_expansion();
    rho_tof_trans = imresize(rho_tof_trans, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t_tof_1);
    ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());
    
    %3D with common phase
    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    interference_suite_wc_3 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_3);
    rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_wc_1 = imresize(rho_tof_wc_1, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
    rho_tof_wc_2 = imresize(rho_tof_wc_2, [coarse_resolution_z, coarse_resolution_x]);
    rho_tof_wc_3 = interference_suite_wc_3.tof_full_expansion();
    rho_tof_wc_3 = imresize(rho_tof_wc_3, [coarse_resolution_z, coarse_resolution_x]);
    phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
    phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);
    phase_ext_suite_wc_3 = class_phase_extraction(rho_tof_wc_3, t_tof_3);
    ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
    ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());
    ext_phase_wc_3 = phase_ext_suite_wc_3.fitting(phase_ext_suite_wc_3.init_phase_guess());
    %Saving the extracted phase
    ext_phase_woc_1_all(i,:) = ext_phase_woc_1;
    ext_phase_woc_2_all(i,:) = ext_phase_woc_2;
    ext_phase_woc_3_all(i,:) = ext_phase_woc_3;
    ext_phase_wc_1_all(i,:) = ext_phase_wc_1;
    ext_phase_wc_2_all(i,:) = ext_phase_wc_2;
    ext_phase_wc_3_all(i,:) = ext_phase_wc_3;
    ext_phase_trans_all(i,:) = ext_phase_trans;
    %Compute the fourier coefficient
    fourier_amp_woc_1(i,:) = abs(fft(ext_phase_woc_1));
    fourier_amp_woc_2(i,:) = abs(fft(ext_phase_woc_2));
    fourier_amp_woc_3(i,:) = abs(fft(ext_phase_woc_3));
    fourier_amp_wc_1(i,:) = abs(fft(ext_phase_wc_1));
    fourier_amp_wc_2(i,:) = abs(fft(ext_phase_wc_2));
    fourier_amp_wc_3(i,:) = abs(fft(ext_phase_wc_3));
    fourier_amp_in(i,:) = abs(fft(cg_rel_phase(i,:)));
    fourier_amp_trans(i,:) = abs(fft(ext_phase_trans));
    count = count+1;
    disp(count)
end

save('phase_extraction_and_fourier_spectrum_50nK_200samples.mat', 'rel_phase', 'com_phase', 'cg_rel_phase', 'ext_phase_woc_1_all', 'ext_phase_woc_2_all', 'ext_phase_woc_3_all',...
    'ext_phase_wc_1_all', 'ext_phase_wc_2_all', 'ext_phase_wc_3_all', 'fourier_amp_in', 'fourier_amp_woc_1', 'fourier_amp_woc_2', 'fourier_amp_woc_3',...
    'fourier_amp_wc_1', 'fourier_amp_wc_2', 'fourier_amp_wc_3', 'fourier_amp_trans','ext_phase_trans_all')
end


%Population vs k
load('phase_extraction_and_fourier_spectrum_50nK_200samples.mat')
%Compute mean fourier coefficients
mean_fourier_woc_1 = zeros(1,coarse_resolution_z);
mean_fourier_woc_2 = zeros(1, coarse_resolution_z);
mean_fourier_woc_3 = zeros(1,coarse_resolution_z);

mean_fourier_wc_1 = zeros(1,coarse_resolution_z);
mean_fourier_wc_2 = zeros(1, coarse_resolution_z);
mean_fourier_wc_3 = zeros(1,coarse_resolution_z);

mean_fourier_input = zeros(1,coarse_resolution_z);
mean_fourier_trans = zeros(1,coarse_resolution_z);
for i = 1:coarse_resolution_z
    mean_fourier_woc_1(i,:) = mean(fourier_amp_woc_1(:,i).^2)*1e-4;
    mean_fourier_woc_2(i,:) = mean(fourier_amp_woc_2(:,i).^2)*1e-4;
    mean_fourier_woc_3(i,:) = mean(fourier_amp_woc_3(:,i).^2)*1e-4;

    mean_fourier_wc_1(i,:) = mean(fourier_amp_wc_1(:,i).^2)*1e-4;
    mean_fourier_wc_2(i,:) = mean(fourier_amp_wc_2(:,i).^2)*1e-4;
    mean_fourier_wc_3(i,:) = mean(fourier_amp_wc_3(:,i).^2)*1e-4;
    mean_fourier_input(i,:) = mean(fourier_amp_in(:,i).^2)*1e-4;
    mean_fourier_trans(i,:) = mean(fourier_amp_trans(:,i).^2)*1e-4;
end

%Population vs tof
t_tof = linspace(7,31,9); %in ms
load('fourier_vs_tof_50nk_n10_higher_res.mat')
fourier_amp_in_n10 = mean(fourier_amp_in_stats)*1e-4;
fourier_amp_woc_n10 = fourier_amp_woc*1e-4;
fourier_amp_wc_n10 = fourier_amp_wc*1e-4;
fourier_amp_trans_n10 = fourier_amp_trans*1e-4;

if 0
load('fourier_vs_tof_50nk_n15_higher_res.mat')
fourier_amp_in_n15 = mean(fourier_amp_in_stats);
fourier_amp_woc_n15 = fourier_amp_woc;
fourier_amp_wc_n15 = fourier_amp_wc;
fourier_amp_trans_n15 = fourier_amp_trans;
end

%analyze temperature data
load('temp_fitting_25nK.MAT')
coeffvals_input_25nk = coeffvals_input;
coeffvals_trans_1_25nk = coeffvals_trans_1;
coeffvals_trans_2_25nk = coeffvals_trans_2;
coeffvals_trans_3_25nk = coeffvals_trans_3;

coeffvals_woc_1_25nk = coeffvals_woc_1;
coeffvals_woc_2_25nk = coeffvals_woc_2;
coeffvals_woc_3_25nk = coeffvals_woc_3;

coeffvals_wc_1_25nk = coeffvals_wc_1;
coeffvals_wc_2_25nk = coeffvals_wc_2;
coeffvals_wc_3_25nk = coeffvals_wc_3;

load('temp_fitting_50nK.mat')

coeffvals_input_50nk = coeffvals_input;
coeffvals_trans_1_50nk = coeffvals_trans_1;
coeffvals_trans_2_50nk = coeffvals_trans_2;
coeffvals_trans_3_50nk = coeffvals_trans_3;

coeffvals_woc_1_50nk = coeffvals_woc_1;
coeffvals_woc_2_50nk = coeffvals_woc_2;
coeffvals_woc_3_50nk = coeffvals_woc_3;

coeffvals_wc_1_50nk = coeffvals_wc_1;
coeffvals_wc_2_50nk = coeffvals_wc_2;
coeffvals_wc_3_50nk = coeffvals_wc_3;

load('temp_fitting_75nk.mat')
coeffvals_input_75nk = coeffvals_input;
coeffvals_trans_1_75nk = coeffvals_trans_1;
coeffvals_trans_2_75nk = coeffvals_trans_2;
coeffvals_trans_3_75nk = coeffvals_trans_3;

coeffvals_woc_1_75nk = coeffvals_woc_1;
coeffvals_woc_2_75nk = coeffvals_woc_2;
coeffvals_woc_3_75nk = coeffvals_woc_3;

coeffvals_wc_1_75nk = coeffvals_wc_1;
coeffvals_wc_2_75nk = coeffvals_wc_2;
coeffvals_wc_3_75nk = coeffvals_wc_3;

load('temp_fitting_100nk.mat')
coeffvals_input_100nk = coeffvals_input;
coeffvals_trans_1_100nk = coeffvals_trans_1;
coeffvals_trans_2_100nk = coeffvals_trans_2;
coeffvals_trans_3_100nk = coeffvals_trans_3;

coeffvals_woc_1_100nk = coeffvals_woc_1;
coeffvals_woc_2_100nk = coeffvals_woc_2;
coeffvals_woc_3_100nk = coeffvals_woc_3;

coeffvals_wc_1_100nk = coeffvals_wc_1;
coeffvals_wc_2_100nk = coeffvals_wc_2;
coeffvals_wc_3_100nk = coeffvals_wc_3;

temp_list = [25,50,75,100];
data_input = [coeffvals_input_25nk, coeffvals_input_50nk, coeffvals_input_75nk, coeffvals_input_100nk];

data_trans_1 = [coeffvals_trans_1_25nk, coeffvals_trans_1_50nk, coeffvals_trans_1_75nk, coeffvals_trans_1_100nk];
data_trans_2 = [coeffvals_trans_2_25nk, coeffvals_trans_2_50nk, coeffvals_trans_2_75nk, coeffvals_trans_2_100nk];
data_trans_3 = [coeffvals_trans_1_25nk, coeffvals_trans_3_50nk, coeffvals_trans_3_75nk, coeffvals_trans_3_100nk];

data_woc_1 = [coeffvals_woc_1_25nk, coeffvals_woc_1_50nk, coeffvals_woc_1_75nk, coeffvals_woc_1_100nk];
data_woc_2 = [coeffvals_woc_2_25nk, coeffvals_woc_2_50nk, coeffvals_woc_2_75nk, coeffvals_woc_2_100nk];
data_woc_3 = [coeffvals_woc_1_25nk, coeffvals_woc_3_50nk, coeffvals_woc_3_75nk, coeffvals_woc_3_100nk];

data_wc_1 = [coeffvals_wc_1_25nk, coeffvals_wc_1_50nk, coeffvals_wc_1_75nk, coeffvals_wc_1_100nk];
data_wc_2 = [coeffvals_wc_2_25nk, coeffvals_wc_2_50nk, coeffvals_wc_2_75nk, coeffvals_wc_2_100nk];
data_wc_3 = [coeffvals_wc_1_25nk, coeffvals_wc_3_50nk, coeffvals_wc_3_75nk, coeffvals_wc_3_100nk];

%fitting
fitfun = fittype(@(a,b,x) a*x+b);
fit_input = fit(temp_list', data_input', fitfun);
fit_trans_1 = fit(temp_list', data_trans_1', fitfun);
fit_trans_2 = fit(temp_list', data_trans_2', fitfun);
fit_trans_3 = fit(temp_list', data_trans_3', fitfun);

fit_woc_1 = fit(temp_list', data_woc_1', fitfun);
fit_woc_2 = fit(temp_list', data_woc_2', fitfun);
fit_woc_3 = fit(temp_list', data_woc_3', fitfun);

fit_wc_1 = fit(temp_list', data_wc_1', fitfun);
fit_wc_2 = fit(temp_list', data_wc_2', fitfun);
fit_wc_3 = fit(temp_list', data_wc_3', fitfun);
% Create the main figure
figure

%Define the wavevector
k = 2*pi*(1:momentum_cutoff)/100;
x = linspace(25,100);


%Panel 1
f(1) = subplot(3,2,1); 
plot(t_tof, fourier_amp_woc_n10, 'o-','Color','black');
hold on
plot(t_tof, fourier_amp_trans_n10, '*', 'Color','Black')
yline(fourier_amp_in_n10, '--')
ylabel('$\langle |\Phi_k|^2\rangle$','Interpreter', 'latex')
xlabel('$t\; (\rm ms)$', 'Interpreter', 'latex')
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
ax = gca;
ax.YRuler.Exponent = -2;
ylim([0,1e-2])

%Panel 2
f(2) = subplot(3,2,2); 
plot(t_tof, fourier_amp_wc_n10, 'o-','Color','black')
hold on
plot(t_tof, fourier_amp_trans_n10, '*', 'Color','Black')
yline(fourier_amp_in_n10, '--')
xlabel('$t\; (\rm ms)$', 'Interpreter', 'latex')
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
ax = gca;
ax.YRuler.Exponent = -2;
ylim([0,1e-2])

% Panel 3
f(3) = subplot(3, 2, 3);
plot(k(5:momentum_cutoff), mean_fourier_input(5:momentum_cutoff),'Color','Black', 'LineWidth',1.1)
hold on
plot(k(5:momentum_cutoff), mean_fourier_trans(5:momentum_cutoff), '*','Color', 'Black', 'MarkerSize', 3)
plot(k(5:momentum_cutoff), mean_fourier_woc_1(5:momentum_cutoff),'-o' ,'Color', 'Blue', 'MarkerSize',3)
plot(k(5:momentum_cutoff), mean_fourier_woc_2(5:momentum_cutoff), '-x','Color', 'Red','MarkerSize',3)
plot(k(5:momentum_cutoff), mean_fourier_woc_3(5:momentum_cutoff), '-^','Color', [0,0.7,0],'MarkerSize',3)
xlim([0,2])
ax = gca;
ax.YRuler.Exponent = -2;
ylabel('$\langle |\Phi_k|^2\rangle$','Interpreter', 'latex')
xlabel('$k\; \rm (\mu m^{-1})$','Interpreter', 'latex')

title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
% Add an inset plot to panel 3

%Define residue
residue_trans = mean_fourier_input - mean_fourier_trans;
residue_woc_1 = mean_fourier_input - mean_fourier_woc_1;
residue_woc_2 = mean_fourier_input - mean_fourier_woc_2;
residue_woc_3 = mean_fourier_input - mean_fourier_woc_3;
insetAxes1 = axes('Position', [0.35, 0.5, 0.1, 0.08]);
plot(k(2:momentum_cutoff), residue_trans(2:momentum_cutoff),'*','Color','Black','MarkerSize',2)
hold on
plot(k(2:momentum_cutoff), residue_woc_1(2:momentum_cutoff),'-o','Color','Blue','MarkerSize',2)
plot(k(2:momentum_cutoff), residue_woc_2(2:momentum_cutoff),'-x','Color','red','MarkerSize',2)
plot(k(2:momentum_cutoff), residue_woc_3(2:momentum_cutoff), '-^','Color',[0,0.7,0],'MarkerSize',2)
ax = gca;
ax.YRuler.Exponent = -2;
ylabel('$\Delta_k$','Interpreter', 'latex')
box on

% Panel 4
f(4) = subplot(3, 2, 4);
plot(k(5:momentum_cutoff), mean_fourier_input(5:momentum_cutoff),'Color','Black', 'LineWidth',1.1)
hold on
plot(k(5:momentum_cutoff), mean_fourier_trans(5:momentum_cutoff), '*','Color', 'Black', 'MarkerSize', 3)
plot(k(5:momentum_cutoff), mean_fourier_wc_1(5:momentum_cutoff),'-o' ,'Color', 'Blue', 'MarkerSize',3)
plot(k(5:momentum_cutoff), mean_fourier_wc_2(5:momentum_cutoff), '-x','Color', 'Red','MarkerSize',3)
plot(k(5:momentum_cutoff), mean_fourier_wc_3(5:momentum_cutoff), '-^','Color', [0,0.7,0],'MarkerSize',3)
xlim([0,2])
ax = gca;
ax.YRuler.Exponent = -2;
yticks([])
xlabel('$k\; \rm (\mu m^{-1})$', 'Interpreter', 'latex')

title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
% Add an inset plot to panel 2

%Define residue
residue_trans = mean_fourier_input - mean_fourier_trans;
residue_wc_1 = mean_fourier_input - mean_fourier_wc_1;
residue_wc_2 = mean_fourier_input - mean_fourier_wc_2;
residue_wc_3 = mean_fourier_input - mean_fourier_wc_3;
insetAxes1 = axes('Position', [0.78, 0.5, 0.1, 0.08]);
plot(k(2:momentum_cutoff), residue_trans(2:momentum_cutoff),'*','Color','Black','MarkerSize',2)
hold on
plot(k(2:momentum_cutoff), residue_wc_1(2:momentum_cutoff),'-o','Color','Blue','MarkerSize',2)
plot(k(2:momentum_cutoff), residue_wc_2(2:momentum_cutoff),'-x','Color','red','MarkerSize',2)
plot(k(2:momentum_cutoff), residue_wc_3(2:momentum_cutoff), '-^','Color',[0,0.7,0],'MarkerSize', 2)
%ylim([-200,200])
ylabel('$\Delta_k$','Interpreter', 'latex')
ax = gca;
ax.YRuler.Exponent = -2;
box on

%Panel 5
f(5) = subplot(3,2,5);
plot(temp_list, data_woc_1, 'o', 'Color','blue','Linewidth',1.2)
hold on
plot(x, fit_woc_1(x), 'Color','blue','Linewidth',1.2)
plot(temp_list, data_woc_2, 'x', 'Color', 'red','Linewidth',1.2)
plot(x, fit_woc_2(x), 'Color','red')
plot(temp_list, data_woc_3, '^','Color',[0,0.7,0],'Linewidth',1.2)
plot(x, fit_woc_3(x), 'Color',[0,0.7,0],'Linewidth',1.2)
plot(temp_list, data_input, '.','Color','black','Linewidth',1.2)
plot(x, fit_input(x), 'Color','black','Linewidth',1.2)
plot(temp_list, data_trans_1, '*','Color','black')
ylim([0,200])
ylabel('$C(T)$','Interpreter', 'latex')
xlim([20,105])
ax = gca;
ax.YRuler.Exponent = 2;
xlabel('$T\; \rm (nK)$', 'Interpreter','latex')
ylim([0,300])
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
%Panel 6
f(6) = subplot(3,2,6);
plot(temp_list, data_wc_1, 'o', 'Color','blue','Linewidth',1.2)
hold on
plot(x, fit_wc_1(x), 'Color','blue','Linewidth',1.2)
plot(temp_list, data_wc_2, 'x', 'Color', 'red','Linewidth',1.2)
plot(x, fit_woc_2(x), 'Color','red','Linewidth',1.2)
plot(temp_list, data_wc_3, '^','Color',[0,0.7,0],'Linewidth',1.2)
plot(x, fit_woc_3(x), 'Color',[0,0.7,0],'Linewidth',1.2)
plot(temp_list, data_input, '.','Color','black','Linewidth',1.2)
plot(x, fit_input(x), 'Color','black','Linewidth',1.2)
plot(temp_list, data_trans_1, '*','Color','black')
xlabel('$T\; \rm (nK)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
yticks([])
xlim([20,105])
ylim([0,300])


set(f,'FontName','Times','FontSize', 14)
