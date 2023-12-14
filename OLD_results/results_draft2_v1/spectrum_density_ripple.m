close all
clear all

addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
transversal_resolution = (transversal_length/condensate_length)*longitudinal_resolution;
x_grid = linspace(-transversal_length/2,transversal_length/2, transversal_resolution);
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution);
num_samples = 200;
momentum_cutoff = 40;
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3; 

%Generate samples
rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);

spectrum_woc_1 = zeros(num_samples,longitudinal_resolution);
spectrum_woc_2 = zeros(num_samples,longitudinal_resolution);
spectrum_woc_3 = zeros(num_samples,longitudinal_resolution);

spectrum_wc_1 = zeros(num_samples,longitudinal_resolution);
spectrum_wc_2 = zeros(num_samples,longitudinal_resolution);
spectrum_wc_3 = zeros(num_samples,longitudinal_resolution);

count = 0;
for i = 1:num_samples
    interference_suite_woc_1 = class_interference_pattern(rel_phase(i,:), t_tof_1);
    interference_suite_woc_2 = class_interference_pattern(rel_phase(i,:), t_tof_2);
    interference_suite_woc_3 = class_interference_pattern(rel_phase(i,:), t_tof_3);

    interference_suite_wc_1 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_wc_2 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    interference_suite_wc_3 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_3);

    rho_tof_2d_1 = interference_suite_woc_1.tof_transversal_expansion();
    rho_tof_2d_2 = interference_suite_woc_2.tof_transversal_expansion();
    rho_tof_2d_3 = interference_suite_woc_3.tof_transversal_expansion();

    rho_tof_3d_woc_1 = interference_suite_woc_1.tof_full_expansion();
    rho_tof_3d_woc_2 = interference_suite_woc_2.tof_full_expansion();
    rho_tof_3d_woc_3 = interference_suite_woc_3.tof_full_expansion();

    rho_tof_3d_wc_1 = interference_suite_wc_1.tof_full_expansion();
    rho_tof_3d_wc_2 = interference_suite_wc_2.tof_full_expansion();
    rho_tof_3d_wc_3 = interference_suite_wc_3.tof_full_expansion();
   

    rho_tof_2d_1 = rho_tof_2d_1.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_2d_1,2)));
    rho_tof_2d_2 = rho_tof_2d_2.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_2d_2,2)));
    rho_tof_2d_3 = rho_tof_2d_3.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_2d_3,2)));

    rho_tof_3d_woc_1 = rho_tof_3d_woc_1.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_woc_1, 2)));
    rho_tof_3d_woc_2 = rho_tof_3d_woc_2.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_woc_2, 2)));
    rho_tof_3d_woc_3 = rho_tof_3d_woc_3.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_woc_3, 2)));

    rho_tof_3d_wc_1 = rho_tof_3d_wc_1.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_wc_1, 2)));
    rho_tof_3d_wc_2 = rho_tof_3d_wc_2.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_wc_2, 2)));
    rho_tof_3d_wc_3 = rho_tof_3d_wc_3.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_wc_3, 2)));

    density_ripple_2d_1 = trapz(x_grid, rho_tof_2d_1, 2);
    density_ripple_2d_1 = density_ripple_2d_1.*1e-6;
    density_ripple_2d_2 = trapz(x_grid, rho_tof_2d_2, 2);
    density_ripple_2d_2 = density_ripple_2d_2.*1e-6;
    density_ripple_2d_3 = trapz(x_grid, rho_tof_2d_3, 2);
    density_ripple_2d_3 = density_ripple_2d_3.*1e-6;

    density_ripple_3d_woc_1 = trapz(x_grid, rho_tof_3d_woc_1, 2);
    density_ripple_3d_woc_1 = density_ripple_3d_woc_1.*1e-6;
    density_ripple_3d_woc_2 = trapz(x_grid, rho_tof_3d_woc_2, 2);
    density_ripple_3d_woc_2 = density_ripple_3d_woc_2.*1e-6;
    density_ripple_3d_woc_3 = trapz(x_grid, rho_tof_3d_woc_3, 2);
    density_ripple_3d_woc_3 = density_ripple_3d_woc_3.*1e-6;

    density_ripple_3d_wc_1 = trapz(x_grid, rho_tof_3d_wc_1, 2);
    density_ripple_3d_wc_1 = density_ripple_3d_wc_1.*1e-6;
    density_ripple_3d_wc_2 = trapz(x_grid, rho_tof_3d_wc_2, 2);
    density_ripple_3d_wc_2 = density_ripple_3d_wc_2.*1e-6;
    density_ripple_3d_wc_3 = trapz(x_grid, rho_tof_3d_wc_3, 2);
    density_ripple_3d_wc_3 = density_ripple_3d_wc_3.*1e-6;

    spectrum_woc_1(i,:) = abs(fft(density_ripple_3d_woc_1 - density_ripple_2d_1)/longitudinal_resolution);
    spectrum_woc_2(i,:) = abs(fft(density_ripple_3d_woc_2 - density_ripple_2d_2)/longitudinal_resolution);
    spectrum_woc_3(i,:) = abs(fft(density_ripple_3d_woc_3 - density_ripple_2d_3)/longitudinal_resolution);


    spectrum_wc_1(i,:) = abs(fft(density_ripple_3d_wc_1 - density_ripple_2d_1)/longitudinal_resolution);
    spectrum_wc_2(i,:) = abs(fft(density_ripple_3d_wc_2 - density_ripple_2d_2)/longitudinal_resolution);
    spectrum_wc_3(i,:) = abs(fft(density_ripple_3d_wc_3 - density_ripple_2d_3)/longitudinal_resolution);
    count = count+1;
    disp(count)
