load('fit_data_15ms.mat')
ext_phase_woc_15ms = ext_phase_woc;
ext_phase_wc_15ms = ext_phase_wc;
residue_woc_15ms = residue_woc;
residue_wc_15ms = residue_wc;
fit_wc_15ms = fit_wc;
fit_woc_15ms = fit_woc;

load('fit_data_25ms.mat')
ext_phase_woc_25ms = ext_phase_woc;
ext_phase_wc_25ms = ext_phase_wc;
residue_woc_25ms = residue_woc;
residue_wc_25ms = residue_wc;
fit_wc_25ms = fit_wc;
fit_woc_25ms = fit_woc;

z_grid = linspace(-50,50,400);
%
% Plotting
f(1) = subplot(2,2,1);
plot(z_grid, rel_phase, 'Color','Black')
hold on
plot(coarse_grid, ext_phase_wc_15ms, 'o', 'Color', 'blue','MarkerSize',3)
plot(coarse_grid, ext_phase_wc_25ms, 'x','Color','red','MarkerSize',4)
plot(z_grid, com_phase, '--', 'Color', 'Black')

f(2) = subplot(2,2,2);
plot(coarse_grid, residue_wc_15ms, 'o','Color','blue','MarkerSize',3)
hold on
plot(coarse_grid, residue_wc_25ms, 'x', 'Color','red','MarkerSize',4)
plot(z_grid, fit_wc_15ms(z_grid), 'Color','blue')
plot(z_grid, fit_wc_25ms(z_grid),'Color','red')

f(3) = subplot(2,2,3);
plot(z_grid, rel_phase,'Color','Black')
hold on
plot(coarse_grid, ext_phase_woc_15ms, 'o','Color', 'blue','MarkerSize',3)
plot(coarse_grid, ext_phase_woc_25ms, 'x','Color', 'red','MarkerSize',4)
plot(z_grid, zeros(1,length(z_grid)), 'LineStyle','--', 'Color','Black')

f(3) = subplot(2,2,4);
plot(coarse_grid, residue_woc_15ms, 'o','Color','blue','MarkerSize',3)
hold on
plot(coarse_grid, residue_woc_25ms, 'x','Color','red','MarkerSize',4)
plot(z_grid, fit_woc_15ms(z_grid), 'Color','blue')
plot(z_grid, fit_woc_25ms(z_grid), 'Color','red')