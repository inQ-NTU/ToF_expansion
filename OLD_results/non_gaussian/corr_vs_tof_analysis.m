clear all
close all
%load('corr_SG_1_all.mat')
%load('corr_SG_2_all.mat')
load('corr_SG_3_all.mat')
addpath('../input')
%tof
t = [7,15,30];

%Compute the M^(4) metric
M4_full_t7 = sum(abs(G4_full_t7 - W4_full_t7), 'all')/sum(abs(G4_full_t7),'all');
M4_full_t15 = sum(abs(G4_full_t15 - W4_full_t15), 'all')/sum(abs(G4_full_t15),'all');
M4_full_t30 = sum(abs(G4_full_t30 - W4_full_t30), 'all')/sum(abs(G4_full_t30),'all');

M4_trans_t7 = sum(abs(G4_trans_t7 - W4_trans_t7), 'all')/sum(abs(G4_trans_t7),'all');
M4_trans_t15 = sum(abs(G4_trans_t15 - W4_trans_t15), 'all')/sum(abs(G4_trans_t15),'all');
M4_trans_t30 = sum(abs(G4_trans_t30 - W4_trans_t30), 'all')/sum(abs(G4_trans_t30),'all');

M4_in = sum(abs(G4_in - W4_in), 'all')/sum(abs(G4_in),'all');

%save('corr_SG_1_all.mat', 'G4_full_t7', 'G4_full_t15', 'G4_full_t30', 'G4_trans_t7', 'G4_trans_t15', 'G4_trans_t30', 'W4_full_t7', 'W4_full_t15', 'W4_full_t30', 'W4_trans_t7', 'W4_trans_t15', 'W4_trans_t30', 'G4_in', 'W4_in')
%Plotting the result
figure
plot(t, [M4_full_t7, M4_full_t15, M4_full_t30], 'o-.','MarkerSize', 8,'LineWidth',1.2)
hold on
plot(t, [M4_trans_t7, M4_trans_t15, M4_trans_t30], 'x-.','MarkerSize', 8,'LineWidth',1.2)
yline(M4_in,'--','LineWidth',1.2)
set(gca,'FontName', 'Times', 'FontSize', 16)
%yticks([0.24,0.25,0.26,0.27,0.28])
ylabel('$M_4$', 'Interpreter','latex')
xlabel('$t_{ToF}\; (ms)$','Interpreter','latex')
legend({'3D Expansion', 'Transversal Expansion', 'Input'})
title('Sine-Gordon q = 3')
if 0
figure
f(1) = subplot(3,3,1);
imagesc(G4_full_t15(:,:,10,30))
clim([-2,20])
title('$G_4$ 3D', 'Interpreter', 'latex')
xticks([])

f(2) = subplot(3,3,2);
imagesc(G4_trans_t15(:,:,10,30))
clim([-2,20])
title('$G_4$ Transversal', 'Interpreter', 'latex')
xticks([])
yticks([])

f(3) = subplot(3,3,3);
imagesc(G4_in(:,:,10,30))
clim([-2,20])
cb = colorbar(f(3),'Location','EastOutside','TickLabelInterpreter','latex', 'YTick',-2:4:18);
cb.Position = cb.Position + [0.08,-0.05,0,0.005];
title('$G_4$ Input', 'Interpreter', 'latex')
xticks([])
yticks([])

f(4) = subplot(3,3,4);
imagesc(W4_full_t15(:,:,10,30))
title('$W_4$ 3D', 'Interpreter', 'latex')
xticks([])
clim([-2,20])

f(5) = subplot(3,3,5);
imagesc(W4_trans_t15(:,:,10,30))
title('$W_4$ Transversal', 'Interpreter', 'latex')
xticks([])
yticks([])
clim([-2,20])


f(6) = subplot(3,3,6);
imagesc(W4_in(:,:,10,30));
title('$W_4$ Input', 'Interpreter', 'latex')
xticks([])
yticks([])
clim([-2,20])
cb = colorbar(f(6),'Location','EastOutside','TickLabelInterpreter','latex', 'YTick', -2:4:18);
cb.Position = cb.Position + [0.08,-0.05,0,0.005];


f(7) = subplot(3,3,7);
imagesc(G4_full_t15(:,:,10,30) - W4_full_t15(:,:,10,30))
clim([-6,2])
title('$G_4^{c}$ 3D', 'Interpreter', 'latex')

f(8) = subplot(3,3,8);
imagesc(G4_trans_t15(:,:,10,30) - W4_trans_t15(:,:,10,30))
clim([-6,2])
title('$G_4^{c}$ Transversal', 'Interpreter', 'latex')
yticks([])


f(9) = subplot(3,3,9);
imagesc(G4_in(:,:,10,30) - W4_in(:,:,10,30))
clim([-6,2])
cb = colorbar(f(9),'Location','EastOutside','TickLabelInterpreter','latex', 'YTick',-6:2:2); 
cb.Position = cb.Position + [0.08,-0.05,0,0.005];
title('$G_4^{c}$ Input', 'Interpreter', 'latex')
yticks([])

colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 14)
sgtitle('15 ms ToF','FontSize', 18)
end