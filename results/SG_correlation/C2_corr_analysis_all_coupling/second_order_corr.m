clear all
close all
addpath('../../../classes')
addpath('../../../input')
load('SG_2_tof.mat')

condensate_length = 100; %microns
pixnumz = 200;
fine_z_grid = linspace(-condensate_length/2, condensate_length/2, pixnumz);
coarse_z_grid = linspace(-condensate_length/2, condensate_length/2, pixnumz);
%woc - without common phase
%referencing all profiles
for i = 1:1000
    cg_input_relative_phase(i,:) = cg_input_relative_phase(i,:) - cg_input_relative_phase(i, pixnumz/2);
    ext_rel_phase_woc_10ms(i,:) = ext_rel_phase_woc_10ms(i,:) - ext_rel_phase_woc_10ms(i, pixnumz/2);
    ext_rel_phase_woc_15ms(i,:) = ext_rel_phase_woc_15ms(i,:) - ext_rel_phase_woc_15ms(i,pixnumz/2);
    ext_rel_phase_woc_20ms(i,:) = ext_rel_phase_woc_20ms(i,:) - ext_rel_phase_woc_20ms(i,pixnumz/2);
    ext_rel_phase_wc_10ms(i,:) = ext_rel_phase_woc_10ms(i,:) - ext_rel_phase_woc_10ms(i, pixnumz/2);
    ext_rel_phase_wc_15ms(i,:) = ext_rel_phase_woc_15ms(i,:) - ext_rel_phase_woc_15ms(i,pixnumz/2);
    ext_rel_phase_wc_20ms(i,:) = ext_rel_phase_woc_20ms(i,:) - ext_rel_phase_woc_20ms(i,pixnumz/2);
end

corr_in = class_1d_correlation(cg_input_relative_phase(1:1000,:));
corr_woc_10ms = class_1d_correlation(ext_rel_phase_woc_10ms);
corr_woc_15ms = class_1d_correlation(ext_rel_phase_woc_15ms);
corr_woc_20ms = class_1d_correlation(ext_rel_phase_woc_20ms);

cov_in = corr_in.covariance_matrix();
cov_woc_10ms = corr_woc_10ms.covariance_matrix();
cov_woc_15ms = corr_woc_15ms.covariance_matrix();
cov_woc_20ms = corr_woc_20ms.covariance_matrix();

max_cov_woc_10ms = max(cov_woc_10ms, [], 'all');
max_cov_woc_15ms = max(cov_woc_15ms, [], 'all');
max_cov_woc_20ms = max(cov_woc_20ms, [], 'all');

abs_max_woc = max([max_cov_woc_10ms, max_cov_woc_15ms, max_cov_woc_20ms]);


%wc - with common phase
corr_wc_10ms = class_1d_correlation(ext_rel_phase_wc_10ms);
corr_wc_15ms = class_1d_correlation(ext_rel_phase_wc_15ms);
corr_wc_20ms = class_1d_correlation(ext_rel_phase_wc_20ms);

cov_wc_10ms = corr_wc_10ms.covariance_matrix();
cov_wc_15ms = corr_wc_15ms.covariance_matrix();
cov_wc_20ms = corr_wc_20ms.covariance_matrix();

max_cov_wc_10ms = max(cov_wc_10ms, [], 'all');
max_cov_wc_15ms = max(cov_wc_15ms, [], 'all');
max_cov_wc_20ms = max(cov_wc_20ms, [], 'all');

abs_max_wc = max([max_cov_wc_10ms, max_cov_wc_15ms, max_cov_wc_20ms]);

%plotting
figure
f = tight_subplot(1,4,[.1 .05],[.15 .1],[.1 .1]);
axes(f(1))
imagesc(fine_z_grid, fine_z_grid, cov_in)
clim([0, abs_max_woc])
title('$\rm Input$', 'Interpreter','latex')


axes(f(2))
imagesc(coarse_z_grid, coarse_z_grid, cov_woc_10ms)
clim([0, abs_max_woc])
title('$t = 10\; \rm ms$', 'Interpreter','latex')

axes(f(3))
imagesc(coarse_z_grid, coarse_z_grid, cov_woc_15ms)
clim([0, abs_max_woc])
yticks([])
title('$t = 15\; \rm ms$', 'Interpreter','latex')

axes(f(4))
imagesc(coarse_z_grid, coarse_z_grid, cov_woc_20ms)
clim([0, abs_max_woc])
cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];
yticks([])
title('$t = 20\; \rm ms$', 'Interpreter','latex')


colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 16)


figure
g = tight_subplot(1,4,[.1 .05],[.15 .1],[.1 .1]);

axes(g(1))
imagesc(fine_z_grid, fine_z_grid, cov_in)
clim([0, abs_max_woc])
title('$\rm Input$', 'Interpreter','latex')

axes(g(2))
imagesc(coarse_z_grid, coarse_z_grid, cov_wc_10ms)
clim([0, abs_max_woc])
title('$t = 10\; \rm ms$', 'Interpreter','latex')


axes(g(3))
imagesc(coarse_z_grid, coarse_z_grid, cov_wc_15ms)
clim([0, abs_max_woc])
yticks([])
title('$t = 15\; \rm ms$', 'Interpreter','latex')


axes(g(4))
imagesc(coarse_z_grid, coarse_z_grid, cov_wc_20ms)
clim([0, abs_max_woc])
yticks([])
title('$t = 20\; \rm ms$', 'Interpreter','latex')


cb = colorbar;
cb.Position = cb.Position + [0.08,0,0,0];

colormap(gge_colormap)
set(g, 'FontName', 'Times', 'FontSize', 16)


%save('cov_SG_2.mat', 'cov_woc_10ms', 'cov_woc_15ms', 'cov_woc_20ms',...
%    'cov_wc_10ms', 'cov_wc_15ms','cov_wc_20ms', 'cov_in')