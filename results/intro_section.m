close all
addpath('../input')
addpath('../classes')

load('EXAMPLE_phase_profile.mat')
t1 = 7e-3; %small tof
t2 = 15.6e-3; %medium tof
buffer_length = 5e-6; %buffer length for longitudinal expansion: 5 microns

interference_suite_RS_t1 = class_interference_pattern(phase_profile_RS, t1, buffer_length);
interference_suite_R_t1 = class_interference_pattern(phase_profile_RS(1,:),t1, buffer_length);
interference_suite_RS_t2 = class_interference_pattern(phase_profile_RS, t2, buffer_length);
interference_suite_R_t2 = class_interference_pattern(phase_profile_RS(1,:),t2, buffer_length);

%Generating tof data for t = 7 ms
rho_local_t1= interference_suite_R_t1.tof_transversal_expansion();
rho_refined_RS_t1=  interference_suite_RS_t1.tof_full_expansion();
rho_refined_R_t1 = interference_suite_R_t1.tof_full_expansion();

%normalizing the data
rho_local_t1 = rho_local_t1./max(rho_local_t1,[],'all');
rho_refined_RS_t1 = rho_refined_RS_t1./max(rho_refined_RS_t1,[],'all');
rho_refined_R_t1 = rho_refined_R_t1./max(rho_refined_R_t1,[], 'all');

%calculating the longitudinal expansion for t = 7 ms
nmb_buffer_pixel = interference_suite_R_t1.nmb_buffer_points_z;
expansion_buffer_t1 = rho_refined_RS_t1(1:nmb_buffer_pixel+1,:);

%generating tof data for t = 15.6 ms
rho_local_t2 = interference_suite_R_t2.tof_transversal_expansion();
rho_refined_RS_t2=  interference_suite_RS_t2.tof_full_expansion();
rho_refined_R_t2 = interference_suite_R_t2.tof_full_expansion();

%normalizing the data
rho_local_t2 = rho_local_t2./max(rho_local_t2,[],'all');
rho_refined_RS_t2 = rho_refined_RS_t2./max(rho_refined_RS_t2,[],'all');
rho_refined_R_t2 = rho_refined_R_t2./max(rho_refined_R_t2,[], 'all');

%calculating the longitudinal expansion for t = 15.6 ms
expansion_buffer_t2 = rho_refined_RS_t2(1:nmb_buffer_pixel+1,:);

%Plotting
%Setting up grid & parameters

fontsize = 16;
grid_z_input = interference_suite_RS_t1.input_grid_z*1e6;
grid_z = interference_suite_RS_t1.output_grid_z*1e6;
grid_x = interference_suite_RS_t1.output_grid_x*1e6;
buffer_grid_z = grid_z(1:nmb_buffer_pixel+1);
normalized_phase = phase_profile_RS./pi;

%%%%%%Figure 1%%%%%%%%%%%%%%%%%%%%%
img1 = figure;
f1 = tight_subplot(1,2,[0.1,0.075],[0.2, 0.2],[0.1, 0.1]);

axes(f1(1))
imagesc(grid_x, grid_z, rho_local_t1)
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
ylb = ylabel('$z \; (\mu m)$', 'Interpreter', 'LaTeX','FontSize',fontsize);
ylb.Position(1) = ylb.Position(1)-5;
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
yticks([-5,55,105])
clim([0,1])

g = axes('Position',[.38 .66 .06 .1] );
box on
plot(grid_z_input, normalized_phase(1,:),'LineWidth',1.5,'Color','red')
xlabel('$z \; (\mu m)$','Interpreter','latex')
ylb = ylabel('$\varphi_r(z)$','Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+50;
ylim([-1 1])
yticks([-1, 0, 1])
yticklabels({'$-\pi$','$0$', '$\pi$'})
set(gca, 'YColor','white')
set(gca,'XColor','white')

axes(f1(2));
imagesc(grid_x, grid_z, rho_local_t2)
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);
yticks([])
clim([0,1])
cb = colorbar(f1(2),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.1,0,0,0];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',16)
set(cb, 'YTick',[0,0.5,1])

