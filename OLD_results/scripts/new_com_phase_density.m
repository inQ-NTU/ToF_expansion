clear all
close all

addpath('../input')

load('density_common_phase_cov.mat')
input_corr = corr_t7;
grid = linspace(-40,40, size(input_corr,1));

imagesc(grid, grid, input_corr)
ylabel('$z\; (\mu m)$','Interpreter','latex')
xlabel('$z^\prime\; (\mu m)$','Interpreter','latex')
title('$\langle \partial_z\varphi_{+}(z)\Delta A(z^\prime)\rangle$','Interpreter','latex')
colorbar
colormap(gge_colormap)
set(gca, 'FontName','Times', 'FontSize',16)