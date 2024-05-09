clear all
close all

addpath('../../../input')
load('cov_matrix_15ms.mat')


z_grid = linspace(-45,45,180);

%Cutting boundary
boundary_index_cut = 10;
cov_input_05 = cov_input_05(boundary_index_cut:end-boundary_index_cut, boundary_index_cut:end-boundary_index_cut);
cov_input_3 = cov_input_3(boundary_index_cut:end-boundary_index_cut, boundary_index_cut:end-boundary_index_cut);

cov_output_woc_05 = cov_output_woc_05(boundary_index_cut:end-boundary_index_cut, boundary_index_cut:end-boundary_index_cut);
cov_output_woc_3 = cov_output_woc_3(boundary_index_cut:end-boundary_index_cut, boundary_index_cut:end-boundary_index_cut);

cov_output_wc_05 = cov_output_wc_05(boundary_index_cut:end-boundary_index_cut, boundary_index_cut:end-boundary_index_cut);
cov_output_wc_3 = cov_output_wc_3(boundary_index_cut:end-boundary_index_cut, boundary_index_cut:end-boundary_index_cut);

%Plotting
f = tight_subplot(2,3, [0.08,0.06], [0.15, 0.1], [0.1, 0.1]);
axes(f(1))
imagesc(z_grid, z_grid, cov_input_05)
clim([0,15])
xticks([])
yticks([-45,0,45])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(2))
imagesc(z_grid, z_grid, cov_output_woc_05)
clim([0,15])
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(3))
imagesc(z_grid, z_grid, cov_output_wc_05)
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
clim([0,15])
xticks([])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(4))
imagesc(z_grid, z_grid, cov_input_3)
clim([0,5])
xticks([-45,0,45])
yticks([-45,0,45])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(5))
imagesc(z_grid, z_grid, cov_output_woc_3)
clim([0,5])
yticks([])
xticks([-45,0,45])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{e}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(6))
imagesc(z_grid, z_grid, cov_output_wc_3)
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
clim([0,5])
yticks([])
xticks([-45,0,45])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

colormap(gge_colormap)
set(f,'FontName', 'Times', 'FontSize', 16)