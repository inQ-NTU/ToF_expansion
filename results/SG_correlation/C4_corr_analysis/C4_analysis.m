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

load('C4_q05_10microns_wop_data.mat')
C4_input_10 = C4_input;
C4_woc_10 = C4_output_woc;
C4_wc_10 = C4_output_wc;
C4_trans_10 = C4_trans;

%Cutting boundary
idx_boundary_cut = 10; %5 microns

input_cov = input_cov(idx_boundary_cut:end-idx_boundary_cut, idx_boundary_cut:end-idx_boundary_cut);
wop_woc_cov = wop_woc_cov(idx_boundary_cut:end-idx_boundary_cut, idx_boundary_cut:end-idx_boundary_cut);
wop_wc_cov = wop_wc_cov(idx_boundary_cut:end-idx_boundary_cut, idx_boundary_cut:end-idx_boundary_cut);
trans_cov = trans_cov(idx_boundary_cut:end-idx_boundary_cut, idx_boundary_cut:end-idx_boundary_cut);

%Computing disconnected fourth order correlation (cut)
longitudinal_dim = size(input_cov, 1);

cut_shift_15 = 30; %15 microns away from the center
cut_shift_10 = 20; %10 microns away from the center

idx_cut_1_15 = floor(longitudinal_dim/2) + cut_shift_15;
idx_cut_2_15 = floor(longitudinal_dim/2) - cut_shift_15;

idx_cut_1_10 = floor(longitudinal_dim/2) + cut_shift_10;
idx_cut_2_10 = floor(longitudinal_dim/2) - cut_shift_10;

C4_dis_cut_woc_15 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_wc_15 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_in_15 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_trans_15 = zeros(longitudinal_dim, longitudinal_dim);

C4_dis_cut_woc_10 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_wc_10 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_in_10 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_trans_10 = zeros(longitudinal_dim, longitudinal_dim);

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
        
        C4_dis_cut_in_10(i,j) = input_cov(i, j)*input_cov(idx_cut_1_10, idx_cut_2_10) + input_cov(i, idx_cut_1_10)*...
            input_cov(j,idx_cut_2_10)+input_cov(i,idx_cut_2_10)*input_cov(j,idx_cut_1_10);
        
        C4_dis_cut_woc_10(i,j) = wop_woc_cov(i, j)*wop_woc_cov(idx_cut_1_10, idx_cut_2_10) + wop_woc_cov(i, idx_cut_1_10)*...
            wop_woc_cov(j,idx_cut_2_10)+wop_woc_cov(i,idx_cut_2_10)*wop_woc_cov(j,idx_cut_1_10);

        C4_dis_cut_wc_10(i,j) = wop_wc_cov(i, j)*wop_wc_cov(idx_cut_1_10, idx_cut_2_10) + wop_wc_cov(i, idx_cut_1_10)*...
            wop_wc_cov(j,idx_cut_2_10)+wop_wc_cov(i,idx_cut_2_10)*wop_wc_cov(j,idx_cut_1_10);
        
        C4_dis_cut_trans_10(i,j) = trans_cov(i, j)*trans_cov(idx_cut_1_10, idx_cut_2_10) + trans_cov(i, idx_cut_1_10)*...
            trans_cov(j,idx_cut_2_10)+trans_cov(i,idx_cut_2_10)*trans_cov(j,idx_cut_1_10);
    end
end

%Computing connected fourth-order correlation
C4_con_in_15 = C4_input_15 - C4_dis_cut_in_15;
C4_con_woc_15 = C4_woc_15 - C4_dis_cut_woc_15;
C4_con_wc_15 = C4_wc_15 - C4_dis_cut_wc_15;
C4_con_trans_15 = C4_trans_15 - C4_dis_cut_trans_15;

C4_con_in_10 = C4_input_10 - C4_dis_cut_in_10;
C4_con_woc_10 = C4_woc_10 - C4_dis_cut_woc_10;
C4_con_wc_10 = C4_wc_10 - C4_dis_cut_wc_10;
C4_con_trans_10 = C4_trans_10 - C4_dis_cut_trans_10;

%Plotting
%1. Disconnected C4
z_grid_full = linspace(-50,50, 400);
z_grid = z_grid_full(idx_boundary_cut:end-idx_boundary_cut);


f = tight_subplot(2,3, [0.15,0.1], [0.15, 0.1], [0.1, 0.1]);
axes(f(1))

imagesc(z_grid, z_grid, C4_dis_cut_trans_15);
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
clim([-5,25])
xticks([])
yticks([-45,0,45])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(2))
imagesc(z_grid, z_grid, C4_dis_cut_woc_15)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
clim([-5,25])
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(3))
imagesc(z_grid, z_grid, C4_dis_cut_wc_15)
clim([-5,25])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
xticks([])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(4))
imagesc(z_grid, z_grid, C4_dis_cut_trans_10)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([0,3])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
yticks([-45,0,45])
xticks([-45,0,45])

axes(f(5))
imagesc(z_grid, z_grid, C4_dis_cut_woc_10)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([0,2])
yticks([])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
xticks([-45,0,45])

axes(f(6))
imagesc(z_grid, z_grid, C4_dis_cut_wc_10)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([0,2])
yticks([])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
xticks([-45,0,45])

colormap(gge_colormap)
set(f,'FontName', 'Times', 'FontSize', 16)

%2. Connected C4
figure
g = tight_subplot(2,3, [0.15,0.15], [0.15, 0.1], [0.1, 0.1]);

axes(g(1))
imagesc(z_grid, z_grid, C4_con_trans_15);
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
clim([-5,25])
xticks([])
yticks([-45,0,45])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(g(2))
imagesc(z_grid, z_grid, C4_con_woc_15)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
clim([-5,25])
%clim([-0.2,0.6])
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(g(3))
imagesc(z_grid, z_grid, C4_con_wc_15)
%clim([-0.2,0.6])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
clim([-1,1])
xticks([])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(g(4))
imagesc(z_grid, z_grid, C4_con_trans_10)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([-2,2])
%clim([0,4])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
yticks([-45,0,45])
xticks([-45,0,45])


axes(g(5))
imagesc(z_grid, z_grid, C4_con_woc_10)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([-2,2])
%clim([0,2.5])
yticks([])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{e}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
xticks([-45,0,45])

axes(g(6))
imagesc(z_grid, z_grid, C4_con_wc_10)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([-2,2])
%clim([0,2.5])
yticks([])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
xticks([-45,0,45])

colormap(gge_colormap)
set(g,'FontName', 'Times', 'FontSize', 16)