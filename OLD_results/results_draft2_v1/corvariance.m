load('phase_extraction_bank.mat')
addpath('../classes')
addpath('../input')
condensate_length = 80e-6; 
pixel_width = 1e-6;
longitudinal_resolution = 81;
coarse_resolution_z = floor(condensate_length/pixel_width);
z_grid = linspace(-condensate_length/2,condensate_length/2, longitudinal_resolution).*1e6;
z_grid_coarse = linspace(-condensate_length/2,condensate_length/2, coarse_resolution_z+1).*1e6;

corr_in = class_1d_correlation(rel_phase_in_cg);
corr1_woc = class_1d_correlation(ext_phase_woc_1);
%corr2_woc = class_1d_correlation(ext_phase_woc_2);
corr3_woc = class_1d_correlation(ext_phase_woc_3);
corr1_wc = class_1d_correlation(ext_phase_wc_1);
%corr2_wc = class_1d_correlation(ext_phase_wc_2);
corr3_wc = class_1d_correlation(ext_phase_wc_3);

cov_in = corr_in.covariance_matrix();
cov1_woc = corr1_woc.covariance_matrix();
%cov2_woc = corr3_woc.covariance_matrix();
cov3_woc = corr2_woc.covariance_matrix();
cov1_wc = corr1_wc.covariance_matrix();
%cov2_wc = corr2_wc.covariance_matrix();
cov3_wc = corr3_wc.covariance_matrix();

f(1) = subplot(2,3,1);
imagesc(z_grid_coarse, z_grid_coarse, cov_in)
clim([-0.025,0.025])
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.25,0.85]);
ax  = gca;
ax.Position = ax.Position + [0, -0.2, 0, 0];

f(2) = subplot(2,3,2);
imagesc(z_grid_coarse, z_grid_coarse, cov1_woc)
clim([-0.025,0.025])
yticks([])
xticks([])
%xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
f(3) = subplot(2,3,3);
imagesc(z_grid_coarse, z_grid_coarse, cov3_woc)
clim([-0.025,0.025])
colormap(gge_colormap)
yticks([])
xticks([])
%xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.09,-0.3,0,0.15];
set(get(cb,'YLabel'),'Interpreter','latex')
set(get(cb,'YLabel'),'String','$C_u(z,z^\prime)$')
set(get(cb,'YLabel'),'FontSize',10)
cb.Ruler.Exponent = -2;
f(4) = subplot(2,3,5);
imagesc(z_grid_coarse, z_grid_coarse, cov1_wc)
clim([-0.025,0.025])
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(5) = subplot(2,3,6);
imagesc(z_grid_coarse, z_grid_coarse, cov3_wc)
clim([-0.025,0.025])
yticks([])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);


set(f, 'FontName', 'Times', 'FontSize', 10)


