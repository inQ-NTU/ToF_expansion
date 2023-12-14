close all
% Open a new figure window

% Load the first .fig file
h1 = openfig('FDF_10microns.fig');

% Get the handles of axes within the first figure
axes1 = findobj(h1, 'type', 'axes');

% Load the second .fig file
h2 = openfig('FDF_30microns.fig');

% Get the handles of axes within the second figure
axes2 = findobj(h2, 'type', 'axes');

% Load the third .fig file
h3 = openfig('FDF_50microns.fig');

% Get the handles of axes within the third figure
axes3 = findobj(h3, 'type', 'axes');

% Create subplots in the new figure with a 3 x 3 grid layout
figure
f(1) = subplot(3,3,1);
copyobj(get(axes1(3), 'children'), gca);
%xlim([0,3])
%xticks([])
ylim([0,3])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.25,0.85]);
ylabel('$P(\alpha)$','Interpreter','latex')

f(2) = subplot(3,3,2);
copyobj(get(axes1(2), 'children'), gca);
%xlim([0,3])
%xticks([])
ylim([0,3])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(3) = subplot(3,3,3);
copyobj(get(axes1(1), 'children'), gca);
%xlim([0,3])
%xticks([])
ylim([0,3])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(4) = subplot(3,3,4);
copyobj(get(axes2(3), 'children'), gca);
%xlim([0,3])
%xticks([])
ylim([0,0.7])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.25,0.85]);
ylabel('$P(\alpha)$','Interpreter','latex')

f(5) = subplot(3,3,5);
copyobj(get(axes2(2), 'children'), gca);
%xlim([0,3])
ylim([0,0.7])
%xticks([])
yticks([])
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(6) = subplot(3,3,6);
copyobj(get(axes2(1), 'children'), gca);
%xlim([0,3])
%xticks([])
ylim([0,0.7])
yticks([])
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);

f(7) = subplot(3,3,7);
copyobj(get(axes3(3), 'children'), gca);
xlim([0,3])
ylim([0,0.7])
title('$\mathbf{g}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.25,0.85]);
xlabel('$\alpha$', 'Interpreter','latex')
ylabel('$P(\alpha)$','Interpreter','latex')

f(8) = subplot(3,3,8);
copyobj(get(axes3(2), 'children'), gca);
xlim([0,3])
ylim([0,0.7])
yticks([])
title('$\mathbf{h}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xlabel('$\alpha$', 'Interpreter','latex')
f(9) = subplot(3,3,9);
copyobj(get(axes3(1), 'children'), gca);
xlim([0,3])
ylim([0,0.7])
yticks([])
title('$\mathbf{i}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[-0.15,0.85]);
xlabel('$\alpha$', 'Interpreter','latex')
set(f, 'FontSize', 14, 'FontName', 'Times')


% Close the opened .fig files
close(h1);
close(h2);
close(h3);