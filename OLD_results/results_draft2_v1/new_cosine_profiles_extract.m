clear all
close all
addpath('../input')
addpath('../classes')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 2e-6;
sampling_suite = class_gaussian_phase_sampling(cov_phase);
longitudinal_resolution = size(cov_phase,1);
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = floor(transversal_length/pixel_width);

z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z).*1e6;

%rel_phase = sampling_suite.generate_profiles();
%com_phase = sampling_suite.generate_profiles();
n_rel = 6;
n_com = 3;
rel_phase = cos(n_rel*pi*z_grid/(condensate_length.*1e6));
com_phase = pi*cos(n_com*pi*z_grid/(condensate_length.*1e6));
cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase);

t_tof_1 = 7e-3;
t_tof_2 = 15e-3;

interference_suite_woc_1 = class_interference_pattern(rel_phase, t_tof_1);
interference_suite_woc_2 = class_interference_pattern(rel_phase, t_tof_2);

interference_suite_wc_1 = class_interference_pattern([rel_phase; com_phase], t_tof_1);
interference_suite_wc_2 = class_interference_pattern([rel_phase; com_phase], t_tof_2);

rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
rho_tof_woc_1 = imresize(rho_tof_woc_1, [coarse_resolution_z, coarse_resolution_x]);
rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
rho_tof_woc_2 = imresize(rho_tof_woc_2, [coarse_resolution_z, coarse_resolution_x]);
rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
rho_tof_wc_1 = imresize(rho_tof_wc_1,  [coarse_resolution_z, coarse_resolution_x]);
rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
rho_tof_wc_2 = imresize(rho_tof_wc_2,  [coarse_resolution_z, coarse_resolution_x]);
rho_tof_trans = interference_suite_woc_2.tof_transversal_expansion();
rho_tof_trans = imresize(rho_tof_trans, [coarse_resolution_z, coarse_resolution_x]);

%phase extraction process
phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);
phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t_tof_2);
ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());

ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());

ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());
%Fitting residue
l= condensate_length*1e6;
residue_1_wc = ext_phase_wc_1 - cg_rel_phase;
residue_2_wc = ext_phase_wc_2 - cg_rel_phase;
%residue_1_woc = ext_phase_woc_1 - cg_rel_phase;
%residue_2_woc = ext_phase_woc_2 - cg_rel_phase;
%fitfun = fittype(@(a,x) a*cos((3*pi/l).*x).*sin((2*pi/l).*x));
fitfun_wc = fittype(@(a,x) a*n_rel*n_com*sin((n_rel*pi/l).*x).*sin((n_com*pi/l).*x));
%fitfun_woc = fittype(@(a,x) a*cos((n_rel*pi/l).*x).*(sin((n_rel*pi/l).*x)).^2);
%fitfun_woc = fittype(@(a,k,x) atan(a*(n_rel*c_rel*sin((n_rel*pi/l).*x)+n_rel_2*c_rel_2*sin((n_rel_2*pi/l))).*sin(abs(k).*x)));
%fitfun = fittype(@(a,x) a*(sin((4*pi/l).*x).^2+2*cos((4*pi/l).*x).*(sin((2*pi/l).*x)).^2+8*cos((4*pi/l).*x).*(sin((4*pi/l).*x)).^2));
x0 = 0.1; 
x0_n = [0.1,1e-6];
fit_wc_1 = fit(z_grid_coarse', residue_1_wc', fitfun_wc,'StartPoint', x0);
fit_wc_2 = fit(z_grid_coarse', residue_2_wc', fitfun_wc, 'StartPoint',x0);
%fit_woc_1 = fit(z_grid_coarse', residue_1_woc', fitfun_woc,'StartPoint', x0);
%fit_woc_2 = fit(z_grid_coarse', residue_2_woc', fitfun_woc, 'StartPoint',x0);


%plotting
figure
f(1) = subplot(2,2,1);
plot(z_grid, rel_phase, 'Color','Black')
hold on
plot(z_grid_coarse, ext_phase_woc_1, 'o','Color','Blue','MarkerSize',3)
plot(z_grid_coarse, ext_phase_woc_2, 'x','Color','red','MarkerSize',4)
plot(z_grid, zeros(1, longitudinal_resolution),'--','Color','Black')
ylim([-pi,pi])
yticks([-pi, -pi/2,0,pi/2,pi])
xticks([])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(2) = subplot(2,2,2);
%fine_grid = linspace(-l/2, l/2);
plot(z_grid_coarse, ext_phase_woc_1 - cg_rel_phase, 'o', 'Color', 'Blue', 'MarkerSize', 3);
hold on
%plot(fine_grid, fit_woc_1(fine_grid),'Color','Blue')
plot(z_grid_coarse, ext_phase_woc_2 - cg_rel_phase, 'x','Color', 'Red', 'MarkerSize', 4);
%plot(fine_grid, fit_woc_2(fine_grid), 'Color', 'red')
plot(z_grid_coarse, ext_phase_trans - cg_rel_phase, 'Color','green')
xticks([])
ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
%yticks([-pi/2,0,pi/2])
%yticklabels({'-\pi/2', '0', '\pi/2'})
%ylim([-pi/2,pi/2])
f(3) = subplot(2,2,3);
plot(z_grid, rel_phase, 'Color','black')
hold on
plot(z_grid_coarse, ext_phase_wc_1, 'o','Color','Blue','MarkerSize',3)
plot(z_grid_coarse, ext_phase_wc_2, 'x','Color','red', 'MarkerSize', 4)
plot(z_grid, com_phase, '--', 'Color','Black')
ylim([-pi,pi])
yticks([-pi, -pi/2,0,pi/2,pi])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')

f(4) = subplot(2,2,4);
fine_grid = linspace(-l/2, l/2);
plot(z_grid_coarse, ext_phase_wc_1 - cg_rel_phase, 'o', 'Color', 'Blue', 'MarkerSize', 3);
hold on
plot(z_grid_coarse, ext_phase_wc_2 - cg_rel_phase, 'x','Color', 'Red', 'MarkerSize', 4);
plot(fine_grid, fit_wc_1(fine_grid),'Color','Blue')
plot(fine_grid, fit_wc_2(fine_grid), 'Color', 'red')
plot(z_grid_coarse, ext_phase_trans - cg_rel_phase, 'Color','green')
%plot(z_grid_coarse, zeros(1,length(z_grid_coarse)),'-')
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')
%ylim([-pi/2,pi/2])
%yticks([-pi/2,0,pi/2])
%yticklabels({'-\pi/2', '0', '\pi/2'})
set(f, 'FontName', 'Times', 'FontSize', 10)
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85])
ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex')