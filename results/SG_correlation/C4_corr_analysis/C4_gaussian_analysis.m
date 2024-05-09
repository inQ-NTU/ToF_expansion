clear all
close all

addpath('../../../classes/')
addpath('../../../input/')
load('C2_q05_data.mat')

load('C4_q05_15microns_wop_data.mat')
C4_input_15 = C4_input;
C4_woc_15 = C4_output_woc;
C4_wc_15 = C4_output_wc;
C4_trans_15 = C4_trans;

%Cutting boundary
idx_boundary_cut = 5; %2.5 microns

input_cov = input_cov(idx_boundary_cut:end-idx_boundary_cut, idx_boundary_cut:end-idx_boundary_cut);
wop_woc_cov = wop_woc_cov(idx_boundary_cut:end-idx_boundary_cut, idx_boundary_cut:end-idx_boundary_cut);
wop_wc_cov = wop_wc_cov(idx_boundary_cut:end-idx_boundary_cut, idx_boundary_cut:end-idx_boundary_cut);
trans_cov = trans_cov(idx_boundary_cut:end-idx_boundary_cut, idx_boundary_cut:end-idx_boundary_cut);

%Computing disconnected fourth order correlation (cut)
longitudinal_dim = size(input_cov, 1);

cut_shift_15 = 30; %15 microns away from the center
idx_cut_1_15 = floor(longitudinal_dim/2) + cut_shift_15;
idx_cut_2_15 = floor(longitudinal_dim/2) - cut_shift_15;

C4_dis_cut_woc_15 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_wc_15 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_in_15 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_trans_15 = zeros(longitudinal_dim, longitudinal_dim);

for i  = 1:longitudinal_dim
    for j = 1:longitudinal_dim
        
        C4_dis_cut_in_15(i,j) = input_cov(i, j)*input_cov(idx_cut_1_15, idx_cut_2_15) + input_cov(i, idx_cut_1_15)*...
            input_cov(j,idx_cut_2_15)+input_cov(i,idx_cut_2_15)*input_cov(j,idx_cut_1_15);
        
        C4_dis_cut_woc_15(i,j) = wop_woc_cov(i, j)*wop_woc_cov(idx_cut_1_15, idx_cut_2_15) + wop_woc_cov(i, idx_cut_1_15)*...
            wop_woc_cov(j,idx_cut_2_15)+wop_woc_cov(i,idx_cut_2_15)*wop_woc_cov(j,idx_cut_1_15);

        C4_dis_cut_wc_15(i,j) = wop_wc_cov(i, j)*wop_wc_cov(idx_cut_1_15, idx_cut_2_15) + wop_wc_cov(i, idx_cut_1_15)*...
            wop_wc_cov(j,idx_cut_2_15)+wop_wc_cov(i,idx_cut_2_15)*wop_wc_cov(j,idx_cut_1_15);
        
        C4_dis_cut_trans_15(i,j) = trans_cov(i, j)*trans_cov(idx_cut_1_15, idx_cut_2_15) + trans_cov(i, idx_cut_1_15)*...
            trans_cov(j,idx_cut_2_15)+trans_cov(i,idx_cut_2_15)*trans_cov(j,idx_cut_1_15);
    end
end

C4_con_in_15 = C4_input_15 - C4_dis_cut_in_15;
C4_con_woc_15 = C4_woc_15 - C4_dis_cut_woc_15;
C4_con_wc_15 = C4_wc_15 - C4_dis_cut_wc_15;
C4_con_trans_15 = C4_trans_15 - C4_dis_cut_trans_15;

%Plotting
z_grid_full = linspace(-50,50, 200);
z_grid = z_grid_full(idx_boundary_cut:end-idx_boundary_cut);

f = tight_subplot(3,3, [0.06,0.05], [0.1, 0.1], [0.1, 0.1]);

axes(f(1))
imagesc(z_grid, z_grid, C4_trans_15)
clim([-5,28])
xticks([])
yticks([-45,0,45])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


axes(f(2))
imagesc(z_grid, z_grid, C4_woc_15)
clim([-5,28])
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


axes(f(3))
imagesc(z_grid, z_grid, C4_wc_15)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
clim([-5,28])
xticks([])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


axes(f(4))
imagesc(z_grid, z_grid, C4_dis_cut_trans_15)
clim([-5,28])
xticks([])
yticks([-45,0,45])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


axes(f(5))
imagesc(C4_dis_cut_woc_15)
clim([-5,28])
xticks([])
yticks([])
title('$\mathbf{e}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


axes(f(6))
imagesc(z_grid, z_grid, C4_dis_cut_wc_15)
clim([-5,28])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
xticks([])
yticks([])
title('$\mathbf{f}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


axes(f(7))
imagesc(z_grid, z_grid, C4_con_trans_15)
clim([-5,28])
yticks([-45,0,45])
xticks([-45,0,45])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{g}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


axes(f(8))
imagesc(z_grid, z_grid, C4_con_woc_15)
clim([-5,28])
yticks([])
xticks([-45,0,45])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{h}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


axes(f(9))
imagesc(z_grid, z_grid, C4_con_wc_15)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
clim([-5,28])
yticks([])
xticks([-45,0,45])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{i}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);


set(f,'FontName', 'Times', 'FontSize', 16)

colormap(gge_colormap)