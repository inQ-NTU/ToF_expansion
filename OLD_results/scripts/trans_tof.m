addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

coarse_dim =50;
z=linspace(0,100,coarse_dim);
phase_samples = pi*cos(3*pi*z/100);

interference_suite = class_interference_pattern(phase_samples);
rho_tof_trans = interference_suite.tof_transversal_expansion();
slice_trans = rho_tof_trans(coarse_dim/2,:);


f(1) = subplot(1,2,1);
imagesc(rho_tof_trans)
colormap(gge_colormap)
colorbar
xlabel('$x$','Interpreter', 'latex','FontSize', 18)
ylabel('$z$','Interpreter', 'latex', 'FontSize',18)
f(2) = subplot(1,2,2);
plot(slice_trans)
set(f, 'FontName', 'Times', 'FontSize', 16)
xlabel('$z$','Interpreter', 'latex', 'FontSize', 18)
ylabel('$\rho_{ToF}$', 'Interpreter','latex', 'FontSize',18)