fontname = 'Times';
fontsize = 16;
fig = figure;
f(1) = subplot(3,3,1);
imagesc(G4_7(:,:,10,30))
title('Full', 'FontSize', fontsize)
colorbar
clim([0,6])
f(2) = subplot(3,3,2);
imagesc(W4_7(:,:,10,30))
title('Wick', 'FontSize', fontsize)
colorbar
clim([0,6])
f(3) = subplot(3,3,3);
imagesc(DevGW4_7(:,:,10,30))
title('Full-Wick', 'FontSize', fontsize)
colorbar
clim([-1,1])
f(4) = subplot(3,3,4);
imagesc(G4_15(:,:,10,30))
clim([0,6])
colorbar
f(5) = subplot(3,3,5);
imagesc(W4_15(:,:,10,30))
colorbar
clim([0,6])
f(6) = subplot(3,3,6);
imagesc(DevGW4_15(:,:,10,30))
colorbar
clim([-1,1])
f(7) = subplot(3,3,7);
imagesc(G4_30(:,:,10,30))
clim([0,6])
colorbar
f(8) = subplot(3,3,8);
imagesc(W4_30(:,:,10,30))
colorbar
clim([0,6])
f(9) = subplot(3,3,9);
imagesc(DevGW4_30(:,:,10,30))
colorbar
clim([-1,1])
colormap(gge_colormap)
set(f, 'FontName',fontname, 'FontSize', fontsize)