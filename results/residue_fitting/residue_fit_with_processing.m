clear all
close all
addpath('../../input')
addpath('../../classes')
addpath('../../imaging_effect')
addpath('../../imaging_effect/utility')
addpath('../../imaging_effect/image_analysis')
addpath('../../imaging_effect/artificial_imaging')
addpath('../../imaging_effect/artificial_imaging/necessary_functions')

condensate_length = 100e-6;
width_fit_flag = 1;

z_res = 100;
coarse_z_res = 52;
z_grid = linspace(-condensate_length/2,condensate_length/2, z_res);
coarse_grid = linspace(-condensate_length/2, condensate_length/2, coarse_z_res);

n_rel = 4; 
n_com = 6;

rel_phase = pi*cos(n_rel*pi*z_grid/condensate_length);
com_phase = pi*cos(n_com*pi*z_grid/condensate_length);
t_tof = 15e-3;
%% 

interference_suite_woc = class_interference_pattern(rel_phase, t_tof);
interference_suite_wc = class_interference_pattern([rel_phase; com_phase], t_tof);

%cloud widths
cloud_widths = interference_suite_woc.compute_density_sigma_t(0, t_tof);

%Simulating TOF
rho_tof_full_wc = interference_suite_wc.tof_full_expansion();

rho_tof_full_woc = interference_suite_woc.tof_full_expansion();

rho_tof_trans = interference_suite_woc.tof_transversal_expansion();



%artificial imaging
grid_dens = z_grid;
img_rho_tof_trans = absorption_imaging(rho_tof_trans', grid_dens, cloud_widths);
img_rho_tof_woc = absorption_imaging(rho_tof_full_woc', grid_dens, cloud_widths);
img_rho_tof_wc = absorption_imaging(rho_tof_full_wc', grid_dens, cloud_widths);

%coarse graining input
cg_rel_phase = imresize(rel_phase, [1,coarse_z_res]); 

%Coarse graining interference pattern without processing
rho_tof_full_woc_cg = imresize(rho_tof_full_woc, [coarse_z_res coarse_z_res]);
rho_tof_full_wc_cg = imresize(rho_tof_full_wc, [coarse_z_res coarse_z_res]);
rho_tof_trans_cg = imresize(rho_tof_trans, [coarse_z_res coarse_z_res]);

%phase extraction process - with processing
phase_ext_suite_woc = class_phase_extraction(img_rho_tof_woc, t_tof, width_fit_flag);
phase_ext_suite_wc = class_phase_extraction(img_rho_tof_wc, t_tof, width_fit_flag);
phase_ext_suite_trans = class_phase_extraction(img_rho_tof_trans, t_tof, width_fit_flag);

ext_phase_woc = phase_ext_suite_woc.fitting(phase_ext_suite_woc.init_phase_guess());
ext_phase_wc = phase_ext_suite_wc.fitting(phase_ext_suite_wc.init_phase_guess());
ext_phase_trans = phase_ext_suite_trans.fitting(phase_ext_suite_trans.init_phase_guess());

%phase extraction process without processing
phase_ext_suite_woc_ref = class_phase_extraction(rho_tof_full_woc_cg, t_tof, width_fit_flag);
phase_ext_suite_wc_ref = class_phase_extraction(rho_tof_full_wc_cg, t_tof, width_fit_flag);
phase_ext_suite_trans_ref = class_phase_extraction(rho_tof_trans_cg, t_tof, width_fit_flag);

ext_phase_woc_ref = phase_ext_suite_woc_ref.fitting(phase_ext_suite_woc_ref.init_phase_guess());
ext_phase_wc_ref = phase_ext_suite_wc_ref.fitting(phase_ext_suite_wc_ref.init_phase_guess());
ext_phase_trans_ref = phase_ext_suite_trans_ref.fitting(phase_ext_suite_trans_ref.init_phase_guess());

%Defining residue
l= condensate_length*1e6;
z_grid = z_grid*1e6;
coarse_grid = coarse_grid*1e6;

residue_trans = ext_phase_trans - cg_rel_phase;
residue_wc = ext_phase_wc - cg_rel_phase - residue_trans;
residue_woc = ext_phase_woc - cg_rel_phase - residue_trans;

residue_trans_ref = ext_phase_trans_ref - cg_rel_phase;
residue_woc_ref = ext_phase_woc_ref - cg_rel_phase - residue_trans_ref;
residue_wc_ref = ext_phase_wc_ref - cg_rel_phase - residue_trans_ref;

%Fitting residue
fitfun_wc = fittype(@(a,x) a*sin((n_rel*pi/l).*x).*sin((n_com*pi/l).*x));
fitfun_woc = fittype(@(a,x) a*cos((n_rel*pi/l).*x).*(sin((n_rel*pi/l).*x)).^2);
x0 = 0.1;
%fit_wc = fit(coarse_grid', residue_wc', fitfun_wc, 'StartPoint',x0);
%fit_woc = fit(coarse_grid', residue_woc', fitfun_woc, 'StartPoint',x0);
fit_wc_ref = fit(coarse_grid', residue_wc_ref', fitfun_wc, 'StartPoint',x0);
fit_woc_ref = fit(coarse_grid', residue_woc_ref', fitfun_woc, 'StartPoint',x0);

%save('fit_data_15ms.mat', 'rel_phase', 'com_phase', 'z_grid','ext_phase_woc','ext_phase_wc', 'coarse_grid','residue_woc', 'residue_wc', 'fit_woc', 'fit_wc')
%Plotting
f = tight_subplot(2,2,[.05 .1],[.15 .05],[.1 .1]);

axes(f(1))
plot(z_grid, rel_phase, 'Color','Black')
hold on
plot(coarse_grid, ext_phase_wc, 'x', 'Color', 'red')
plot(coarse_grid, ext_phase_wc_ref, 'o', 'Color', 'blue')
plot(z_grid, com_phase, '--', 'Color', 'Black')
ylim([-pi-0.7,pi+0.7])
yticks([-pi, -pi/2,0,pi/2,pi])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8],'FontSize',14)
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')
xticks([])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})

