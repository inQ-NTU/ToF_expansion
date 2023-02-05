%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
addpath('Data/')
load('thermal_cov_50nk.mat')
close all
%Defining some parameters
coarse_dim =50;
weak_convolution = 0.005;
strong_convolution = 0.01;
weak_SNR = 1000;
strong_SNR = 200;

%initiate gaussian phase sampling class
%phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
%phase_samples = phase_sampling_suite.generate_profiles(2);

%coarse graining
%phase_samples = phase_sampling_suite.coarse_grain(phase_samples, coarse_dim);

load('results_sampled_phases_profile.mat');

%interference_suite1 -> no common phase
%interference_suite2 -> with common phase
interference_suite1 = class_interference_pattern(phase_samples(1,:));
interference_suite2 = class_interference_pattern(phase_samples);

%rho_tof1 -> no processing, no common phase
%rho_tof2 -> no processing, with common phase
%rho_tof3 -> weak convolution, no common phase
%rho_tof4 -> strong convolution, no common phase
%rho_tof5 -> weak noise, no convolution, no common phase
%rho_tof6 -> strong noise, no convolution, no common phase 
rho_tof1 = interference_suite1.tof_full_expansion();
rho_tof2 = interference_suite2.tof_full_expansion();
rho_tof3 = interference_suite1.convolution2d(rho_tof1, weak_convolution);
rho_tof4 = interference_suite1.convolution2d(rho_tof1, strong_convolution);
rho_tof5 = interference_suite1.add_gaussian_noise(rho_tof1, 1/weak_SNR);
rho_tof6 = interference_suite1.add_gaussian_noise(rho_tof1, 1/strong_SNR);

%extraction class
extraction_suite1 = class_phase_extraction(rho_tof1);
extraction_suite2 = class_phase_extraction(rho_tof2);
extraction_suite3 = class_phase_extraction(rho_tof3);
extraction_suite4 = class_phase_extraction(rho_tof4);
extraction_suite5 = class_phase_extraction(rho_tof5);
extraction_suite6 = class_phase_extraction(rho_tof6);

phase_calibration1 = extraction_suite1.init_phase_guess();
phase_calibration2 = extraction_suite2.init_phase_guess();
phase_calibration3 = extraction_suite3.init_phase_guess();
phase_calibration4 = extraction_suite4.init_phase_guess();
phase_calibration5 = extraction_suite5.init_phase_guess();
phase_calibration6 = extraction_suite6.init_phase_guess();

phase_fitted1 = extraction_suite1.fitting(phase_calibration1);
phase_fitted2 = extraction_suite2.fitting(phase_calibration2);
phase_fitted3 = extraction_suite3.fitting(phase_calibration3);
phase_fitted4 = extraction_suite4.fitting(phase_calibration4);
phase_fitted5 = extraction_suite5.fitting(phase_calibration5);
phase_fitted6 = extraction_suite6.fitting(phase_calibration6);

%recontructed and marginal tof
reco_tof1 = extraction_suite1.reconstructed_interference_pattern;
reco_tof2 = extraction_suite2.reconstructed_interference_pattern;
reco_tof3 = extraction_suite3.reconstructed_interference_pattern;
reco_tof4 = extraction_suite4.reconstructed_interference_pattern;
reco_tof5 = extraction_suite5.reconstructed_interference_pattern;
reco_tof6 = extraction_suite6.reconstructed_interference_pattern;

marginal_tof1 = (rho_tof1 - reco_tof1)/max(rho_tof1, [],'all');
marginal_tof2 = (rho_tof2 - reco_tof2)/max(rho_tof2, [],'all');
marginal_tof3 = (rho_tof3 - reco_tof3)/max(rho_tof3, [],'all');
marginal_tof4 = (rho_tof4 - reco_tof4)/max(rho_tof4, [],'all');
marginal_tof5 = (rho_tof5 - reco_tof5)/max(rho_tof5, [],'all');
marginal_tof6 = (rho_tof6 - reco_tof6)/max(rho_tof6, [],'all');

%amplitudes and contrasts
amp1 = extraction_suite1.normalization_amplitudes;
amp2 = extraction_suite2.normalization_amplitudes;
amp3 = extraction_suite3.normalization_amplitudes;
amp4 = extraction_suite4.normalization_amplitudes;
amp5 = extraction_suite5.normalization_amplitudes;
amp6 = extraction_suite6.normalization_amplitudes;

contrast1 = extraction_suite1.contrasts;
contrast2 = extraction_suite2.contrasts;
contrast3 = extraction_suite3.contrasts;
contrast4 = extraction_suite4.contrasts;
contrast5 = extraction_suite5.contrasts;
contrast6 = extraction_suite6.contrasts;

%Making figures
fontname = 'Times';
fontsize = 16;
z_grid = linspace(0,100,coarse_dim);
x_grid = linspace(-60,60, size(rho_tof1,2));

%First figure
img1 = figure;

