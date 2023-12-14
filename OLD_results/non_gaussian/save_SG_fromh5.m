phase_SG_05 = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/phase_SG_0.5');
phase_SG_1 = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/phase_SG_1');
phase_SG_2 = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/phase_SG_2');
phase_SG_3 = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/phase_SG_3');

phase_SG_05_subsampling = h5read('SG_phaseprofiles_Taufiq_1000shots_TFsubsampling.h5','/phase_SG_0.5');
phase_SG_1_subsampling = h5read('SG_phaseprofiles_Taufiq_1000shots_TFsubsampling.h5','/phase_SG_1');
phase_SG_2_subsampling = h5read('SG_phaseprofiles_Taufiq_1000shots_TFsubsampling.h5','/phase_SG_2');
phase_SG_3_subsampling = h5read('SG_phaseprofiles_Taufiq_1000shots_TFsubsampling.h5','/phase_SG_3');

z_grid = h5read('SG_phaseprofiles_Taufiq_1000shots.h5','/z');

save('SG_profiles.mat', 'phase_SG_05','phase_SG_1', 'phase_SG_2','phase_SG_3','phase_SG_1_subsampling',...
'phase_SG_2_subsampling', 'phase_SG_3_subsampling', 'z_grid')
