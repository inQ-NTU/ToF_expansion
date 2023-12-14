clear all
close all
addpath('../input')
addpath('../classes')

load('SG_profiles.mat')
load('fit_phase_SG_2_t7.mat')
fit_profiles_full_t7_woc = fit_profiles_full;
load('fit_phase_SG_2_t30.mat')
fit_profiles_full_t30_woc = fit_profiles_full; 
load('fit_phase_SG_2_t7_wc.mat')
fit_profiles_full_t7_wc = fit_profiles_full;
fit_profiles_trans_t7 = fit_profiles_trans;
load('fit_phase_SG_2_t30.mat')
fit_profiles_full_t30_wc = fit_profiles_full; 

condensate_length = 100;
dim_in = 512;
num_shots = 1000;
dim_out_1 = 80;
dim_out_2 = 100;
z_grid_in = linspace(-condensate_length/2, condensate_length/2, dim_in);
z_grid_out = linspace(-condensate_length/2, condensate_length/2, dim_out_2);

%reference phase profiles
for i = 1:num_shots
    phase_SG_2(:,i) = phase_SG_2(:,i) - phase_SG_2(dim_in/2,i);
    fit_profiles_full_t7_woc(i,:) = fit_profiles_full_t7_woc(i,:) - fit_profiles_full_t7_woc(i,dim_out_1/2);
    fit_profiles_full_t30_woc(i,:) = fit_profiles_full_t30_woc(i,:) - fit_profiles_full_t30_woc(i,dim_out_1/2);
    fit_profiles_full_t7_wc(i,:) = fit_profiles_full_t7_wc(i,:) - fit_profiles_full_t7_wc(i,dim_out_2/2);
    fit_profiles_full_t30_wc(i,:) = fit_profiles_full_t30_wc(i,:) - fit_profiles_full_t30_wc(i,dim_out_2/2);
    fit_profiles_trans_t7(i,:) = fit_profiles_trans_t7(i,:) - fit_profiles_trans_t7(i, dim_out_2/2);
end
input_corr = class_1d_correlation(phase_SG_2');
input_cov = input_corr.covariance_matrix();
trans_corr = class_1d_correlation(fit_profiles_trans_t7);
trans_cov = trans_corr.covariance_matrix();

corr_full_t7_woc = class_1d_correlation(fit_profiles_full_t7_woc);
corr_full_t30_woc = class_1d_correlation(fit_profiles_full_t30_woc);
corr_full_t7_wc = class_1d_correlation(fit_profiles_full_t7_woc);
corr_full_t30_wc = class_1d_correlation(fit_profiles_full_t30_woc);

full_cov_t7_woc  = corr_full_t7_woc.covariance_matrix();
imresize(full_cov_t7_woc, [dim_out_2 dim_out_2])
full_cov_t30_woc = corr_full_t30_woc.covariance_matrix();
imresize(full_cov_t30_woc, [dim_out_2 dim_out_2])
full_cov_t7_wc  = corr_full_t7_wc.covariance_matrix();
full_cov_t30_wc = corr_full_t30_wc.covariance_matrix();

%Plotting
figure
f(1) =subplot(2,3,1);
imagesc(z_grid_in, z_grid_in, input_cov)
xticks([])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;
clim([0,7])

f(2) = subplot(2,3,2);
imagesc(z_grid_out, z_grid_out, full_cov_t7_woc)
clim([0,7])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xticks([])

f(3) = subplot(2,3,3);
imagesc(z_grid_out, z_grid_out, full_cov_t30_woc)
clim([0,7])
cb1 = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex','YTick',[0,2,4,6]);
cb1.Position = cb1.Position + [0.09,-0.3,0,0.15];
yticks([])
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xticks([])

f(4) =subplot(2,3,4);
imagesc(z_grid_out, z_grid_out, trans_cov)
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.3,0.85]);
ylb = ylabel('$z \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1) - 0.05;
clim([0,7])
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')

f(5) = subplot(2,3,5);
imagesc(z_grid_out, z_grid_out, full_cov_t7_wc)
clim([0,7])
yticks([])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')

f(6) = subplot(2,3,6);
imagesc(z_grid_out, z_grid_out, full_cov_t30_wc)
clim([0,7])
yticks([])
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xlabel('$z^\prime \; (\rm \mu m)$', 'Interpreter','latex')

colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 14)