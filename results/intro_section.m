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
expansion_buffer_t1 = rho_refined_R_t1(1:nmb_buffer_pixel+1,:);

%generating tof data for t = 15.6 ms
rho_local_t2 = interference_suite_R_t2.tof_transversal_expansion();
rho_refined_RS_t2=  interference_suite_RS_t2.tof_full_expansion();
rho_refined_R_t2 = interference_suite_R_t2.tof_full_expansion();

%normalizing the data
rho_local_t2 = rho_local_t2./max(rho_local_t2,[],'all');
rho_refined_RS_t2 = rho_refined_RS_t2./max(rho_refined_RS_t2,[],'all');
rho_refined_R_t2 = rho_refined_R_t2./max(rho_refined_R_t2,[], 'all');

%calculating the longitudinal expansion for t = 15.6 ms
expansion_buffer_t2 = rho_refined_R_t2(1:nmb_buffer_pixel+1,:);

%Plotting
%Setting up grid & parameters

fontsize = 20;
grid_z_input = interference_suite_RS_t1.input_grid_z*1e6;
grid_z = interference_suite_RS_t1.output_grid_z*1e6;
grid_x = interference_suite_RS_t1.output_grid_x*1e6;
buffer_grid_z = grid_z(1:nmb_buffer_pixel+1);

%%%%%%Figure 1%%%%%%%%%%%%%%%%%%%%%
figure
normalized_phase = phase_profile_RS./pi;

f1(1) = subplot(1,3,1);
plot(grid_z_input, normalized_phase(1,:),'LineWidth',1.5,'Color','red')
xlabel('$z \; (\mu m)$','Interpreter','latex','FontSize',fontsize)
ylabel('$\varphi_r(z)$','Interpreter','latex','FontSize',fontsize)
ylim([-1 1])
yticks([-1, 0, 1])
yticklabels({'-\pi','0', '\pi'})
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

f1(2) = subplot(1,3,2);
imagesc(grid_x, grid_z, rho_local_t1)
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
ylabel('$z \; (\mu m)$', 'Interpreter', 'LaTeX','FontSize',fontsize)
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([-5,55,105])
clim([0,1])

f1(3) = subplot(1,3,3);
imagesc(grid_x, grid_z, rho_local_t2)
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([])
clim([0,1])
cb = colorbar(f1(3),'Location','EastOutside','TickLabelInterpreter','latex');
set(get(cb,'label'),'string',sprintf('%s', '$\rho_{ToF}$'),'Interpreter','latex','FontSize',22);
set(cb, 'YTick',[0,0.5,1])

colormap(gge_colormap)

set(f1, 'FontName','Times','FontSize',fontsize)


%%%%%%Figure 2%%%%%%%%%
figure
pbaspect([1 1 1])
%fig2 = tiledlayout(2,2);
f2(1) = subplot(2,2,1);
imagesc(grid_x, grid_z, rho_refined_R_t1);
ylabel('$z \; (\mu m)$', 'Interpreter', 'LaTeX','FontSize',fontsize)
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([-5,55,105])
xticks([])
clim([0,1])


f2(2) = subplot(2,2,2);
imagesc(grid_x, grid_z, rho_refined_R_t2);
xticks([])
yticks([])
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex', 'Position',[-0.2,0.85]);
clim([0,1])
cb = colorbar(f2(2),'Location','EastOutside','TickLabelInterpreter','latex', 'Ticks',[0,0.5,1]);
colormap(gge_colormap)
set(get(cb,'label'),'string',sprintf('%s', '$\rho_{ToF}$'),'Interpreter','latex','FontSize',22);
set(cb, 'YTick',[0,0.5,1])

f2(3) = subplot(2,2,3);
imagesc(grid_x, buffer_grid_z, expansion_buffer_t1);
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
ylabel('$z \; (\mu m)$', 'Interpreter', 'LaTeX','FontSize',fontsize)
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([-5,-2.5,0])
clim([0,0.025])


f2(4) = subplot(2,2,4);
imagesc(grid_x, buffer_grid_z, expansion_buffer_t2);
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
title('(d)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([])
clim([0,0.025])
c = colorbar(f2(4),'Location','EastOutside','TickLabelInterpreter','latex');
set(get(c,'label'),'string',sprintf('%s', '$\rho_{ToF}$'),'Interpreter','latex','FontSize',22);
c.Ruler.Exponent = -2;

set(f2, 'FontName','Times','FontSize',fontsize)

%%%%%%%Figure 3%%%%%%%%%%%%%%
figure
%fig3 = tiledlayout(1,3);
set(groot,'defaultAxesTickLabelInterpreter','latex')

%f3(1) = nexttile(1);
f3(1) = subplot(1,3,1);
plot(grid_z_input, normalized_phase(2,:),'LineWidth',1.5,'Color','black')
xlabel('$z \; (\mu m)$','Interpreter','latex','FontSize',fontsize)
ylabel('$\varphi_c(z)$','Interpreter','latex','FontSize',fontsize)
ylim([-1 1])
yticks([-1, 0, 1])
yticklabels({'$-\pi$','$0$', '$\pi$'})
title('(a)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);

%f3(2) = nexttile(2);
f3(2) = subplot(1,3,2);
imagesc(grid_x, grid_z, rho_refined_RS_t1)
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
ylabel('$z \; (\mu m)$', 'Interpreter', 'LaTeX','FontSize',fontsize)
title('(b)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([-5,55,105])
clim([0,1])

%f3(3) = nexttile(3);
f3(3) = subplot(1,3,3);
imagesc(grid_x, grid_z, rho_refined_RS_t2)
xlabel('$x \; (\mu m)$','Interpreter', 'LaTeX','FontSize',fontsize)
title('(c)','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.2,0.85]);
yticks([])
clim([0,1])
cb = colorbar(f3(3),'TickLabelInterpreter','latex');
colormap(gge_colormap)
set(get(cb,'label'),'string',sprintf('%s', '$\rho_{ToF}$'),'Interpreter','latex','FontSize',22);
set(cb, 'YTick',[0,0.5,1])

set(f3, 'FontName','Times','FontSize',fontsize)

%Saving figure
%set(gcf,'Units','inches');
%screenposition = get(gcf,'Position');
%set(gcf,...
%    'PaperPosition',[0 0 screenposition(3:4)],...
%    'PaperSize',[screenposition(3:4)]);
%print -dpdf -painters fig1
