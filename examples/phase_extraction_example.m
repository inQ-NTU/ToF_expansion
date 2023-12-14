%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_75nk.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

%generate sample and coarse-graining it
coarse_dim = 100;
phase_profile = phase_sampling_suite.generate_profiles();
coarse_phase_profile = phase_sampling_suite.coarse_grain(coarse_dim, phase_profile);
t_tof = 15e-3; 
flag_interaction_broadening = 1;

%initialize interference pattern class
interference_suite = class_interference_pattern(coarse_phase_profile, t_tof, flag_interaction_broadening);

%generate rho tof
rho_tof = interference_suite.tof_full_expansion();

%initialize phase extraction class
phase_extraction_suite = class_phase_extraction(rho_tof, t_tof, flag_interaction_broadening);
%%only input rho tof data means that other parameters are set to default,
%%to change the default values, simply add more argument. The second
%%argument is expansion time, and the third argument is separation distance

%make initial guess by the position of interference peak
init_phase = phase_extraction_suite.init_phase_guess();

%perform fitting
fitted_phase = phase_extraction_suite.fitting(init_phase);

%reconstructed rho_tof
%reco_rho_tof = phase_extraction_suite.reconstructed_interference_pattern;

%compute fidelity (coherence factor)
%fidelity_init = phase_extraction_suite.fidelity_coh(coarse_phase_profile, init_phase)
%fidelity_fitted = phase_extraction_suite.fidelity_coh(coarse_phase_profile, fitted_phase)

%plotting the result (assuming 100 microns gas
subplot(2,2,[1,2])
plot(linspace(0,100,400), phase_profile, 'b')
hold on
%plot(linspace(0,100,coarse_dim),init_phase, 'o', 'Color', 'black')
plot(linspace(0,100,coarse_dim),fitted_phase, 'o', 'Color','red')
%legend({'$\varphi_R$', '$\varphi_R^{(init)}$','$\varphi_R^{(fit)}$'},'Interpreter','latex')

subplot(2,2,3)
imagesc(rho_tof)
colorbar

%subplot(2,2,4)
%imagesc(reco_rho_tof)
%colorbar

colormap(gge_colormap)