end

%Save data
save('density_ripple_spectrum.mat','spectrum_woc_1','spectrum_woc_2', 'spectrum_woc_3', 'spectrum_wc_1', 'spectrum_wc_2', 'spectrum_wc_3')

%Compute mean spectrum
mean_spectrum_woc_1 = zeros(1, momentum_cutoff);
mean_spectrum_woc_2 = zeros(1,momentum_cutoff);
mean_spectrum_woc_3 = zeros(1,momentum_cutoff);

mean_spectrum_wc_1 = zeros(1, momentum_cutoff);
mean_spectrum_wc_2 = zeros(1,momentum_cutoff);
mean_spectrum_wc_3 = zeros(1,momentum_cutoff);
for i = 1:momentum_cutoff
    mean_spectrum_woc_1(i) = mean(spectrum_woc_1(:,i));
    mean_spectrum_woc_2(i) = mean(spectrum_woc_2(:,i));
    mean_spectrum_woc_3(i) = mean(spectrum_woc_3(:,i));
    mean_spectrum_wc_1(i) = mean(spectrum_wc_1(:,i));
    mean_spectrum_wc_2(i) = mean(spectrum_wc_2(:,i));
    mean_spectrum_wc_3(i) = mean(spectrum_wc_3(:,i));
end

k = 2*pi*(1:momentum_cutoff)/100;

f(1) = subplot(1,2,1);
plot(k, mean_spectrum_woc_1,'o-','Color','blue')
hold on
plot(k, mean_spectrum_woc_2,'x-','Color','red')
plot(k, mean_spectrum_woc_3,'^-','Color',[0,0.7,0])
xlabel('$k \; (\rm \mu m^{-1})$','Interpreter','latex')
ylabel('$\langle |\Delta \rho (k)|\rangle$','Interpreter','latex')
xlim([0,2.5])
title('a','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(2) = subplot(1,2,2);
plot(k, mean_spectrum_wc_1,'o-','Color','blue')
hold on
plot(k, mean_spectrum_wc_2,'x-','Color','red')
plot(k, mean_spectrum_wc_3, '^-','Color',[0,0.7,0])
xlabel('$k \; (\rm \mu m^{-1})$','Interpreter','latex')
xlim([0,2.5])
title('b','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

set(f, 'FontName', 'Times', 'FontSize', 10)
