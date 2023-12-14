addpath('../classes')
addpath('../input')
load('thermal_cov_50nk.mat')

%Defining some parameters
coarse_dim = 80;
condensate_length = 80;
z=linspace(0,condensate_length,coarse_dim);
num_shots = 200;
t_tof_1 = 7e-3;
t_tof_2 = 15e-3;
t_tof_3 = 30e-3; 
if 0
%gaussian phase sampling
phase_sampling_suite = class_gaussian_phase_sampling(cov_phase_fine);

%sampling phase - first row rel, second row com
rel_phase = phase_sampling_suite.generate_profiles(num_shots);
com_phase = phase_sampling_suite.generate_profiles(num_shots);


%coarse_grained_common_phase and its derivative
cg_com_phase = phase_sampling_suite.coarse_grain(coarse_dim, com_phase);
grad_com = gradient(cg_com_phase);


amp_dev_t7 = zeros(num_shots, coarse_dim);
amp_dev_t15 = zeros(num_shots, coarse_dim);
amp_dev_t30 = zeros(num_shots, coarse_dim);

count = 0;
for i = 1:num_shots
    %generate tof
    interference_suite_t7 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_1);
    interference_suite_t15 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_2);
    interference_suite_t30 = class_interference_pattern([rel_phase(i,:); com_phase(i,:)], t_tof_3);

    rho_tof_trans_t7 = interference_suite_t7.tof_transversal_expansion();
    rho_tof_trans_t7 = imresize(rho_tof_trans_t7, [coarse_dim 1.2*coarse_dim]);
    rho_tof_trans_t15 = interference_suite_t15.tof_transversal_expansion();
    rho_tof_trans_t15 = imresize(rho_tof_trans_t15, [coarse_dim 1.2*coarse_dim]);
    rho_tof_trans_t30 = interference_suite_t30.tof_transversal_expansion();
    rho_tof_trans_t30 = imresize(rho_tof_trans_t30, [coarse_dim 1.2*coarse_dim]);

    rho_tof_full_t7 = interference_suite_t7.tof_full_expansion();
    rho_tof_full_t7 = imresize(rho_tof_full_t7, [coarse_dim 1.2*coarse_dim]);
    rho_tof_full_t15 = interference_suite_t15.tof_full_expansion();
    rho_tof_full_t15 = imresize(rho_tof_full_t15, [coarse_dim 1.2*coarse_dim]);
    rho_tof_full_t30 = interference_suite_t30.tof_full_expansion();
    rho_tof_full_t30 = imresize(rho_tof_full_t30, [coarse_dim 1.2*coarse_dim]);

    %phase_extraction
    phase_ext_trans_t7 = class_phase_extraction(rho_tof_trans_t7, t_tof_1);
    phase_ext_full_t7 = class_phase_extraction(rho_tof_full_t7, t_tof_1);
    phase_ext_trans_t15 = class_phase_extraction(rho_tof_trans_t15, t_tof_2);
    phase_ext_full_t15= class_phase_extraction(rho_tof_full_t15, t_tof_2);
    phase_ext_trans_t30 = class_phase_extraction(rho_tof_trans_t30, t_tof_3);
    phase_ext_full_t30 = class_phase_extraction(rho_tof_full_t30, t_tof_3);

    %amplitude extraction
    ext_phase_trans_t7 = phase_ext_trans_t7.fitting(phase_ext_trans_t7.init_phase_guess());
    ext_phase_full_t7 = phase_ext_full_t7.fitting(phase_ext_full_t7.init_phase_guess());
    ext_phase_trans_t15 = phase_ext_trans_t15.fitting(phase_ext_trans_t15.init_phase_guess());
    ext_phase_full_t15 = phase_ext_full_t15.fitting(phase_ext_full_t15.init_phase_guess());
    ext_phase_trans_t30 = phase_ext_trans_t30.fitting(phase_ext_trans_t30.init_phase_guess());
    ext_phase_full_t30 = phase_ext_full_t30.fitting(phase_ext_full_t30.init_phase_guess());

    ext_amp_trans_t7 = phase_ext_trans_t7.normalization_amplitudes;
    ext_amp_trans_t15 = phase_ext_trans_t15.normalization_amplitudes;
    ext_amp_trans_t30 = phase_ext_trans_t30.normalization_amplitudes;
    ext_amp_full_t7 = phase_ext_full_t7.normalization_amplitudes;
    ext_amp_full_t15 = phase_ext_full_t15.normalization_amplitudes;
    ext_amp_full_t30 = phase_ext_full_t30.normalization_amplitudes;

    amp_dev_t7(i,:) = ext_amp_full_t7 - ext_amp_trans_t7;
    amp_dev_t15(i,:) = ext_amp_full_t15 - ext_amp_trans_t15;
    amp_dev_t30(i,:) = ext_amp_full_t30 - ext_amp_trans_t30;

    count = count+1;
    disp(count)
end

corr_t7 = zeros(coarse_dim, coarse_dim);
corr_t15 = zeros(coarse_dim, coarse_dim);
corr_t30 = zeros(coarse_dim, coarse_dim);

for i = 1:coarse_dim
    for j = 1:coarse_dim
        corr_val_t7 = 0;
        corr_val_t15 = 0;
        corr_val_t30 = 0;
        for k = 1:num_shots
            corr_val_t7 = corr_val_t7 + amp_dev_t7(k,i)*grad_com(k,j);
            corr_val_t15 = corr_val_t15 + amp_dev_t15(k,i)*grad_com(k,j);
            corr_val_t30 = corr_val_t30 + amp_dev_t30(k,i)*grad_com(k,j);
        end
        corr_val_t7 = corr_val_t7/num_shots;
        corr_val_t15 = corr_val_t15/num_shots;
        corr_val_t30 = corr_val_t30/num_shots;
        corr_t7(i,j) = corr_val_t7;
        corr_t15(i,j) = corr_val_t15;
        corr_t30(i,j) = corr_val_t30;
    end
end
end
%Plotting the correlation
f(1) = subplot(1,3,1);
imagesc(z, z, corr_t7)
colorbar
title('$t_{ToF} = 7 \; ms$ ','Interpreter', 'latex')
ylabel('$z\; (\mu m)$', 'Interpreter', 'latex')
xlabel('$z^\prime (\mu m)$', 'Interpreter', 'latex')

f(2) = subplot(1,3,2);
imagesc(z,z, corr_t15)
colorbar
yticks([])
title('$t_{ToF} = 15 \; ms$ ','Interpreter', 'latex')
xlabel('$z^\prime (\mu m)$', 'Interpreter', 'latex')

f(3) = subplot(1,3,3);
imagesc(z,z, corr_t30);
yticks([])
colorbar
title('$t_{ToF} = 30 \; ms$ ','Interpreter', 'latex')
xlabel('$z^\prime (\mu m)$', 'Interpreter', 'latex')

colormap(gge_colormap)
set(f, 'FontName', 'Times', 'FontSize', 16)
sgtitle('$\langle [A(z)-\rho_0(z)]\Delta\varphi_+(z)\rangle$', 'Interpreter', 'latex')