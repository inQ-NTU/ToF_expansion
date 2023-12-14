%clear all
%close all
addpath('../../input')
addpath('../../classes')
load('thermal_cov_75nk.mat')
condensate_length = 100e-6;
transversal_length = 120e-6; 
pixel_width = 2e-6;
num_atoms = 10^4;

%sampling suite is used only to coarse-grain (cg_rel_phase)-> inefficient
sampling_suite = class_gaussian_phase_sampling(cov_phase);

longitudinal_resolution = size(cov_phase,1);
coarse_resolution_z = floor(condensate_length/pixel_width);
coarse_resolution_x = floor(transversal_length/pixel_width);

z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z).*1e6;

n_rel = 4;
n_com = 6;

rel_phase = pi*cos(n_rel*pi*z_grid/(condensate_length.*1e6));
com_phase = pi*cos(n_com*pi*z_grid/(condensate_length.*1e6));
cg_rel_phase = sampling_suite.coarse_grain(coarse_resolution_z, rel_phase); 
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;

interference_suite_woc_1 = class_interference_pattern(rel_phase, t_tof_1);
interference_suite_woc_2 = class_interference_pattern(rel_phase, t_tof_2);
interference_suite_wc_1 = class_interference_pattern([rel_phase; com_phase], t_tof_1);
interference_suite_wc_2 = class_interference_pattern([rel_phase; com_phase], t_tof_2);

rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
rho_tof_wc_1 = interference_suite_wc_1.normalize(rho_tof_wc_1, num_atoms);
rho_tof_wc_1 = imresize(rho_tof_wc_1,  [coarse_resolution_z, coarse_resolution_x]);

rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
rho_tof_wc_2 = interference_suite_wc_2.normalize(rho_tof_wc_2, num_atoms);
rho_tof_wc_2 = imresize(rho_tof_wc_2,  [coarse_resolution_z, coarse_resolution_x]);

rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
rho_tof_woc_1 = interference_suite_woc_1.normalize(rho_tof_woc_1, num_atoms);
rho_tof_woc_1 = imresize(rho_tof_woc_1,  [coarse_resolution_z, coarse_resolution_x]);

rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();
rho_tof_woc_2 = interference_suite_woc_2.normalize(rho_tof_woc_2, num_atoms);
rho_tof_woc_2 = imresize(rho_tof_woc_2,  [coarse_resolution_z, coarse_resolution_x]);

rho_tof_trans = interference_suite_woc_1.tof_transversal_expansion();
rho_tof_trans = interference_suite_woc_1.normalize(rho_tof_trans, num_atoms);
rho_tof_trans = imresize(rho_tof_trans,  [coarse_resolution_z, coarse_resolution_x]);

%phase extraction process
phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);
phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);
phase_ext_suite_trans = class_phase_extraction(rho_tof_trans, t_tof_1);

ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());

ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());

ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());

%Fitting residue
l= condensate_length*1e6;
residue_trans = ext_phase_trans - cg_rel_phase;
residue_1_wc = ext_phase_wc_1 - cg_rel_phase - residue_trans;
residue_2_wc = ext_phase_wc_2 - cg_rel_phase - residue_trans;
residue_1_woc = ext_phase_woc_1 - cg_rel_phase - residue_trans;
residue_2_woc = ext_phase_woc_2 - cg_rel_phase - residue_trans;
fitfun_wc = fittype(@(a,x) a*sin((n_rel*pi/l).*x).*sin((n_com*pi/l).*x));
fitfun_woc = fittype(@(a,x) a*cos((n_rel*pi/l).*x).*(sin((n_rel*pi/l).*x)).^2);

x0 = 0.1; 
fit_wc_1 = fit(z_grid_coarse', residue_1_wc', fitfun_wc,'StartPoint', x0);
fit_wc_2 = fit(z_grid_coarse', residue_2_wc', fitfun_wc, 'StartPoint',x0);
fit_woc_1 = fit(z_grid_coarse', residue_1_woc', fitfun_woc,'StartPoint', x0);
fit_woc_2 = fit(z_grid_coarse', residue_2_woc', fitfun_woc, 'StartPoint',x0);

%plotting
figure
f = tight_subplot(2,2,[.05 .1],[.15 .05],[.1 .1]);
axes(f(1))
plot(z_grid, rel_phase, 'Color','black')
hold on
plot(z_grid_coarse, ext_phase_wc_1, 'o','Color','Blue','MarkerSize',3)
plot(z_grid_coarse, ext_phase_wc_2, 'x','Color','red', 'MarkerSize', 4)
plot(z_grid, com_phase, '--', 'Color','Black')
ylim([-pi-0.7,pi+0.7])
yticks([-pi, -pi/2,0,pi/2,pi])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')
xticks([])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})

axes(f(2))
fine_grid = linspace(-l/2, l/2);
plot(z_grid_coarse, residue_1_wc, 'o', 'Color', 'Blue', 'MarkerSize', 3);
hold on
plot(z_grid_coarse, residue_2_wc, 'x','Color', 'Red', 'MarkerSize', 4);
plot(fine_grid, fit_wc_1(fine_grid),'Color','Blue')
plot(fine_grid, fit_wc_2(fine_grid), 'Color', 'red')
%plot(z_grid_coarse, zeros(1,length(z_grid_coarse)),'-')
ylim([-1.5,1.5])
yticks([-1,0,1])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex')
xticks([])

axes(f(3))
plot(z_grid, rel_phase, 'Color','Black')
hold on
plot(z_grid_coarse, ext_phase_woc_1, 'o','Color','Blue','MarkerSize',3)
plot(z_grid_coarse, ext_phase_woc_2, 'x','Color','red','MarkerSize',4)
plot(z_grid, zeros(1, longitudinal_resolution),'--','Color','Black')
ylim([-pi-0.7,pi+0.7])
yticks([-pi, -pi/2,0,pi/2,pi])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')

axes(f(4))
fine_grid = linspace(-l/2, l/2);
plot(z_grid_coarse, residue_1_woc, 'o', 'Color', 'Blue', 'MarkerSize', 3);
hold on
plot(fine_grid, fit_woc_1(fine_grid),'Color','Blue')
plot(z_grid_coarse, residue_2_woc, 'x','Color', 'Red', 'MarkerSize', 4);
plot(fine_grid, fit_woc_2(fine_grid), 'Color', 'red')
yl = ylabel(gca, '$\Delta\phi_{-}(z)$','Interpreter','latex');
yl.Position(1) = yl.Position(1)+5;
yl.Position(2) = yl.Position(2)+0.05;
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
yticks([-0.1,0,0.1])
ylim([-0.1,0.1])
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')

set(f, 'FontName', 'Times', 'FontSize', 16)