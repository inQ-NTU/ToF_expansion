phase_SG_05 = h5read('SG_phaseprofiles_batch2.h5','/phase_SG_0.5');
phase_SG_1 = h5read('SG_phaseprofiles_batch2.h5','/phase_SG_1');
phase_SG_2 = h5read('SG_phaseprofiles_batch2.h5','/phase_SG_2');
phase_SG_3 = h5read('SG_phaseprofiles_batch2.h5','/phase_SG_3');
phase_SG_10 = h5read('SG_phaseprofiles_batch2.h5','/phase_SG_10');

z_grid = h5read('SG_phaseprofiles_batch2.h5','/z');

save('SG_profiles_batch1.mat', 'phase_SG_05','phase_SG_1', 'phase_SG_2','phase_SG_3','phase_SG_10','z_grid')