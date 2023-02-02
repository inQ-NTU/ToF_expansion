%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov.mat')

%initiate gaussian phase sampling class
coarse_dim = 50;
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
phase_samples = phase_sampling_suite.generate_profiles(2);

%coarse graining
phase_samples = phase_sampling_suite.coarse_grain(phase_samples, coarse_dim);

%interference_suite1 -> no common phase
%interference_suite2 -> with common phase
interference_suite1 = class_interference_pattern(phase_samples(1,:));
interference_suite2 = class_interference_pattern(phase_samples);
rho_tof1 = interference_suite1.tof_full_expansion();
rho_tof2 = interference_suite2.tof_full_expansion();

%extraction class
extraction_suite1 = class_phase_extraction(rho_tof1);
extraction_suite2 = class_phase_extraction(rho_tof2);
phase_calibration1 = extraction_suite1.init_phase_guess();
phase_calibration2 = extraction_suite2.init_phase_guess();
phase_fitted1 = extraction_suite1.fitting(phase_calibration1);
phase_fitted2 = extraction_suite2.fitting(phase_calibration2);

%recontructed and marginal tof
reco_tof1 = extraction_suite1.reconstructed_interference_pattern;
reco_tof2 = extraction_suite2.reconstructed_interference_pattern;
marginal_tof1 = (reco_tof1 - rho_tof1)/max(rho_tof1, [],'all');
marginal_tof2 = (reco_tof2 - rho_tof2)/max(rho_tof2, [],'all');

%amplitudes and contrasts
amp1 = extraction_suite1.normalization_amplitudes;
amp2 = extraction_suite2.normalization_amplitudes;
contrast1 = extraction_suite1.contrasts;
contrast2 = extraction_suite2.contrasts;

%Making figures
fontname = 'Times';
fontsize = 18;
z_grid = linspace(0,100,coarse_dim);
x_grid = linspace(-60,60, size(rho_tof1,2));

img = figure;

f(1) = subplot(2,2,1);
imagesc(x_grid, z_grid, marginal_tof1)
xlabel('$x\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
ylabel('$z\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);


f(2) = subplot(2,2,2);
imagesc(x_grid, z_grid, marginal_tof2)
xlabel('$x\; (\mu m)$','Interpreter','latex','FontSize',fontsize);
cb=colorbar;
cb.Position = cb.Position + [0.1,0,0,0];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\delta\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',20)
colormap(gge_colormap)
cb.Ruler.Exponent = -3;
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f(3) = subplot(2,2,3);
[func,gof] = fit(z_grid', amp1', 'poly2');
plot(z_grid, func(z_grid),'blue')
hold on
plot(z_grid, amp1, 'xb')
plot(z_grid, amp2, 'or--')
hold off
ylabel('$A(z)$','Interpreter','latex','FontSize',fontsize)
xlabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f(4) = subplot(2,2,4);
plot(z_grid, contrast1, 'blue')
hold on
plot(z_grid, contrast2,'red')
hold off
ylabel('$C(z)$','Interpreter','latex','FontSize',fontsize)
xlabel('$z\; (\mu m)$', 'Interpreter','latex','FontSize',fontsize)
title('(d)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

set(f, 'FontName',fontname,'FontSize',fontsize)