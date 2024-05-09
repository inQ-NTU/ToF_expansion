addpath('../../input')

close all
z_grid = linspace(-50,50,200);

% Open the HDF5 file
fid = H5F.open('TOF_correlations_all.h5');

% Open the group '/out__woc_20ms_SG_3_tof.mat'
gid_20ms_SG_3 = H5G.open(fid, '/out__woc_20ms_SG_3_tof.mat');
gid_20ms_SG_05 = H5G.open(fid, '/out__woc_20ms_SG_05_tof.mat');

% Open the dataset q = 3
C4_con_in_SG_3 = H5D.open(gid_20ms_SG_3, 'C4_con_in');
C4_con_out_SG_3= H5D.open(gid_20ms_SG_3, 'C4_con_out');
C4_con_corrected_SG_3 = H5D.open(gid_20ms_SG_3, 'C4_con_corrected');

C4_con_in_SG_3 = H5D.read(C4_con_in_SG_3);
C4_con_out_SG_3 = H5D.read(C4_con_out_SG_3); 
C4_con_corrected_SG_3 = H5D.read(C4_con_corrected_SG_3);


C4_dis_in_SG_3 = H5D.open(gid_20ms_SG_3, 'C4_dis_in');
C4_dis_out_SG_3= H5D.open(gid_20ms_SG_3, 'C4_dis_out');
C4_dis_corrected_SG_3 = H5D.open(gid_20ms_SG_3, 'C4_dis_corrected');

C4_dis_in_SG_3 = H5D.read(C4_dis_in_SG_3);
C4_dis_out_SG_3 = H5D.read(C4_dis_out_SG_3); 
C4_dis_corrected_SG_3 = H5D.read(C4_dis_corrected_SG_3);

C4_full_in_SG_3 = H5D.open(gid_20ms_SG_3, 'C4_full_in');
C4_full_out_SG_3= H5D.open(gid_20ms_SG_3, 'C4_full_out');
C4_full_corrected_SG_3 = H5D.open(gid_20ms_SG_3, 'C4_full_corrected');

C4_full_in_SG_3 = H5D.read(C4_full_in_SG_3);
C4_full_out_SG_3 = H5D.read(C4_full_out_SG_3); 
C4_full_corrected_SG_3 = H5D.read(C4_full_corrected_SG_3);

%Open the dataset q = 0.5
C4_con_in_SG_05 = H5D.open(gid_20ms_SG_05, 'C4_con_in');
C4_con_out_SG_05= H5D.open(gid_20ms_SG_05, 'C4_con_out');
C4_con_corrected_SG_05 = H5D.open(gid_20ms_SG_05, 'C4_con_corrected');

C4_con_in_SG_05 = H5D.read(C4_con_in_SG_05);
C4_con_out_SG_05 = H5D.read(C4_con_out_SG_05); 
C4_con_corrected_SG_05 = H5D.read(C4_con_corrected_SG_05);


C4_dis_in_SG_05 = H5D.open(gid_20ms_SG_05, 'C4_dis_in');
C4_dis_out_SG_05= H5D.open(gid_20ms_SG_05, 'C4_dis_out');
C4_dis_corrected_SG_05 = H5D.open(gid_20ms_SG_05, 'C4_dis_corrected');

C4_dis_in_SG_05 = H5D.read(C4_dis_in_SG_05);
C4_dis_out_SG_05 = H5D.read(C4_dis_out_SG_05); 
C4_dis_corrected_SG_05 = H5D.read(C4_dis_corrected_SG_05);

C4_full_in_SG_05 = H5D.open(gid_20ms_SG_05, 'C4_full_in');
C4_full_out_SG_05= H5D.open(gid_20ms_SG_05, 'C4_full_out');
C4_full_corrected_SG_05 = H5D.open(gid_20ms_SG_05, 'C4_full_corrected');

C4_full_in_SG_05 = H5D.read(C4_full_in_SG_05);
C4_full_out_SG_05 = H5D.read(C4_full_out_SG_05); 
C4_full_corrected_SG_05 = H5D.read(C4_full_corrected_SG_05);

