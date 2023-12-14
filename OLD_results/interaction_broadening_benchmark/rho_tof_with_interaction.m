clear all
close all

%Adding directories and loading example phase profile containing a variable
%phase_profile_RS
%First (second) row of phase_profile_RS is interpreted to be relative (common) phase
addpath('../classes')
addpath('../input')
load('EXAMPLE_phase_profile.mat')
load('thermal_cov_75nk.mat')

%Number of atoms
N_atoms = 10^4;
condensate_length = 100e-6;
t_tof = 15e-3; 
flag_interaction = 1;

phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);
rel_phase = phase_sampling_suite.generate_profiles();

interference_suite_int = class_interference_pattern(rel_phase, t_tof, flag_interaction);
interference_suite =  class_interference_pattern(rel_phase , t_tof);

rho_tof_int = interference_suite_int.tof_full_expansion();
rho_tof_int = interference_suite_int.normalize(rho_tof_int, N_atoms);

rho_tof = interference_suite.tof_full_expansion();
rho_tof = interference_suite.normalize(rho_tof, N_atoms);


if 0
subplot(1,2,1)
imagesc(rho_tof')
colorbar

subplot(1,2,2)
imagesc(rho_tof_int')
colorbar

colormap(gge_colormap)
end

%phase extraction
ext_suite_with_int = class_phase_extraction(rho_tof_int, t_tof, flag_interaction);
ext_suite = class_phase_extraction(rho_tof, t_tof, flag_interaction);

ext_phase_with_int = ext_suite_with_int.fitting(ext_suite_with_int.init_phase_guess());
ext_phase = ext_suite.fitting(ext_suite.init_phase_guess());


if 0
%plot the phase
plot(ext_phase_with_int,'Color','red','LineWidth',1.2)
hold on
plot(ext_phase, '.', 'Color', [0,0.7,0])
plot(rel_phase, '--', 'Color', 'Black')
end

amp_with_int = ext_suite_with_int.normalization_amplitudes;
amp = ext_suite.normalization_amplitudes;

contrast_with_int = ext_suite_with_int.contrasts;
contrast = ext_suite.contrasts;

width_int = ext_suite_with_int.gaussian_width;
width = ext_suite.gaussian_width;


%plot the other fit parameters
figure
plot(amp_with_int, 'Color','red')
hold on
plot(amp, 'Color',[0,0.7,0])

figure
plot(contrast_with_int, 'Color','red')
hold on
plot(contrast, 'Color',[0,0.7,0])

figure
plot(width_int, 'Color','red')
hold on
plot(width, 'Color',[0,0.7,0])



