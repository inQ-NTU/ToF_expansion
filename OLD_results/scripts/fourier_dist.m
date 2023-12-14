clear all
%Adding directories and loading input covariance matrix with variable
%name'cov_phase' inside 'thermal_cov.mat'
addpath('../classes')
addpath('../input')
load('thermal_cov_25nk.mat')

%initialize phase sampling class
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase);

%generate sample and coarse-graining it
coarse_dim = 200;
nmb_sampled_phases = 1000;
rel_phase_profiles = phase_sampling_suite.generate_profiles(nmb_sampled_phases);

coarse_rel_profiles = phase_sampling_suite.coarse_grain(coarse_dim, rel_phase_profiles);

all_input_fourier = zeros(nmb_sampled_phases, coarse_dim/2+1);
for i = 1:nmb_sampled_phases
    %Compute input fourier spectrum
    fourier_input = abs(fft(coarse_rel_profiles(i,:))/sqrt(coarse_dim));
    fourier_input = fourier_input(1:coarse_dim/2+1);% Single sampling plot
    all_input_fourier(i,:) = fourier_input;
end

%Plotting
histogram(all_input_fourier(:,2),'BinWidth',1,'Normalization','pdf')
hold on
histogram(all_input_fourier(:,3),'BinWidth',1,'Normalization','pdf')
histogram(all_input_fourier(:,4),'BinWidth',1, 'Normalization','pdf')
histogram(all_input_fourier(:,5),'BinWidth',1,'Normalization','pdf','FaceAlpha',0.5)
legend({'$n = 1$','$n=2$','$n=3$','$n=4$'},'Interpreter','latex')
set(gca, 'FontName','Times','FontSize',16)
ylabel('$P(|A_n|)$','Interpreter','latex')
xlabel('$|A_n|$','Interpreter','latex')
title('Amplitude Fourier $|A_n|$ Distribution ($T = 25\; nK$)','Interpreter','latex','FontSize',14)
