clear all
close all

load('cov_SG_05.mat')
cov_05_wc_10ms = cov_wc_10ms;
cov_05_wc_20ms = cov_wc_20ms;
cov_05_in = cov_in;

load('cov_SG_3.mat')
cov_3_wc_10ms = cov_wc_10ms;
cov_3_wc_20ms = cov_wc_20ms;
cov_3_in = cov_in;

z_grid = linspace(-50,50,size(cov_3_in,1));

figure
f = tight_subplot(2,3,[.1 .05],[.15 .1],[.1 .1]);

axes(f(1))
imagesc(z_grid, z_grid, cov_05_in)
clim([0, 16])
xticks([])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
title('\textbf{a}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(2))
imagesc(z_grid, z_grid, cov_05_wc_10ms)
clim([0, 16])
yticks([])
xticks([])
title('\textbf{b}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(3))
imagesc(z_grid, z_grid, cov_05_wc_20ms)
clim([0, 16])
yticks([])
xticks([])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
title('\textbf{c}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(4))
imagesc(z_grid, z_grid, cov_3_in)
clim([0,7])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
title('\textbf{d}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(5))
imagesc(z_grid, z_grid, cov_3_wc_10ms)
clim([0,7])
yticks([])
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('\textbf{e}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(6))
imagesc(z_grid, z_grid, cov_3_wc_20ms)
clim([0,7])
yticks([])
xlabel('$z_2\; \rm (\mu m)$', 'Interpreter','latex')
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
title('\textbf{f}','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 16)