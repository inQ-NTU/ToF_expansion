%Adding directories and loading example phase profile containing a variable
%phase_profile_RS
%First (second) row of phase_profile_RS is interpreted to be relative (common) phase
addpath('../classes')
addpath('../input')
load('EXAMPLE_phase_profile.mat')

%initialize interference pattern class
interference_suite = class_interference_pattern(phase_profile_RS);

%only phase input means the other variables are set to default
%to change the default values, just add more argument. If athe second argument
%is expansion time, the third is buffer length (to see longitudinal
%expansion), the fourth is separation distance, and the last is condensate
%length. You can just specify some of them.
%For example, to change expansion time and buffer, we write
%interference_suite_wo_common = phase_sampling_suite(phase_profile_RS(1,:), 7e-3, 5e-6);
%this will investigate tof at 7 ms with 5 microns buffer

%the above initialization already takes into account common phase. if we
%want to take it out, simply do
%interference_suite_wo_common = class_interference_pattern(phase_profile_RS(1,:));


%generating interference pattern
%transversal expansion only
rho_tof_trans = interference_suite.tof_transversal_expansion();

%full expansion (transversal and longitudinal)
rho_tof_full = interference_suite.tof_transversal_expansion();

%convolving and adding noise to the full interference pattern
processed_rho_tof_full = interference_suite.convolution2d(rho_tof_full);

sigma_scale = 0.05; %this will set the standard deviation (std) of the noise, 
% 0.05 means that the std is 5% of the maximum peak of the interference
% pattern 

processed_rho_tof_full = interference_suite.add_gaussian_noise(processed_rho_tof_full, sigma_scale);

%showing the results
subplot(1,3,1)
imagesc(rho_tof_trans)
colorbar

subplot(1,3,2)
imagesc(rho_tof_full)
colorbar

subplot(1,3,3)
imagesc(processed_rho_tof_full)
colorbar

colormap(gge_colormap)