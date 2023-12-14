clear all
close all
addpath('../classes')
addpath('../input')

load('fit_phase_SG_3_t30.mat')
%load('fit_phase_SG_2_t15.mat')
%load('fit_phase_SG_2_t30.mat')
%load('SG_profiles.mat')

num_shots = 1000;
ori_dim = 80;
in_dim = 512;
coarse_dim = 40;

%Perform coarse_graining
for i = 1:num_shots
    %cg_in(i,:) = downsample(phase_SG_3(:,i)', ceil(in_dim/coarse_dim));
    cg_full(i,:) = downsample(fit_profiles_full(i,:), ceil(ori_dim/coarse_dim));
    cg_trans(i,:) = downsample(fit_profiles_trans(i,:), ceil(ori_dim/coarse_dim));
end
%corr_suite_in = class_1d_correlation(cg_in);
corr_suite_full = class_1d_correlation(cg_full);
corr_suite_trans = class_1d_correlation(cg_trans);

%tic
%G4_in = corr_suite_in.correlation_func(4);
%toc
tic
G4_full = corr_suite_full.correlation_func(4);
toc
tic
G4_trans = corr_suite_trans.correlation_func(4);
toc

%W4_in = corr_suite_in.wick_four_point_correlation();
W4_full = corr_suite_full.wick_four_point_correlation();
W4_trans = corr_suite_trans.wick_four_point_correlation();

save('corr_SG_3_t30.mat', 'G4_full', 'G4_trans', 'W4_trans', 'W4_full')
%save('corr_SG_3_input.mat', 'G4_in', 'W4_in')