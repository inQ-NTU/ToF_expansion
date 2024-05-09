clear all
close all

addpath('../../../classes/')
addpath('../../../input/')
load('C2_q05_data_with_processing.mat')

load('C4_q05_5p8microns_wp_data.mat')
C4_trans_5p8 = C4_trans;
C4_woc_5p8 = C4_output_woc;
C4_wc_5p8 = C4_output_wc;

load('C4_q05_11p5microns_wp_data.mat')
C4_trans_11p5 = C4_trans;
C4_woc_11p5 = C4_output_woc;
C4_wc_11p5 = C4_output_wc;


%Computing disconnected fourth order correlation (cut)
longitudinal_dim = size(cov_trans, 1);

cut_shift_5p8 = 3 ; % 5.5 microns away from the center
cut_shift_11p5 = 6; %11.5 microns away from the center

idx_cut_1_5p8 = floor(longitudinal_dim/2) + cut_shift_5p8;
idx_cut_2_5p8 = floor(longitudinal_dim/2) - cut_shift_5p8;

idx_cut_1_11p5 = floor(longitudinal_dim/2) + cut_shift_11p5;
idx_cut_2_11p5 = floor(longitudinal_dim/2) - cut_shift_11p5;

C4_dis_cut_woc_5p8 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_wc_5p8 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_trans_5p8 = zeros(longitudinal_dim, longitudinal_dim);

C4_dis_cut_woc_11p5 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_wc_11p5 = zeros(longitudinal_dim, longitudinal_dim);
C4_dis_cut_trans_11p5 = zeros(longitudinal_dim, longitudinal_dim);

for i  = 1:longitudinal_dim
    for j = 1:longitudinal_dim
         
        C4_dis_cut_trans_5p8(i,j) = cov_trans(i, j)*cov_trans(idx_cut_1_5p8, idx_cut_2_5p8) + cov_trans(i, idx_cut_1_5p8)*...
            cov_trans(j,idx_cut_2_5p8)+cov_trans(i,idx_cut_2_5p8)*cov_trans(j,idx_cut_1_5p8);
        
        C4_dis_cut_woc_5p8(i,j) = cov_woc(i, j)*cov_woc(idx_cut_1_5p8, idx_cut_2_5p8) + cov_woc(i, idx_cut_1_5p8)*...
            cov_woc(j,idx_cut_2_5p8)+cov_woc(i,idx_cut_2_5p8)*cov_woc(j,idx_cut_1_5p8);

        C4_dis_cut_wc_5p8(i,j) = cov_wc(i, j)*cov_wc(idx_cut_1_5p8, idx_cut_2_5p8) + cov_wc(i, idx_cut_1_5p8)*...
            cov_wc(j,idx_cut_2_5p8)+cov_wc(i,idx_cut_2_5p8)*cov_wc(j,idx_cut_1_5p8);

        C4_dis_cut_trans_11p5(i,j) = cov_trans(i, j)*cov_trans(idx_cut_1_11p5, idx_cut_2_11p5) + cov_trans(i, idx_cut_1_11p5)*...
            cov_trans(j,idx_cut_2_11p5)+cov_trans(i,idx_cut_2_11p5)*cov_trans(j,idx_cut_1_11p5);
        
        C4_dis_cut_woc_11p5(i,j) = cov_woc(i, j)*cov_woc(idx_cut_1_11p5, idx_cut_2_11p5) + cov_woc(i, idx_cut_1_11p5)*...
            cov_woc(j,idx_cut_2_11p5)+cov_woc(i,idx_cut_2_11p5)*cov_woc(j,idx_cut_1_11p5);

        C4_dis_cut_wc_11p5(i,j) = cov_wc(i, j)*cov_wc(idx_cut_1_11p5, idx_cut_2_11p5) + cov_wc(i, idx_cut_1_11p5)*...
            cov_wc(j,idx_cut_2_11p5)+cov_wc(i,idx_cut_2_11p5)*cov_wc(j,idx_cut_1_11p5);
    end
end

%Computing connected fourth-order correlation
C4_con_trans_5p8 = C4_trans_5p8 - C4_dis_cut_trans_5p8;
C4_con_woc_5p8 = C4_woc_5p8 - C4_dis_cut_woc_5p8;
C4_con_wc_5p8 = C4_wc_5p8 - C4_dis_cut_wc_5p8;

C4_con_trans_11p5 = C4_trans_11p5 - C4_dis_cut_trans_11p5;
C4_con_woc_11p5 = C4_woc_11p5 - C4_dis_cut_woc_11p5;
C4_con_wc_11p5 = C4_wc_11p5 - C4_dis_cut_wc_11p5;

%Plotting
%Plotting
%1. Disconnected C4
z_grid = linspace(-50,50,52);

f = tight_subplot(2,3, [0.08,0.1], [0.15, 0.1], [0.1, 0.1]);
axes(f(1))

imagesc(z_grid, z_grid, C4_dis_cut_trans_5p8);
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
xticks([])
yticks([-45,0,45])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(2))
imagesc(z_grid, z_grid, C4_dis_cut_woc_5p8)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([-0.2,0.6])
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(3))
imagesc(z_grid, z_grid, C4_dis_cut_wc_5p8)
%clim([-0.2,0.6])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
xticks([])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(4))
imagesc(z_grid, z_grid, C4_dis_cut_trans_11p5)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([0,4])
ylabel('$z_1\; (\rm \mu m)$', 'Interpreter','latex')
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
yticks([-45,0,45])
xticks([-45,0,45])

axes(f(5))
imagesc(z_grid, z_grid, C4_dis_cut_woc_11p5)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([0,2.5])
yticks([])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{e}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
xticks([-45,0,45])

axes(f(6))
imagesc(z_grid, z_grid, C4_dis_cut_wc_11p5)
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
%clim([0,2.5])
yticks([])
xlabel('$z_2\; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
xticks([-45,0,45])

colormap(gge_colormap)
set(f,'FontName', 'Times', 'FontSize', 16)