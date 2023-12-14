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
num_samples = 500;
momentum_cutoff = 40;
t_tof_list = [7, 10, 15, 18, 20, 25, 28, 30].*1e-3;

rel_phase = sampling_suite.generate_profiles(num_samples);
com_phase = sampling_suite.generate_profiles(num_samples);
k = 2*pi*(1:momentum_cutoff)/100;
kmax_woc = zeros(1, length(t_tof_list));
kmax_wc = zeros(1, length(t_tof_list));
outer_count = 0;
for j = 1:length(t_tof_list)
    ripple_spectrum_woc = zeros(num_samples, longitudinal_resolution);
    ripple_spectrum_wc = zeros(num_samples, longitudinal_resolution);
    inner_count = 0;
    for i = 1:num_samples
        interference_suite_woc = class_interference_pattern(rel_phase(i,:), t_tof_list(j));
        interference_suite_wc = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_list(j));

        rho_tof_2d = interference_suite_woc.tof_transversal_expansion();
        rho_tof_3d_woc = interference_suite_woc.tof_full_expansion();
        rho_tof_3d_wc = interference_suite_wc.tof_full_expansion();

        %Normalizing to 10,000 atoms
        rho_tof_2d = rho_tof_2d.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_2d,2)));
        rho_tof_3d_woc = rho_tof_3d_woc.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_woc,2)));
        rho_tof_3d_wc = rho_tof_3d_wc.*(1e4/trapz(z_grid, trapz(x_grid, rho_tof_3d_wc,2)));

        %Compute density ripple
        density_ripple_2d = trapz(x_grid, rho_tof_2d, 2);
        density_ripple_2d = density_ripple_2d.*1e-6;
        density_ripple_3d_woc = trapz(x_grid, rho_tof_3d_woc, 2);
        density_ripple_3d_woc = density_ripple_3d_woc.*1e-6;
        density_ripple_3d_wc = trapz(x_grid, rho_tof_3d_wc, 2);
        density_ripple_3d_wc = density_ripple_3d_wc.*1e-6;

        %Compute the spectrum 
        ripple_spectrum_woc(i,:) = abs(fft(density_ripple_3d_woc - density_ripple_2d)/longitudinal_resolution);
        ripple_spectrum_wc(i,:) = abs(fft(density_ripple_3d_wc - density_ripple_2d)/longitudinal_resolution);

        inner_count = inner_count +1;
        disp(inner_count)
    end
    %Compute the mean spectrum
    mean_spectrum_woc = zeros(1, momentum_cutoff);
    mean_spectrum_wc = zeros(1, momentum_cutoff);
    for i = 1:momentum_cutoff
        mean_spectrum_woc(i) = mean(ripple_spectrum_woc(:,i));
        mean_spectrum_wc(i) = mean(ripple_spectrum_wc(:,i));
    end
    [max_val_woc, idx_val_woc] = max(mean_spectrum_woc);
    [max_val_wc, idx_val_wc] = max(mean_spectrum_wc);
    kmax_woc(j) = k(idx_val_woc);
    kmax_wc(j) = k(idx_val_wc);
    
    outer_count = outer_count +1;
    disp(outer_count)
end
save('kmax_vary_t_tof.mat', 'kmax_wc', 'kmax_woc', 't_tof_list')
plot(t_tof_list.*1e3, 1./kmax_woc, '-o');
hold on
plot(t_tof_list.*1e3, 1./kmax_wc, '-x');