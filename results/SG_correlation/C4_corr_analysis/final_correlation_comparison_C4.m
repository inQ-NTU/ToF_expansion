clear all
close all
addpath('../../input')

%Cutting boundary by 5 microns
boundary_cut = 20;
boundary_cut_cg = 2;

%loading the data

input_con = h5read('final_correlation_comparison_C4.h5','/input_C4_con');
input_dis = h5read('final_correlation_comparison_C4.h5','/input_C4_dis');
input_full = h5read('final_correlation_comparison_C4.h5', '/input_C4_full');

%truncating the boundary
input_con = input_con(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);
input_dis = input_dis(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);
input_con = input_con(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);

trans_con = h5read('final_correlation_comparison_C4.h5','/trans_C4_con');
trans_dis = h5read('final_correlation_comparison_C4.h5', '/trans_C4_dis');
trans_full = h5read('final_correlation_comparison_C4.h5', '/trans_C4_full');
trans_con = trans_con(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);
trans_dis = trans_dis(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);
trans_con = trans_con(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);

trans_con_wp = h5read('final_correlation_comparison_C4.h5', '/trans_C4_con_with_processing');
trans_dis_wp = h5read('final_correlation_comparison_C4.h5', '/trans_C4_dis_with_processing');
trans_full_wp = h5read('final_correlation_comparison_C4.h5', '/trans_C4_full_with_processing');
trans_con_wp = trans_con_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);
trans_dis_wp = trans_dis_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);
trans_full_wp = trans_full_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);


woc_con = h5read('final_correlation_comparison_C4.h5','/woc_C4_con');
woc_dis = h5read('final_correlation_comparison_C4.h5', '/woc_C4_dis');
woc_full = h5read('final_correlation_comparison_C4.h5', '/woc_C4_full');
woc_con = woc_con(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);
woc_dis = woc_dis(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);
woc_con = woc_con(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);

woc_con_wp = h5read('final_correlation_comparison_C4.h5', '/woc_C4_con_with_processing');
woc_dis_wp = h5read('final_correlation_comparison_C4.h5', '/woc_C4_dis_with_processing');
woc_full_wp = h5read("final_correlation_comparison_C4.h5", '/woc_C4_full_with_processing');
woc_con_wp = woc_con_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);
woc_dis_wp = woc_dis_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);
woc_full_wp = woc_full_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);

wc_con = h5read('final_correlation_comparison_C4.h5','/wc_C4_con');
wc_dis = h5read('final_correlation_comparison_C4.h5', '/wc_C4_dis');
wc_full = h5read('final_correlation_comparison_C4.h5', '/wc_C4_full');

wc_con = wc_con(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);
wc_dis = wc_dis(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);
wc_con = wc_con(boundary_cut:end-boundary_cut, boundary_cut:end-boundary_cut);

wc_con_wp = h5read('final_correlation_comparison_C4.h5', '/wc_C4_con_with_processing');
wc_dis_wp = h5read('final_correlation_comparison_C4.h5', '/wc_C4_dis_with_processing');
wc_full_wp = h5read('final_correlation_comparison_C4.h5', '/wc_C4_full_with_processing');

wc_con_wp = wc_con_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);
wc_dis_wp = wc_dis_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);
wc_full_wp = wc_full_wp(boundary_cut_cg:end-boundary_cut_cg, boundary_cut_cg:end-boundary_cut_cg);


%Defining grid
fine_grid = linspace(-50,50,400);
coarse_grid = linspace(-50,50,52);

fine_grid = fine_grid(boundary_cut:end-boundary_cut);
coarse_grid = coarse_grid(boundary_cut_cg:end-boundary_cut_cg);

%Making the plot
%Correlation without processing
f = tight_subplot(3,3,[.05 .05],[.15 .1],[.1 .15]);