axes(f(2))
plot(coarse_grid, residue_wc, 'x','Color','red')
hold on
plot(coarse_grid, residue_wc_ref, 'o','Color','Blue')
plot(z_grid, fit_wc_ref(z_grid), 'Color','Blue')
%plot(z_grid, fit_wc(z_grid), 'Color','red')
ylim([-1.5,1.5])
yticks([-1,0,1])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8],'FontSize', 14)
ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex')
xticks([])


axes(f(3))
plot(z_grid, rel_phase,'Color','Black')
hold on
plot(coarse_grid, ext_phase_woc, 'x','Color', 'red')
plot(coarse_grid, ext_phase_woc_ref, 'o','Color', 'blue')
plot(z_grid, zeros(1,length(z_grid)), 'LineStyle','--', 'Color','Black')
ylim([-pi-0.7,pi+0.7])
yticks([-pi, -pi/2,0,pi/2,pi])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8], 'FontSize',14);
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')

axes(f(4))
plot(coarse_grid, residue_woc, 'x','Color','red')
hold on
plot(coarse_grid, residue_woc_ref, 'o','Color','blue')
plot(z_grid, fit_woc_ref(z_grid), 'Color','blue')
%plot(z_grid, fit_woc(z_grid) , 'Color','red')
ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex');
%yl.Position(1) = yl.Position(1)+0;
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8], 'FontSize', 14)
yticks([-0.1,0,0.1])
ylim([-0.1,0.1])
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')

set(f, 'FontName', 'Times', 'FontSize', 16)

figure
g = tight_subplot(2,2,[.05 .05],[.15 .05],[.1 .1]);

axes(g(1))
imagesc(z_grid, z_grid, rho_tof_full_wc')
xticks([])
yticks([-50,0,50])
ylabel('$x\; (\mu m)$', 'Interpreter','latex')

axes(g(2))
imagesc(coarse_grid, coarse_grid, img_rho_tof_wc')
xticks([])
yticks([])

axes(g(3))
imagesc(z_grid, z_grid, rho_tof_full_woc')
xticks([-50,0,50])
yticks([-50,0,50])
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')
ylabel('$x\; (\mu m)$', 'Interpreter', 'latex')

axes(g(4))
imagesc(coarse_grid, coarse_grid, img_rho_tof_woc')
xticks([-50,0,50])
yticks([])
xlabel('$z\; (\mu m)$', 'Interpreter', 'latex')

colormap(gge_colormap)
set(g, 'FontName', 'Times', 'FontSize', 16)