upper_clim = max(max(marginal_tof1, [],'all'), max(marginal_tof2, [], 'all'));
lower_clim = min(min(marginal_tof1, [], 'all'), min(marginal_tof2, [], 'all'));

f1(1) = subplot(2,2,1);
imagesc(x_grid, z_grid, marginal_tof1)
xlabel('$x\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
ylabel('$z\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
clim([lower_clim upper_clim ]);

f1(2) = subplot(2,2,2);
imagesc(x_grid, z_grid, marginal_tof2)
xlabel('$x\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
clim([lower_clim upper_clim])
cb=colorbar;
cb.Position = cb.Position + [0.1,0,0,0];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\delta\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',20)
colormap(gge_colormap)
cb.Ruler.Exponent = -3;
cb.Ruler.SecondaryLabel.Units = 'normalized';
cb.Ruler.SecondaryLabel.Position = [1 -0.15];
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f1(3) = subplot(2,2,3);
[func,gof] = fit(z_grid', amp1', 'poly2');
plot(z_grid, func(z_grid),'blue')
hold on
plot(z_grid, amp1, 'xb')
plot(z_grid, amp2, 'or--')
hold off
ylabel('$A(z)$','Interpreter','latex','FontSize',fontsize)
xlabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f1(4) = subplot(2,2,4);
plot(z_grid, contrast1, 'blue')
hold on
plot(z_grid, contrast2,'red')
hold off
ylabel('$C(z)$','Interpreter','latex','FontSize',fontsize)
ylim([0.85,1])
xlabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(d)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

set(f1, 'FontName',fontname,'FontSize',fontsize)


%Second figure
img2 = figure;

upper_clim = max(max(marginal_tof3, [],'all'), max(marginal_tof4, [], 'all'));
lower_clim = min(min(marginal_tof3, [], 'all'), min(marginal_tof4, [], 'all'));

f2(1) = subplot(2,2,1);
imagesc(x_grid, z_grid, marginal_tof3)
xlabel('$x\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
ylabel('$z\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
clim([lower_clim upper_clim])

f2(2) = subplot(2,2,2);
imagesc(x_grid, z_grid, marginal_tof4)
xlabel('$x\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
clim([lower_clim upper_clim])
cb=colorbar;
cb.Position = cb.Position + [0.1,0,0,0];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\delta\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',20)
colormap(gge_colormap)
cb.Ruler.Exponent = -3;
cb.Ruler.SecondaryLabel.Units = 'normalized';
cb.Ruler.SecondaryLabel.Position = [1 -0.15];
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f2(3) = subplot(2,2,3);
[func,gof] = fit(z_grid', amp3', 'poly2');
plot(z_grid, func(z_grid),'blue')
hold on
plot(z_grid, amp3, 'xb')
plot(z_grid, amp4, 'or')
[func,gof] = fit(z_grid', amp4', 'poly2');
plot(z_grid, func(z_grid),'red')
hold off
ylabel('$A(z)$','Interpreter','latex','FontSize',fontsize)
xlabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f2(4) = subplot(2,2,4);
plot(z_grid, contrast3, 'blue')
hold on
plot(z_grid, contrast4,'red')
hold off
ylabel('$C(z)$','Interpreter','latex','FontSize',fontsize)
xlabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(d)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

set(f2, 'FontName',fontname,'FontSize',fontsize)


%Third figure
%Second figure
img3 = figure;
upper_clim = max(max(marginal_tof5, [],'all'), max(marginal_tof6, [], 'all'));
lower_clim = min(min(marginal_tof5, [], 'all'), min(marginal_tof6, [], 'all'));

f3(1) = subplot(2,2,1);
imagesc(x_grid, z_grid, marginal_tof5)
xlabel('$x\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
ylabel('$z\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
clim([lower_clim upper_clim])

f3(2) = subplot(2,2,2);
imagesc(x_grid, z_grid, marginal_tof6)
xlabel('$x\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
clim([lower_clim upper_clim])
cb=colorbar;
cb.Position = cb.Position + [0.1,0,0,0];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\delta\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',20)
colormap(gge_colormap)
cb.Ruler.Exponent = -3;
cb.Ruler.SecondaryLabel.Units = 'normalized';
cb.Ruler.SecondaryLabel.Position = [1 0];
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f3(3) = subplot(2,2,3);
[func,gof] = fit(z_grid', amp5', 'poly2');
plot(z_grid, func(z_grid),'blue')
hold on
plot(z_grid, amp5, 'xb')
plot(z_grid, amp6, 'or')
[func,gof] = fit(z_grid', amp6', 'poly2');
plot(z_grid, func(z_grid),'red')
hold off
ylabel('$A(z)$','Interpreter','latex','FontSize',fontsize)
xlabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f3(4) = subplot(2,2,4);
plot(z_grid, contrast5, 'blue')
hold on
plot(z_grid, contrast6,'red')
hold off
ylabel('$C(z)$','Interpreter','latex','FontSize',fontsize)
ylim([0.85,1])
xlabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(d)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

set(f3, 'FontName',fontname,'FontSize',fontsize)
