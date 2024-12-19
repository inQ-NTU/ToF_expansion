clear all
close all
addpath('../../input')


load('fdf_short_length_wp.mat')
integrated_contrast_in_short = integrated_contrast_in;
integrated_contrast_wop_woc_short = integrated_contrast_wop_woc;
integrated_contrast_wop_wc_short = integrated_contrast_wop_wc;
integrated_contrast_wp_woc_short = integrated_contrast_wp_woc;
integrated_contrast_wp_wc_short = integrated_contrast_wp_wc; 

load('fdf_medium_length_wp.mat')
integrated_contrast_in_medium = integrated_contrast_in;
integrated_contrast_wop_woc_medium = integrated_contrast_wop_woc;
integrated_contrast_wop_wc_medium = integrated_contrast_wop_wc;
integrated_contrast_wp_woc_medium = integrated_contrast_wp_woc;
integrated_contrast_wp_wc_medium = integrated_contrast_wp_wc; 

load('fdf_long_length_wp.mat')
integrated_contrast_in_long = integrated_contrast_in;
integrated_contrast_wop_woc_long = integrated_contrast_wop_woc;
integrated_contrast_wop_wc_long = integrated_contrast_wop_wc;
integrated_contrast_wp_woc_long = integrated_contrast_wp_woc;
integrated_contrast_wp_wc_long = integrated_contrast_wp_wc; 


%Plotting
figure
f = tight_subplot(2,3,[.07 .07],[.15 .05],[.1 .1]);

axes(f(1))
%histogram(integrated_contrast_in_short, 'BinWidth', 0.15, 'Normalization','pdf')
%hold on
histogram(integrated_contrast_wop_woc_short, 'BinWidth', 0.15, 'Normalization','pdf', 'DisplayStyle','stairs','LineWidth',1.05)
hold on
histogram(integrated_contrast_wp_woc_short, 'BinWidth',0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
ylim([0,4])
xlim([0,2.5])
xticks([])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$P(\xi)$', 'Interpreter','latex')
xlim([0,1.5])


axes(f(2))
%histogram(integrated_contrast_in_medium, 'BinWidth', 0.15, 'Normalization','pdf')
%hold on
histogram(integrated_contrast_wop_woc_medium, 'BinWidth', 0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
hold on
histogram(integrated_contrast_wp_woc_medium, 'BinWidth',0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
xlim([0,2])
ylim([0, 1.2])
xticks([])
%yticks([])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(3))
%histogram(integrated_contrast_in_long, 'BinWidth', 0.15, 'Normalization','pdf')
%hold on
histogram(integrated_contrast_wop_woc_long, 'BinWidth', 0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
hold on
histogram(integrated_contrast_wp_woc_long, 'BinWidth',0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
%ylim([0,3])
ylim([0, 0.7])
xlim([0,2.5])
xticks([])
yticks([0,0.3,0.6])
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(4))
%histogram(integrated_contrast_in_short, 'BinWidth', 0.15, 'Normalization','pdf')
%hold on
histogram(integrated_contrast_wop_wc_short, 'BinWidth', 0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
hold on
histogram(integrated_contrast_wp_wc_short, 'BinWidth',0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
ylim([0,4])
xlim([0,2.5])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$P(\xi)$', 'Interpreter','latex')
xlabel('$\xi$', 'Interpreter','latex')
xlim([0,1.5])

axes(f(5))
%histogram(integrated_contrast_in_medium, 'BinWidth', 0.15, 'Normalization','pdf')
%hold on
histogram(integrated_contrast_wop_wc_medium, 'BinWidth', 0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
hold on
histogram(integrated_contrast_wp_wc_medium, 'BinWidth',0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
%ylim([0,3])
ylim([0, 1.2])
xlim([0,2])
%yticks([])
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
xlabel('$\xi$', 'Interpreter','latex')

axes(f(6))
%histogram(integrated_contrast_in_long, 'BinWidth', 0.15, 'Normalization','pdf')
%hold on
histogram(integrated_contrast_wop_wc_long, 'BinWidth', 0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
hold on
histogram(integrated_contrast_wp_wc_long, 'BinWidth',0.15, 'Normalization','pdf',  'DisplayStyle','stairs','LineWidth',1.05)
xlabel('$\xi$', 'Interpreter','latex')
%ylim([0,3])
ylim([0, 0.7])
xlim([0,2.5])
yticks([0,0.3,0.6])
%yticks([])
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

set(f,'FontName','Times','FontSize', 16)