%Plotting the q = 0.5 plots
f = tight_subplot(3,4,[.08 .04],[.15 .05],[.12 .04]);
axes(f(1))
imagesc(z_grid, z_grid, C4_full_in_SG_05)
clim([0,30])
cb = colorbar(f(1),'Location','WestOutside','TickLabelInterpreter','latex','XTick',[0,10,20,30]);
cb.Position = cb.Position + [-0.12,0,0,0];
xticks([])
ylb = ylabel('$z_1 \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(2))
clim([0,30])
imagesc(z_grid, z_grid, C4_full_out_SG_05)
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(f(3))
imagesc(z_grid, z_grid, C4_full_corrected_SG_05)
clim([0,30])
xticks([])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(4))
plot(z_grid, C4_full_corrected_SG_05(120,:))
hold on
plot(z_grid, C4_full_out_SG_05(120,:))
plot(z_grid, C4_full_in_SG_05(120,:))
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(f(5))
clim([0,30])
imagesc(z_grid, z_grid, C4_dis_in_SG_05)
cb = colorbar(f(5),'Location','WestOutside','TickLabelInterpreter','latex','XTick',[0,10,20,30]);
cb.Position = cb.Position + [-0.12,0,0,0];
xticks([])
ylb = ylabel('$z_1 \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
title('$\mathbf{e}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(f(6))
clim([0,30])
imagesc(z_grid, z_grid, C4_dis_out_SG_05)
xticks([])
yticks([])
title('$\mathbf{f}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(7))
imagesc(z_grid, z_grid, C4_dis_corrected_SG_05)
xticks([])
yticks([])
title('$\mathbf{g}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(8))
plot(z_grid, C4_dis_corrected_SG_05(120,:))
hold on
plot(z_grid, C4_dis_out_SG_05(120,:))
plot(z_grid, C4_dis_in_SG_05(120,:))
title('$\mathbf{h}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(f(9))
imagesc(z_grid, z_grid, C4_con_in_SG_05)
clim([-2,10])
cb = colorbar(f(9),'Location','WestOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [-0.12,0,0,0];
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
ylb = ylabel('$z_1 \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
title('$\mathbf{i}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(f(10))
imagesc(z_grid, z_grid, C4_con_out_SG_05)
clim([-2,10])
yticks([])
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{j}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(f(11))
imagesc(z_grid, z_grid, C4_con_corrected_SG_05)
clim([-2,10])
yticks([])
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{k}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(f(12))
plot(z_grid, C4_con_corrected_SG_05(120,:))
hold on
plot(z_grid, C4_con_out_SG_05(120,:))
plot(z_grid, C4_con_in_SG_05(120,:))
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
yticks([0,2,4])
title('$\mathbf{l}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


colormap(gge_colormap)


set(f, 'FontName', 'Times', 'FontSize', 15)


%Plotting the q = 3 plots
figure
g = tight_subplot(3,4,[.08 .04],[.15 .05],[.12 .04]);
axes(g(1))
imagesc(z_grid, z_grid, C4_full_in_SG_3)
clim([-2,7])
cb = colorbar(g(1),'Location','WestOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [-0.12,0,0,0];
xticks([])
ylb = ylabel('$z_1 \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(g(2))
imagesc(z_grid, z_grid, C4_full_out_SG_3)
clim([-2,7])
yticks([])
xticks([])
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(g(3))
imagesc(z_grid, z_grid, C4_full_corrected_SG_3)
clim([-2,7])
yticks([])
xticks([])
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(g(4))
plot(z_grid, C4_full_corrected_SG_3(120,:))
hold on
plot(z_grid, C4_full_out_SG_3(120,:))
plot(z_grid, C4_full_in_SG_3(120,:))
yticks([-2,2,6])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(g(5))
imagesc(z_grid, z_grid, C4_dis_in_SG_3)
clim([-2,6])
cb = colorbar(g(5),'Location','WestOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [-0.12,0,0,0];
ylb = ylabel('$z_1 \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
xticks([])
title('$\mathbf{e}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(g(6))
imagesc(z_grid, z_grid, C4_dis_out_SG_3)
clim([-2,6])
xticks([])
yticks([])
title('$\mathbf{f}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(g(7))
imagesc(z_grid, z_grid, C4_dis_corrected_SG_3)
clim([-2,6])
xticks([])
yticks([])
title('$\mathbf{g}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(g(8))
plot(z_grid, C4_dis_corrected_SG_3(120,:))
hold on
plot(z_grid, C4_dis_out_SG_3(120,:))
plot(z_grid, C4_dis_in_SG_3(120,:))
title('$\mathbf{h}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(g(9))
imagesc(z_grid, z_grid, C4_con_in_SG_3)
clim([-4,4])
cb = colorbar(g(9),'Location','WestOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [-0.12,0,0,0];
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
ylb = ylabel('$z_1 \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
title('$\mathbf{i}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(g(10))
imagesc(z_grid, z_grid, C4_con_out_SG_3)
clim([-4,4])
yticks([])
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{j}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(g(11))
imagesc(z_grid, z_grid, C4_con_corrected_SG_3)
clim([-4,4])
yticks([])
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{k}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(g(12))
plot(z_grid, C4_con_corrected_SG_3(120,:))
hold on
plot(z_grid, C4_con_out_SG_3(120,:))
plot(z_grid, C4_con_in_SG_3(120,:))
colormap(gge_colormap)
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
yticks([-2,0,2])
title('$\mathbf{l}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


set(g, 'FontName', 'Times', 'FontSize', 15)

