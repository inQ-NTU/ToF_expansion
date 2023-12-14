%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
%load('thermal_cov_50nk.mat')
load('2000_phase_data_and_correlations.mat')

%compute second order correlation
correlation_suite_ori = class_1d_correlation(coarse_samples);
correlation_suite_ext = class_1d_correlation(extracted_phase_data);

G2_ori = correlation_suite_ori.correlation_func(2);
G2_ext = correlation_suite_ext.correlation_func(2);

%compute wick fourth correlation
w4_ori = wick_fourth(G2_ori);
w4_ext = wick_fourth(G2_ext);

%compute the difference between wick and empirical
res4_ori = abs(fourth_order_corr_data_ori - w4_ori);
res4_ext = abs(fourth_order_corr_data_ext - w4_ext);

%drawing the plot
f(1) = subplot(1,2,1);
imagesc(res4_ori(:,:,10, 10))
colorbar
clim([0,0.5])

f(2) = subplot(1,2,2);
imagesc(res4_ext(:,:,10, 10))
colorbar
clim([0,0.5])


colormap(gge_colormap)

