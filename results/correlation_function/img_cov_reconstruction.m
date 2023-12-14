close all
clear all
addpath('../../input')
load('thermal_cov_75nk.mat')

if 0

load('cov_reconstruction.mat')
z_grid_coarse = linspace(-50,50,100);
z_grid_fine = linspace(-50,50,400);
f = tight_subplot(2,3,[.08 .04],[.15 .05],[.1 .12]);
axes(f(1))
imagesc(z_grid_fine, z_grid_fine, cov_phase)
clim([0, 6])
xticks([])
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(2))
imagesc(z_grid_coarse, z_grid_coarse, cov1_woc)
%clim([-0.02,0.02])
clim([0, 6])
yticks([])
xticks([])
%xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(3))
imagesc(z_grid_coarse, z_grid_coarse, cov2_woc)
%clim([-0.02,0.02])
clim([0, 6])
colormap(gge_colormap)
yticks([])
xticks([])
%xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{e}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,-0.3,0,0.15];

axes(f(4))
imagesc(z_grid_coarse, z_grid_coarse, cov_trans)
%clim([-0.02,0.02])
clim([0, 6])
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(5))
imagesc(z_grid_coarse, z_grid_coarse, cov1_wc)
%clim([-0.02,0.02])
clim([0, 6])
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(6))
imagesc(z_grid_coarse, z_grid_coarse, cov2_wc)
%clim([-0.02,0.02])
clim([0, 6])
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

set(f, 'FontName', 'Times', 'FontSize', 16)
end

load('cov_processed_reconstruction.mat')

z_grid_coarse_img = linspace(-50,50,52);

figure
g = tight_subplot(2,2,[.06 .04],[.15 .05],[.1 .15]);
axes(g(1))
imagesc(z_grid_coarse_img, z_grid_coarse_img, cov1_woc)
clim([0,6])
xticks([])
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.95,0.8]);

axes(g(2))
imagesc(z_grid_coarse_img, z_grid_coarse_img, cov2_woc)

clim([0,6])
yticks([])
xticks([])
%xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8])
cb = colorbar(g(2),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.1,-0.3,-0.008,0.15];


axes(g(3))
imagesc(z_grid_coarse_img, z_grid_coarse_img, cov1_wc)
clim([0,6])
colormap(gge_colormap)
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
yl = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
yl.Position(1) = yl.Position(1) +0.5;

axes(g(4))
imagesc(z_grid_coarse_img, z_grid_coarse_img, cov2_wc)
clim([0,6])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
yticks([])
set(g, 'FontName', 'Times', 'FontSize', 20)
