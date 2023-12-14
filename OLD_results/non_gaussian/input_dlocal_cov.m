addpath('../input')
addpath('../classes')
load('OU_profiles.mat')
%load('fit_phase_OU_1_t15p6.mat')
%dim_in = 80;
dim_in = 512;
num_shots = 200;

%input_phase = fit_profiles_trans;
input_phase = phase_OU_1';
dlocal_in = zeros(num_shots, dim_in-1);

for i = 1:num_shots
    for j = 1:dim_in-1
        dlocal_in(i,j) = input_phase(i,j+1) - input_phase(i,j);
    end
end
corr = class_1d_correlation(dlocal_in);
cov = corr.covariance_matrix;

imagesc(cov)