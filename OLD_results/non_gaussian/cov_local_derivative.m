addpath('../input')
addpath('../classes')
%load('OU_profiles.mat')
%load('fit_phase_OU_1_t7.mat')
%load('fit_phase_OU_1_t15p6.mat')
%load('fit_phase_OU_1_t30.mat')
%load('SG_profiles.mat')
%load('fit_phase_SG_1_t15p6.mat')

dim_in = 512;
num_shots = 1000;
dim_out = 80;

%compute local derivative
dlocal_trans_t7 = zeros(num_shots, dim_out-1);
dlocal_trans_t15 = zeros(num_shots, dim_out-1);
dlocal_trans_t30 = zeros(num_shots, dim_out-1);

dlocal_full_t7 = zeros(num_shots, dim_out-1);
dlocal_full_t15 = zeros(num_shots, dim_out-1);
dlocal_full_t30 = zeros(num_shots, dim_out-1);


for i = 1:num_shots
    for j = 1:dim_out-1
        dlocal_trans_t7(i,j) = fit_profiles_trans_t7(i, j+1) - fit_profiles_trans_t7(i,j);
        dlocal_trans_t15(i,j) = fit_profiles_trans_t15(i, j+1) - fit_profiles_trans_t15(i,j);
        dlocal_trans_t30(i,j) = fit_profiles_trans_t30(i, j+1) - fit_profiles_trans_t30(i,j);

        dlocal_full_t7(i,j) = fit_profiles_full_t7(i, j+1) - fit_profiles_full_t7(i,j);
        dlocal_full_t15(i,j) = fit_profiles_full_t15(i, j+1) - fit_profiles_full_t15(i,j);
        dlocal_full_t30(i,j) = fit_profiles_full_t30(i, j+1) - fit_profiles_full_t30(i,j);
    end
end
%input_corr = class_1d_correlation(dlocal_in);
%input_cov = input_corr.covariance_matrix;


fit_corr_full_t7 = class_1d_correlation(dlocal_full_t7); 
fit_corr_full_t15 = class_1d_correlation(dlocal_full_t15);
fit_corr_full_t30 = class_1d_correlation(dlocal_full_t30);

fit_corr_trans_t7 = class_1d_correlation(dlocal_trans_t7);
fit_corr_trans_t15 = class_1d_correlation(dlocal_trans_t15);
fit_corr_trans_t30 = class_1d_correlation(dlocal_trans_t30);

full_cov_t7 = fit_corr_full_t7.covariance_matrix;
full_cov_t15 = fit_corr_full_t15.covariance_matrix;
full_cov_t30 = fit_corr_full_t30.covariance_matrix;

trans_cov_t7 = fit_corr_trans_t7.covariance_matrix;
trans_cov_t15 = fit_corr_trans_t15.covariance_matrix;
trans_cov_t30 = fit_corr_trans_t30.covariance_matrix;
%Plotting

%determine upper clim
%max_clim = max([max(input_cov), max(trans_cov), max(full_cov)]);
%z_grid
z_grid = linspace(-40,40, dim_in-1);
coarse_z_grid = linspace(min(z_grid), max(z_grid), dim_out-1);
figure

f(1) = subplot(2,3,1);
imagesc(coarse_z_grid, coarse_z_grid, full_cov_t7)
yticks([-40,-20,0, 20,40]);
yticklabels([-40,-20,0,20,40]);
xticks([])
ylabel('$z\; (\mu m)$', 'Interpreter', 'latex')
clim([-0.05,0.05])
title('$t_{ToF} = 7\;  ms$', 'Interpreter', 'latex')

f(2) = subplot(2,3,2);
imagesc(coarse_z_grid, coarse_z_grid, full_cov_t15)
clim([-0.05,0.05])
xticks([])
yticks([])
title('$t_{ToF} = 15.6\;  ms$', 'Interpreter', 'latex')

f(3) = subplot(2,3,3);
imagesc(coarse_z_grid, coarse_z_grid, full_cov_t30)
clim([-0.05,0.05])
xticks([])
yticks([])
title('$t_{ToF} = 30\;  ms$', 'Interpreter', 'latex')


f(4) = subplot(2,3,4);
imagesc(coarse_z_grid, coarse_z_grid, trans_cov_t7)
yticks([-40,-20,0, 20,40]);
yticklabels([-40,-20,0,20,40]);
xticks([-40,-20,0, 20,40]);
xticklabels([-40,-20,0,20,40]);
ylabel('$z\; (\mu m)$', 'Interpreter', 'latex')
xlabel('$z^\prime\; (\mu m)$', 'Interpreter','latex')
clim([-0.05,0.05])

f(5) = subplot(2,3,5);
imagesc(coarse_z_grid, coarse_z_grid, trans_cov_t15)
xticks([-40,-20,0, 20,40])
xticklabels([-40,-20,0,20,40])
xlabel('$z^\prime\; (\mu m)$', 'Interpreter','latex')
yticks([])
clim([-0.05,0.05])

f(6) = subplot(2,3,6);
imagesc(coarse_z_grid, coarse_z_grid, trans_cov_t30)
cb = colorbar(f(6),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0.08,0,0.4];
cb.Ruler.Exponent = -2;
xticks([-40,-20,0, 20,40]);
xticklabels([-40,-20,0,20,40]);
yticks([])
xlabel('$z^\prime\; (\mu m)$', 'Interpreter','latex')
clim([-0.05,0.05])

colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 16)