axes(f(1))
imagesc(fine_grid, fine_grid, input_full)
clim([-1,5])
title('\textbf{a}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);
xticks([])
yticks([-45,0,45])
ylabel('$z_1\; (\mu m)$', 'Interpreter', 'latex')

axes(f(2))
imagesc(fine_grid, fine_grid, woc_full)
clim([-1,5])
yticks([])
xticks([])
title('\textbf{b}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(3))
imagesc(fine_grid, fine_grid, wc_full)
clim([-1,5])
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
xticks([])
yticks([])
title('\textbf{c}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(4))
imagesc(fine_grid, fine_grid, input_dis)
clim([0,3.5])
yticks([-45,0,45])
title('\textbf{d}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);
xticks([])
ylabel('$z_1\; (\mu m)$', 'Interpreter', 'latex')

axes(f(5))
imagesc(fine_grid, fine_grid, woc_dis)
clim([0,3.5])
yticks([])
xticks([])
title('\textbf{e}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(6))
imagesc(fine_grid, fine_grid, wc_dis)
clim([0,3.5])
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
xticks([])
yticks([])
title('\textbf{f}','FontName','Time','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);

axes(f(7))
imagesc(fine_grid, fine_grid, input_con)
clim([-2,2])
yticks([-45,0,45])
xticks([-45,0,45])
title('\textbf{g}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);
ylabel('$z_1\; (\mu m)$', 'Interpreter', 'latex')
xlabel('$z_2\; (\mu m)$', 'Interpreter', 'latex')

axes(f(8))
imagesc(fine_grid,fine_grid, woc_con)
clim([-2,2])
yticks([])
xticks([-45,0,45])
title('\textbf{h}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);
xlabel('$z_2\; (\mu m)$', 'Interpreter', 'latex')


axes(f(9))
imagesc(fine_grid, fine_grid, wc_con)
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
clim([-2,2])
yticks([])
xticks([-45,0,45])
title('\textbf{i}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.8]);
xlabel('$z_2\; (\mu m)$', 'Interpreter', 'latex')
colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 16)



%Correlation with processing
figure
g = tight_subplot(3,3,[.05 .05],[.15 .1],[.1 .15]);

axes(g(1))
imagesc(coarse_grid, coarse_grid, trans_full_wp)
clim([-2,3])
title('\textbf{a}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);
xticks([])
yticks([-45,0,45])
ylabel('$z_1\; (\mu m)$', 'Interpreter', 'latex')

axes(g(2))
imagesc(coarse_grid, coarse_grid, woc_full_wp)
clim([-2,3])
yticks([])
xticks([])
title('\textbf{b}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);

axes(g(3))
imagesc(coarse_grid, coarse_grid, wc_full_wp)
clim([-2,3])
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
xticks([])
yticks([])
title('\textbf{c}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);

axes(g(4))
imagesc(coarse_grid, coarse_grid, trans_dis_wp)
clim([0,1.5])
yticks([-45,0,45])
title('\textbf{d}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);
xticks([])
ylabel('$z_1\; (\mu m)$', 'Interpreter', 'latex')

axes(g(5))
imagesc(coarse_grid, coarse_grid, woc_dis_wp)
clim([0,1.5])
yticks([])
xticks([])
title('\textbf{e}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);

axes(g(6))
imagesc(coarse_grid, coarse_grid, wc_dis_wp)
clim([0,1.5])
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
xticks([])
yticks([])
title('\textbf{f}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);

axes(g(7))
imagesc(coarse_grid, coarse_grid, trans_con_wp)
clim([-2,2])
yticks([-45,0,45])
xticks([-45,0,45])
title('\textbf{g}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);
ylabel('$z_1\; (\mu m)$', 'Interpreter', 'latex')
xlabel('$z_2\; (\mu m)$', 'Interpreter', 'latex')

axes(g(8))
imagesc(coarse_grid,coarse_grid, woc_con_wp)
clim([-2,2])
yticks([])
xticks([-45,0,45])
xlabel('$z_2\; (\mu m)$', 'Interpreter', 'latex')
title('\textbf{h}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);
xlabel('$z_2\; (\mu m)$', 'Interpreter', 'latex')

axes(g(9))
imagesc(coarse_grid, coarse_grid, wc_con_wp)
cb = colorbar;
cb.Position = cb.Position +[0.08,0,0,0];
clim([-2,2])
yticks([])
xticks([-45,0,45])
xlabel('$z_2\; (\mu m)$', 'Interpreter', 'latex')
title('\textbf{i}','FontName','Time','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.85,0.75]);


colormap(gge_colormap)
set(g, 'FontName', 'Times', 'FontSize', 16)



