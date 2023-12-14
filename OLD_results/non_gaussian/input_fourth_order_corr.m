close all
clear all
addpath('../classes')
addpath('../input')
load('SG_profiles.mat')
load('fit_phase_SG_2_t7_wc.mat')
fit_profiles_full_t7 = fit_profiles_full;
load('fit_phase_SG_2_t30_wc.mat')
fit_profiles_full_t30 = fit_profiles_full;

coarse_dim = 100;
condensate_length = 100;
z_grid_out = linspace(-condensate_length/2, condensate_length/2, coarse_dim);
z3 = 3*coarse_dim/4;
z4 = coarse_dim/4;
input_phase = phase_SG_2_subsampling;
cg_phase = downsample(input_phase, floor(size(input_phase,1)/coarse_dim));
z_grid_in = linspace(-condensate_length/2, condensate_length/2, size(cg_phase,1));

%1D Correlation calculation
corr_suite = class_1d_correlation(cg_phase');
corr_fit_suite_t7 = class_1d_correlation(fit_profiles_full_t7);
corr_fit_suite_t30 = class_1d_correlation(fit_profiles_full_t30);

%Full Correlator
g4 = corr_suite.fourth_order_corr(z3,z4);
g4_fit_t7 = corr_fit_suite_t7.fourth_order_corr(z3,z4);
g4_fit_t30 = corr_fit_suite_t30.fourth_order_corr(z3,z4);


%disconnected correlator
w4 = corr_suite.wick_four_point_correlation();
w4_fit_t7 = corr_fit_suite_t7.wick_four_point_correlation();
w4_fit_t30 = corr_fit_suite_t30.wick_four_point_correlation();
w4 = w4(:,:, z3, z4);
w4_fit_t7 = w4_fit_t7(:,:, z3, z4);
w4_fit_t30 = w4_fit_t30(:,:, z3, z4);


%deviation
gw4_dev = g4 - w4;
gw4_dev_fit_t7 = g4_fit_t7 - w4_fit_t7;
gw4_dev_fit_t30 = g4_fit_t30 - w4_fit_t30;

%Plotting
figure
f(1) =subplot(3,3,1);
imagesc(z_grid_in, z_grid_in, g4)
clim([-2,18])
xticks([])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;


f(2) = subplot(3,3,2);
imagesc(z_grid_out, z_grid_out, g4_fit_t7)
clim([-2,18])
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(3) = subplot(3,3,3);
imagesc(z_grid_out, z_grid_out, g4_fit_t30)
clim([-2,18])
cb1 = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb1.Position = cb1.Position + [0.09,0,0,0];
xticks([])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(4) = subplot(3,3,4);
imagesc(z_grid_in, z_grid_in, w4)
clim([-2,18])
xticks([])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;

f(5) = subplot(3,3,5);
imagesc(z_grid_out, z_grid_out, w4_fit_t7)
clim([-2,18])
xticks([])
yticks([])
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(6) = subplot(3,3,6);
imagesc(z_grid_out, z_grid_out, w4_fit_t30)
clim([-2,18])
cb2 = colorbar(f(6),'Location','EastOutside','TickLabelInterpreter','latex');
cb2.Position = cb2.Position + [0.09,0,0,0];
xticks([])
yticks([])
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);


f(7) = subplot(3,3,7);
imagesc(z_grid_in, z_grid_in, gw4_dev)
clim([-5,5])
title('$\mathbf{g}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')

f(8) = subplot(3,3,8);
imagesc(z_grid_out, z_grid_out, gw4_dev_fit_t7)
clim([-5,5])
yticks([])
title('$\mathbf{h}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')

f(9) = subplot(3,3,9);
imagesc(z_grid_out, z_grid_out, gw4_dev_fit_t30)
clim([-5,5])
cb3 = colorbar(f(9),'Location','EastOutside','TickLabelInterpreter','latex');
cb3.Position = cb3.Position + [0.09,0,0,0];
yticks([])
title('$\mathbf{i}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')

colormap(gge_colormap)


set(f, 'FontName', 'Times', 'FontSize', 16)

