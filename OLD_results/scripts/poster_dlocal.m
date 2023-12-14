clear all
addpath('../input')
load('dlocal_thermal_25nk.mat')
f(1) = subplot(1,3,1);
imagesc(linspace(0,80,80), linspace(0,80,80), in_cov)
title('$\langle \partial_z\varphi \partial_z^\prime\varphi\rangle_{in}, \; T = 25\; nK$', 'Interpreter','latex')
clim([-0.03,0.03])
xticks([0,40,80])
yticks([0,40,80])
f(2) = subplot(1,3,2);
imagesc(linspace(0,80,80), linspace(0,80,80), full2_cov)
clim([-0.03,0.03])
title('$\langle \partial_z\varphi \partial_z^\prime\varphi\rangle_{out}$, 7 ms ToF', 'Interpreter','latex')
yticks([])
xticks([0,40,80])

f(3) = subplot(1,3,3);
imagesc(linspace(0,80,80), linspace(0,80,80), full3_cov)
clim([-0.03,0.03])
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex'); 
cb.Position = cb.Position + [0.08,0,0,0.001];
%cb.Ruler.Exponent = -2;
title('$\langle \partial_z\varphi \partial_z^\prime\varphi\rangle_{out}$, 30 ms ToF', 'Interpreter','latex')
yticks([])
xticks([0,40,80])
colormap(hot)
%colormap(hot)
set(f, 'FontName', 'Times', 'FontSize', 16)