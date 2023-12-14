clear all
close all
load('SG_profiles_batch2.mat')
addpath('../../classes')
addpath('../../input')

phase_SG_1 = phase_SG_3';
for i = 1:2500
    phase_SG_1(i,:) = phase_SG_1(i,:) - phase_SG_1(i,500);
end

corr = class_1d_correlation(phase_SG_1);
fourth = corr.fourth_order_corr(250,750, phase_SG_1);
imagesc(fourth)
colorbar
colormap(gge_colormap)