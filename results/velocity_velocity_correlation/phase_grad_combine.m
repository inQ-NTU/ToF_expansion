close all
clear all
addpath('../../input')
load('phase_grad_cov_in_many_samples.mat')
load('vel_vel_correlation.mat')

z_grid_coarse = linspace(-50,50,100);
delta_z_coarse = (z_grid_coarse(2)-z_grid_coarse(1))^2;
z_grid_coarse_img = linspace(-50,50,52);
delta_z_img = (z_grid_coarse_img(2) - z_grid_coarse_img(1))^2;
figure

f = tight_subplot(2,3,[.08 .04],[.15 .05],[.1 .12]);
axes(f(1))
imagesc(z_grid_coarse, z_grid_coarse, cov_in/delta_z_coarse)
%clim([-0.02,0.02])
xticks([])
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(2))
imagesc(z_grid_coarse, z_grid_coarse, cov1_woc/delta_z_coarse)
%clim([-0.02,0.02])
yticks([])
xticks([])
%xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(3))
imagesc(z_grid_coarse, z_grid_coarse, cov2_woc/delta_z_coarse)
%clim([-0.02,0.02])
colormap(gge_colormap)
yticks([])
xticks([])
%xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,-0.3,0,0.15];
set(get(cb,'YLabel'),'Interpreter','latex')
set(get(cb,'YLabel'),'String','$C_u(\rm \mu m^{-2})$')
set(get(cb,'YLabel'),'FontSize',16)
cb.Ruler.Exponent = -2;

axes(f(4))
imagesc(z_grid_coarse, z_grid_coarse, cov_trans/delta_z_coarse)
%clim([-0.02,0.02])
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(5))
imagesc(z_grid_coarse, z_grid_coarse, cov1_wc/delta_z_coarse)
%clim([-0.02,0.02])
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(6))
imagesc(z_grid_coarse, z_grid_coarse, cov2_wc/delta_z_coarse)
%clim([-0.02,0.02])
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

set(f, 'FontName', 'Times', 'FontSize', 16)