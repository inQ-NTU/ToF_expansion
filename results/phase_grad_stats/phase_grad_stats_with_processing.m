clear all
close all
addpath('../../classes')
addpath('../../input')
load('ext_phase_500samples_with_processing.mat')

coarse_res = size(ext_phase_wp_woc, 2);
fine_res = size(rel_phase, 2);
num_samples = size(rel_phase, 1);

gradient_in = zeros(num_samples, fine_res);
gradient_wop_woc = zeros(num_samples, fine_res);
gradient_wop_wc = zeros(num_samples, fine_res);
gradient_wp_woc = zeros(num_samples, coarse_res);
gradient_wp_wc = zeros(num_samples, coarse_res);

for i = 1:num_samples
    gradient_in(i,:) = gradient(rel_phase(i,:));
    gradient_wop_woc(i,:) = gradient(ext_phase_wop_woc(i,:));
    gradient_wop_wc(i,:) = gradient(ext_phase_wop_wc(i,:));
    gradient_wp_woc(i,:) = gradient(ext_phase_wp_woc(i,:));
    gradient_wp_wc(i,:) = gradient(ext_phase_wp_wc(i,:));
end

corr_grad_in = class_1d_correlation(gradient_in);
corr_grad_wop_woc = class_1d_correlation(gradient_wop_woc);
corr_grad_wop_wc = class_1d_correlation(gradient_wop_wc);
corr_grad_wp_woc = class_1d_correlation(gradient_wp_woc);
corr_grad_wp_wc = class_1d_correlation(gradient_wp_wc);

vv_in = corr_grad_in.covariance_matrix();
vv_wop_woc = corr_grad_wop_woc.covariance_matrix();
vv_wop_wc = corr_grad_wop_wc.covariance_matrix();
vv_wp_woc = corr_grad_wp_woc.covariance_matrix();
vv_wp_wc = corr_grad_wp_wc.covariance_matrix();

figure
f = tight_subplot(2,2,[.05 .05],[.15 .1],[.1 .15]);

axes(f(1))
imagesc(fine_grid, fine_grid, vv_wop_woc)
clim([-0.02,0.02])
xticks([])
ylabel('$z\; (\mu m)$', 'Interpreter','latex')
title('\textbf{a}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(2))
imagesc(fine_grid, fine_grid, vv_wop_wc)
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
clim([-0.02,0.02])
yticks([])
xticks([])
title('\textbf{b}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(3))
imagesc(coarse_grid(5:47), coarse_grid(5:47), vv_wp_woc(5:47, 5:47))
clim([-0.1,0.1])
ylabel('$z\; (\mu m)$', 'Interpreter','latex')
xlabel('$z^\prime\; (\mu m)$', 'Interpreter','latex')
title('\textbf{c}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(4))
imagesc(coarse_grid(5:47), coarse_grid(5:47), vv_wp_wc(5:47,5:47))
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
clim([-0.1,0.1])
yticks([])
xlabel('$z^\prime\; (\mu m)$', 'Interpreter','latex')
title('\textbf{d}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 16)