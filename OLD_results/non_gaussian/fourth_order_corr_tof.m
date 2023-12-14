%clear all
%close all
addpath('../classes')
addpath('../input')
close all

%load('fit_phase_OU_1_t30.mat')
%load('OU_profiles.mat')

load('fit_phase_SG_1_t7.mat')
fit_profiles_full_t7 = fit_profiles_full;
load('fit_phase_SG_1_t15p6.mat')
fit_profiles_full_t15 = fit_profiles_full;
load('fit_phase_SG_1_t30.mat')
fit_profiles_full_t30 = fit_profiles_full;
load('SG_profiles.mat')

%dim_in = 512;
num_shots = 1000;
dim_out = 40;
z_grid = linspace(-40,40,dim_out);
%input_corr = class_1d_correlation(phase_OU_1');
%input_corr = class_1d_correlation(phase_SG_1');
fit_corr_full_t7 = class_1d_correlation(fit_profiles_full_t7); 
fit_corr_full_t15 = class_1d_correlation(fit_profiles_full_t15);
fit_corr_full_t30 = class_1d_correlation(fit_profiles_full_t30); 

%correlation function
%G4_in = input_corr.correlation_func(4);
G4_full_t7 = fit_corr_full_t7.fourth_order_corr(3*dim_out/4, dim_out/4);
G4_full_t15 = fit_corr_full_t15.fourth_order_corr(3*dim_out/4, dim_out/4);
G4_full_t30 = fit_corr_full_t30.fourth_order_corr(3*dim_out/4, dim_out/4);

%wick calculation
%W4_in = input_corr.wick_four_point_correlation();
W4_full_t7 = fit_corr_full_t7.wick_four_point_correlation();
W4_full_t15 = fit_corr_full_t15.wick_four_point_correlation();
W4_full_t30 = fit_corr_full_t30.wick_four_point_correlation();

%Deviation from Wick
DevGW4_trans_t7 = G4_trans_t7 - W4_trans_t7(:,:,3*dim_out/4,dim_out/4);
DevGW4_trans_t15 = G4_trans_t15 - W4_trans_t15(:,:,3*dim_out/4,dim_out/4);
DevGW4_trans_t30 = G4_trans_t30 - W4_trans_t30(:,:,3*dim_out/4,dim_out/4);

DevGW4_full_t7 = G4_full_t7 - W4_full_t7(:,:,3*dim_out/4,dim_out/4);
DevGW4_full_t15 = G4_full_t15 - W4_full_t15(:,:,3*dim_out/4,dim_out/4);
DevGW4_full_t30 = G4_full_t30 - W4_full_t30(:,:,3*dim_out/4,dim_out/4);

save('fourth_order_corr_OU.mat', 'G4_trans_t7', 'G4_trans_t15', 'G4_trans_t30','G4_full_t7','G4_full_t15',...
'G4_full_t30','W4_trans_t7', 'W4_trans_t15', 'W4_trans_t30', 'W4_full_t7','W4_full_t15','W4_full_t30',...
'DevGW4_full_t7','DevGW4_full_t15','DevGW4_full_t30')

%Plotting the result
f(1) = subplot(2,3,1);
imagesc(z_grid, z_grid, G4_full_t7)
clim([0,8])
xticks([])
ylabel('$z\; (\mu m)$', 'Interpreter','latex')
title('$t_{ToF} = 7\; ms$','Interpreter','latex')
f(2) = subplot(2,3,2);
imagesc(z_grid, z_grid, G4_full_t15)
clim([0,8])
yticks([])
xticks([])
title('$t_{ToF} = 15.6\; ms$','Interpreter','latex')
f(3) = subplot(2,3,3);
imagesc(z_grid, z_grid, G4_full_t30)
clim([0,8])
xticks([])
yticks([])
title('$t_{ToF} = 30\; ms$','Interpreter','latex')
f(4) = subplot(2,3,4);
imagesc(z_grid, z_grid, G4_trans_t7)
clim([0,8])
xlabel('$z^\prime\; (\mu m)$', 'Interpreter', 'latex')
ylabel('$z\; (\mu m)$', 'Interpreter','latex')

f(5) = subplot(2,3,5);
imagesc(z_grid, z_grid, G4_trans_t15)
clim([0,8])
xlabel('$z^\prime \; (\mu m)$', 'Interpreter','latex')
yticks([])

f(6) = subplot(2,3,6);
imagesc(z_grid, z_grid, G4_trans_t30)
cb = colorbar(f(6),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0.05,0,0.4];
clim([0,8])
xlabel('$z^\prime \; (\mu m)$', 'Interpreter','latex')
yticks([])

set(f, 'FontName', 'Times', 'FontSize', 16)
colormap(gge_colormap)
sgtitle('$G^{(4)}(z, z^\prime, 20\; \mu m, -20 \; \mu m)$','Interpreter', 'latex')

figure
g(1) = subplot(2,3,1);
imagesc(z_grid, z_grid, DevGW4_full_t7)
clim([-1.5,0.1])
ylabel('$z\; (\mu m)$', 'Interpreter','latex')
title('$t_{ToF} = 7\; ms$','Interpreter','latex')
g(2) = subplot(2,3,2);
imagesc(z_grid, z_grid, DevGW4_full_t15)
clim([-1.5,0.1])
yticks([])
xticks([])
title('$t_{ToF} = 15.6\; ms$','Interpreter','latex')
g(3) = subplot(2,3,3);
imagesc(z_grid, z_grid, DevGW4_full_t30)
clim([-1.5,0.1])
yticks([])
xticks([])
title('$t_{ToF} = 30\; ms$','Interpreter','latex')
g(4) = subplot(2,3,4);
imagesc(z_grid, z_grid, DevGW4_trans_t7)
clim([-1.5,0.1])
xlabel('$z^\prime\; (\mu m)$', 'Interpreter', 'latex')
ylabel('$z\; (\mu m)$', 'Interpreter','latex')

g(5) = subplot(2,3,5);
imagesc(z_grid, z_grid, DevGW4_trans_t15)
clim([-1.5,0.1])
xlabel('$z^\prime \; (\mu m)$', 'Interpreter','latex')
yticks([])

g(6) = subplot(2,3,6);
imagesc(z_grid, z_grid, DevGW4_trans_t30)
clim([-1.5, 0.1])
cb = colorbar(g(6),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.08,0.05,0,0.4];
xlabel('$z^\prime \; (\mu m)$', 'Interpreter','latex')
yticks([])

set(g, 'FontName', 'Times', 'FontSize', 16)
colormap(gge_colormap)
sgtitle('$G^{(4)} - W^{(4)}$ Deviation from Wick', 'Interpreter', 'latex')