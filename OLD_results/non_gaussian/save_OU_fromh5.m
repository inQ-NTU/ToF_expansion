phase_OU_05 = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/phase_OU_0.5');
phase_OU_1 = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/phase_OU_1');
phase_OU_2 = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/phase_OU_2');
phase_OU_3 = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/phase_OU_3');

phase_OU_05_subsampling = h5read('SG_phaseprofiles_Taufiq_1000shots_TFsubsampling.h5','/phase_OU_0.5');
phase_OU_1_subsampling = h5read('SG_phaseprofiles_Taufiq_1000shots_TFsubsampling.h5','/phase_OU_1');
phase_OU_2_subsampling = h5read('SG_phaseprofiles_Taufiq_1000shots_TFsubsampling.h5','/phase_OU_2');
phase_OU_3_subsampling = h5read('SG_phaseprofiles_Taufiq_1000shots_TFsubsampling.h5','/phase_OU_3');

z_grid = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/z');

save('OU_profiles.mat', 'phase_OU_05','phase_OU_1', 'phase_OU_2','phase_OU_3','phase_OU_1_subsampling',...
'phase_OU_2_subsampling', 'phase_OU_3_subsampling', 'z_grid')