colormap(gge_colormap)
set(f1, 'FontName','Times','FontSize',fontsize)
set(g, 'FontName','Times','FontSize',fontsize-8)

%%%%%%Figure 2%%%%%%%%%
img2 = figure;
f2 = tight_subplot(2,2,[0.1,0.075],[0.12, 0.12],[0.15, 0.15]);
%fig2 = tiledlayout(2,2);
axes(f2(1));
imagesc(grid_x, grid_z, rho_refined_RS_t1);
ylabel('$z \; (\mu m)$', 'Interpreter', 'LaTeX','FontSize',fontsize)
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([-5,55,105])
xticks([])
clim([0,1])

g = axes('Position',[.38 .77 .06 .08] );
box on
plot(grid_z_input, normalized_phase(2,:),'LineWidth',1.1,'Color','black','LineStyle','--')
hold on
plot(grid_z_input, normalized_phase(1,:),'LineWidth',1.1,'Color','red')
xlabel('$z \; (\mu m)$','Interpreter','latex')
ylb = ylabel('$\varphi_{r,c}(z)$','Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+20;
ylim([-1 1])
yticks([-1, 0, 1])
yticklabels({'$-\pi$','$0$', '$\pi$'})
set(gca, 'YColor','white')
set(gca,'XColor','white')

axes(f2(2));
imagesc(grid_x, grid_z, rho_refined_RS_t2);
xticks([])
yticks([])
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[-0.1,0.85]);
clim([0,1])
cb = colorbar(f2(2),'Location','EastOutside','TickLabelInterpreter','latex', 'Ticks',[0,0.5,1]);
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',fontsize+5)
cb.Position = cb.Position + [0.1,0,0,0];
colormap(gge_colormap)
set(cb, 'YTick',[0,0.5,1])

axes(f2(3))
imagesc(grid_x, buffer_grid_z, expansion_buffer_t1);
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
ylabel('$z \; (\mu m)$', 'Interpreter', 'LaTeX','FontSize',fontsize)
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([-5,-2.5,0])
clim([0,0.025])

axes(f2(4))
imagesc(grid_x, buffer_grid_z, expansion_buffer_t2);
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
title('(d)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);
yticks([])
clim([0,0.025])
cb = colorbar(f2(4),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.1,0,0,0];
cb.Ruler.Exponent = -2;

set(f2, 'FontName','Times','FontSize',fontsize)
set(g, 'FontName','Times','FontSize',fontsize-8)
if 0
%%%%%%%Figure 3%%%%%%%%%%%%%%
img3 = figure;
f3 = tight_subplot(1,2,[0.1,0.075],[0.2, 0.2],[0.1, 0.1]);
axes(f3(1))
imagesc(grid_x, grid_z, rho_refined_RS_t1)
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
ylb = ylabel('$z \; (\mu m)$', 'Interpreter', 'LaTeX','FontSize',fontsize);
ylb.Position(1) = ylb.Position(1)-5;
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
yticks([-5,55,105])
clim([0,1])

axes('Position',[.38 .6 .06 .15] );
box on
plot(grid_z_input, normalized_phase(2,:),'LineWidth',1.5,'Color','black')
xlabel('$z \; (\mu m)$','Interpreter','latex')
ylb = ylabel('$\varphi_c(z)$','Interpreter','latex');
ylb.Position(1) = ylb.Position(1)+10;
ylim([-1 1])
yticks([-1, 0, 1])
yticklabels({'$-\pi$','$0$', '$\pi$'})
set(gca, 'YColor','white')
set(gca,'XColor','white')

axes(f3(2));
imagesc(grid_x, grid_z, rho_refined_RS_t2)
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.1,0.85]);
yticks([])
clim([0,1])
cb = colorbar(f3(2),'Location','EastOutside','TickLabelInterpreter','latex');
cb.Position = cb.Position + [0.1,0,0,0];
set(get(cb,'Title'),'Interpreter','latex')
set(get(cb,'Title'),'String','$\rho_{ToF}$')
set(get(cb,'Title'),'FontSize',fontsize+5)
set(cb, 'YTick',[0,0.5,1])

colormap(gge_colormap)
set(f3, 'FontName','Times','FontSize',fontsize)
end