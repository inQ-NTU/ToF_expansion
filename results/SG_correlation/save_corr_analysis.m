z_grid = linspace(-50,50,200);

% Open the HDF5 file
fid = H5F.open('TOF_correlations.h5');

% Open the group '/out__woc_20ms_SG_3_tof.mat'
gid_20ms_SG_3 = H5G.open(fid, '/out__woc_20ms_SG_3_tof.mat');
gid_20ms_SG_05 = H5G.open(fid, '/out__woc_20ms_SG_05_tof.mat');

% Open the dataset 'g1_corrected'
g1_in_SG_3 = H5D.open(gid_20ms_SG_3, 'g1_in');
g1_out_20ms_SG_3 = H5D.open(gid_20ms_SG_3, 'g1_out');
g1_corrected_20ms_SG_3 = H5D.open(gid_20ms_SG_3, 'g1_corrected');

g1_in_SG_05 = H5D.open(gid_20ms_SG_05, 'g1_in');
g1_out_20ms_SG_05 = H5D.open(gid_20ms_SG_05, 'g1_out');
g1_corrected_20ms_SG_05 = H5D.open(gid_20ms_SG_05, 'g1_corrected');

% Read the data from the dataset
g1_in_SG_3 = H5D.read(g1_in_SG_3);
g1_out_20ms_SG_3  = H5D.read(g1_out_20ms_SG_3);
g1_corrected_20ms_SG_3 = H5D.read(g1_corrected_20ms_SG_3);

g1_in_SG_05 = H5D.read(g1_in_SG_05);
g1_out_20ms_SG_05  = H5D.read(g1_out_20ms_SG_05);
g1_corrected_20ms_SG_05 = H5D.read(g1_corrected_20ms_SG_05);

f = tight_subplot(2,4,[.08 .04],[.15 .05],[.12 .04]);
axes(f(1))
imagesc(z_grid, z_grid, g1_in_SG_05)
clim([0,20])
%clim([-0.02,0.02])
xticks([])
ylb = ylabel('$z_1 \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
title('$\mathbf{a}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
cb = colorbar(f(1),'Location','WestOutside','TickLabelInterpreter','latex','XTick',[0,10,20]);
cb.Position = cb.Position + [-0.12,0,0,0];


axes(f(2))
imagesc(z_grid, z_grid, g1_out_20ms_SG_05)
clim([0,20])
%clim([-0.02,0.02])
yticks([])
xticks([])
%xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{b}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(3))
imagesc(z_grid, z_grid, g1_corrected_20ms_SG_05)
clim([0,20])
%clim([-0.02,0.02])
colormap(gge_colormap)
yticks([])
xticks([])
%xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(4))
plot(z_grid, g1_corrected_20ms_SG_05(120,:))
hold on
plot(z_grid, g1_out_20ms_SG_05(120,:))
plot(z_grid, g1_in_SG_05(120,:))
xticks([])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);


axes(f(5))
imagesc(z_grid, z_grid, g1_in_SG_3)
clim([0,8])
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{d}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
ylb = ylabel('$z_1 \; (\rm \mu m)$', 'Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
title('$\mathbf{e}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
cb = colorbar(f(5),'Location','WestOutside','TickLabelInterpreter','latex', 'XTick', [0,4,8]);
cb.Position = cb.Position + [-0.12,0,0,0];


axes(f(6))
imagesc(z_grid, z_grid, g1_out_20ms_SG_3)
clim([0,8])
%clim([-0.02,0.02])
yticks([])
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{f}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(7))
imagesc(z_grid, z_grid, g1_corrected_20ms_SG_3)
clim([0,8])
%clim([-0.02,0.02])
yticks([])
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')
title('$\mathbf{g}$','FontName','Times','Color','white','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);

axes(f(8))
plot(z_grid, g1_corrected_20ms_SG_3(120,:))
hold on
plot(z_grid, g1_out_20ms_SG_3(120,:))
plot(z_grid, g1_in_SG_3(120,:))
title('$\mathbf{h}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.9,0.8]);
xlabel('$z_2 \; (\rm \mu m)$', 'Interpreter','latex')

set(f, 'FontName', 'Times', 'FontSize', 15)

% Close the dataset, group, and file
%H5D.close(did);
%H5G.close(gid);
%H5F.close(fid);