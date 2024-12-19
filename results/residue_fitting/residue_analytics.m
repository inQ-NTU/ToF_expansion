clear all
close all
addpath('../../input')
addpath('../../classes')

%Define condensate length, pixel width, and grid
condensate_length = 100e-6;
l= condensate_length*1e6;
pixel_width = 1e-6;
pixnumz = floor(condensate_length/pixel_width);
z_grid = linspace(-condensate_length/2,condensate_length/2, pixnumz).*1e6;

%Define a smooth relative and common phase profiles
n_rel = 4;
n_com = 6;
rel_phase = pi*cos(n_rel*pi*z_grid/(condensate_length.*1e6));
com_phase = pi*cos(n_com*pi*z_grid/(condensate_length.*1e6));
phase_1 = (com_phase - rel_phase)/2;
phase_2 = (com_phase + rel_phase)/2;

%Define mean density
rho_max = 75e6;
mean_density = rho_max*(1-(4/l^2).*z_grid.^2);

%TOF Simulation
%Set expansion times
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;

%Initializing interference pattern classes
interference_suite_wc_1 = class_interference_pattern_update([phase_1; phase_2], [mean_density; mean_density], t_tof_1);
interference_suite_wc_2 = class_interference_pattern_update([phase_1; phase_2], [mean_density; mean_density], t_tof_2);
interference_suite_woc_1 = class_interference_pattern_update([-rel_phase/2; rel_phase/2], [mean_density; mean_density], t_tof_1);
interference_suite_woc_2 = class_interference_pattern_update([-rel_phase/2; rel_phase/2], [mean_density; mean_density], t_tof_2);

%Simulating TOF
rho_tof_wc_1 = interference_suite_wc_1.tof_full_expansion();
rho_tof_wc_2 = interference_suite_wc_2.tof_full_expansion();
rho_tof_woc_1 = interference_suite_woc_1.tof_full_expansion();
rho_tof_woc_2 = interference_suite_woc_2.tof_full_expansion();

%Phase extraction process
phase_ext_suite_wc_1 = class_phase_extraction(rho_tof_wc_1, t_tof_1);
phase_ext_suite_wc_2 = class_phase_extraction(rho_tof_wc_2, t_tof_2);

phase_ext_suite_woc_1 = class_phase_extraction(rho_tof_woc_1, t_tof_1);
phase_ext_suite_woc_2 = class_phase_extraction(rho_tof_woc_2, t_tof_2);

ext_phase_wc_1 = phase_ext_suite_wc_1.fitting(phase_ext_suite_wc_1.init_phase_guess());
ext_phase_wc_2 = phase_ext_suite_wc_2.fitting(phase_ext_suite_wc_2.init_phase_guess());

ext_phase_woc_1 = phase_ext_suite_woc_1.fitting(phase_ext_suite_woc_1.init_phase_guess());
ext_phase_woc_2 = phase_ext_suite_woc_2.fitting(phase_ext_suite_woc_2.init_phase_guess());

%Calculating residues
residue_1_wc = rel_phase-ext_phase_wc_1;
residue_2_wc = rel_phase-ext_phase_wc_2;
residue_1_woc = rel_phase-ext_phase_woc_1;
residue_2_woc = rel_phase-ext_phase_woc_2;

%Some fundamental parameters
hbar = interference_suite_wc_1.hbar;
m = interference_suite_wc_1.m;

%Calculating expansion length scale
lt_1 = sqrt(hbar*t_tof_1/(2*m));
lt_2 = sqrt(hbar*t_tof_2/(2*m));

%Fitting residue
l= condensate_length*1e6;

%Calculating exact correction formula
deta2 = pixel_width/lt_2;
deta1 = pixel_width/lt_1;
correction_wc_1 = gradient(rel_phase, deta1).*gradient(com_phase, deta1);
correction_wc_2 = gradient(rel_phase, deta2).*gradient(com_phase, deta2);

correction_woc_1 = -0.5*gradient(rel_phase, deta1).^2.*(gradient(gradient(rel_phase, deta1), deta1));
correction_woc_2 = -0.5*((gradient(rel_phase, deta2)).^2).*(gradient(gradient(rel_phase, deta2), deta2));

%plotting
figure
f = tight_subplot(2,2,[.05 .1],[.15 .05],[.1 .1]);
axes(f(1))
plot(z_grid, rel_phase, 'Color','black')
hold on
plot(z_grid, ext_phase_wc_1, 'o','Color','Blue','MarkerSize',3)
plot(z_grid, ext_phase_wc_2, 'x','Color','red', 'MarkerSize', 4)
plot(z_grid, com_phase, '--', 'Color','Black')
ylim([-pi-0.7,pi+0.7])
yticks([-pi, -pi/2,0,pi/2,pi])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')
xticks([])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})

axes(f(2))
plot(z_grid, residue_1_wc, 'o', 'Color', 'Blue', 'MarkerSize', 3);
hold on
plot(z_grid, residue_2_wc, 'x','Color', 'Red', 'MarkerSize', 4);
plot(z_grid, correction_wc_1,'Color','Blue')
plot(z_grid, correction_wc_2, 'Color', 'red')
ylim([-1.5,1.5])
yticks([-1,0,1])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex')
xticks([])

axes(f(3))
plot(z_grid, rel_phase, 'Color','Black')
hold on
plot(z_grid, ext_phase_woc_1, 'o','Color','Blue','MarkerSize',3)
plot(z_grid, ext_phase_woc_2, 'x','Color','red','MarkerSize',4)
yline(0, '--', 'Color', 'Black')
ylim([-pi-0.7,pi+0.7])
yticks([-pi, -pi/2,0,pi/2,pi])
yticklabels({'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
ylabel('$\phi_{\mp}(z)$','Interpreter','latex')
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')

axes(f(4))
fine_grid = linspace(-l/2, l/2);
plot(z_grid, residue_1_woc, 'o', 'Color', 'Blue', 'MarkerSize', 3);
hold on
plot(z_grid, correction_woc_1,'Color','Blue')
plot(z_grid, residue_2_woc, 'x','Color', 'Red', 'MarkerSize', 4);
plot(z_grid, correction_woc_2, 'Color', 'red')
ylb = ylabel('$\Delta\phi_{-}(z)$','Interpreter','latex');
ylb.Position(1) = ylb.Position(1) + 8;
ylb.Position(2) = ylb.Position(2) - ;
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
yticks([-0.1,0,0.1])
ylim([-0.1,0.1])
xlabel('$z \; (\rm \mu m)$', 'Interpreter', 'latex')

set(f, 'FontName', 'Times', 'FontSize', 16)