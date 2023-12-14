%Adding directories and loading example phase profile containing a variable
%First (second) row of phase_profile_RS is interpreted to be relative (common) phase
addpath('../classes')
addpath('../input')
load('thermal_cov_60nk.mat')

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

relative_phase_profile = phase_sampling_suite.generate_profiles();
common_phase_profile = phase_sampling_suite.generate_profiles();
t_tof  = 10e-3; %10 ms expansion
insitu_profile_str = 'InverseParabola'; %the shape of insitu profile, other options: flat, BoxDensity

%initialize interference pattern class
interference_suite = class_interference_pattern([relative_phase_profile; common_phase_profile], t_tof, 'InverseParabola');


%phase input consist of two rows: relative and common 
%if only one row, it is interpreted as relative phase and common phase is
%set to zero
%only phase input means the other variables are set to default
%the default for expansion time is 15 ms, and inverse parabola profile


%generating interference pattern
%transversal expansion only
rho_tof_trans = interference_suite.tof_transversal_expansion();

%full expansion (transversal and longitudinal)
rho_tof_full = interference_suite.tof_full_expansion();

%showing the results
subplot(1,2,1)
imagesc(rho_tof_trans)
colorbar

subplot(1,2,2)
imagesc(rho_tof_full)
colorbar

colormap(gge_colormap)