clear all
close all

addpath('../../input')

load('integrated_contrast_short_length.mat')
ic_in_1 = integrated_contrast_in;
ic_trans_1 = integrated_contrast_trans;
ic_woc_1_1 = integrated_contrast_woc_1;
ic_woc_2_1 = integrated_contrast_woc_2;
ic_woc_3_1 = integrated_contrast_woc_3;
ic_wc_1_1 = integrated_contrast_wc_1;
ic_wc_2_1 = integrated_contrast_wc_2;
ic_wc_3_1 = integrated_contrast_wc_3;
ic_woc_2_wp_1 = integrated_contrast_woc_2_wp;
ic_wc_2_wp_1 = integrated_contrast_wc_2_wp;

load('integrated_contrast_medium_length.mat')
ic_in_2 = integrated_contrast_in;
ic_trans_2 = integrated_contrast_trans;
ic_woc_1_2 = integrated_contrast_woc_1;
ic_woc_2_2 = integrated_contrast_woc_2;
ic_woc_3_2 = integrated_contrast_woc_3;
ic_wc_1_2 = integrated_contrast_wc_1;
ic_wc_2_2 = integrated_contrast_wc_2;
ic_wc_3_2 = integrated_contrast_wc_3;
ic_woc_2_wp_2 = integrated_contrast_woc_2_wp;
ic_wc_2_wp_2 = integrated_contrast_wc_2_wp;

load('integrated_contrast_long_length.mat')
ic_in_3 = integrated_contrast_in;
ic_trans_3 = integrated_contrast_trans;
ic_woc_1_3 = integrated_contrast_woc_1;
ic_woc_2_3 = integrated_contrast_woc_2;
ic_woc_3_3 = integrated_contrast_woc_3;
ic_wc_1_3 = integrated_contrast_wc_1;
ic_wc_2_3 = integrated_contrast_wc_2;
ic_wc_3_3 = integrated_contrast_wc_3;
ic_woc_2_wp_3 = integrated_contrast_woc_2_wp;
ic_wc_2_wp_3 = integrated_contrast_wc_2_wp;


%Plotting

f = tight_subplot(2,3,[.08 .08],[.15 .05],[.1 .1]);

axes(f(1))
histogram(ic_in_1,'Normalization','pdf','BinWidth',0.15)
hold on
histogram(ic_woc_1_1,'Normalization','pdf','BinWidth',0.15)
histogram(ic_woc_2_1,'Normalization','pdf','BinWidth',0.15)
%histogram(ic_woc_3_1,'Normalization','pdf','BinWidth',0.2)
ylim([0,4])
xlim([0,2.5])
xticks([])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$P(\xi)$', 'Interpreter','latex')
xlim([0,1.5])


axes(f(2))
histogram(ic_in_2,'Normalization','pdf','BinWidth',0.15)
hold on
histogram(ic_woc_1_2,'Normalization','pdf','BinWidth',0.15)
histogram(ic_woc_2_2,'Normalization','pdf','BinWidth',0.15)
%histogram(ic_woc_3_2,'Normalization','pdf','BinWidth',0.2)
%ylim([0,3])
xlim([0,2])
xticks([])
%yticks([])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(f(3))
histogram(ic_in_3,'Normalization','pdf','BinWidth',0.15)
hold on
histogram(ic_wc_1_3,'Normalization','pdf','BinWidth',0.15)
histogram(ic_wc_2_3,'Normalization','pdf','BinWidth',0.15)
%histogram(ic_wc_3_3,'Normalization','pdf','BinWidth',0.2)
%ylim([0,3])
xlim([0,2.5])
xticks([])
yticks([0,0.3,0.6])
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(f(4))
histogram(ic_in_1,'Normalization','pdf','BinWidth',0.15)
hold on
histogram(ic_wc_1_1,'Normalization','pdf','BinWidth',0.15)
histogram(ic_wc_2_1,'Normalization','pdf','BinWidth',0.15)
%histogram(ic_wc_3_1,'Normalization','pdf','BinWidth',0.2)
ylim([0,4])
xlim([0,2.5])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$P(\xi)$', 'Interpreter','latex')
xlabel('$\xi$', 'Interpreter','latex')
xlim([0,1.5])


axes(f(5))
histogram(ic_in_2,'Normalization','pdf','BinWidth',0.15)
hold on
histogram(ic_wc_1_2,'Normalization','pdf','BinWidth',0.15)
histogram(ic_wc_2_2,'Normalization','pdf','BinWidth',0.15)
%histogram(ic_wc_3_2,'Normalization','pdf','BinWidth',0.2)
%ylim([0,3])
xlim([0,2])
%yticks([])
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
xlabel('$\xi$', 'Interpreter','latex')

axes(f(6))
histogram(ic_in_3,'Normalization','pdf','BinWidth',0.15)
hold on
histogram(ic_wc_1_3,'Normalization','pdf','BinWidth',0.15)
histogram(ic_wc_2_3,'Normalization','pdf','BinWidth',0.15)
%histogram(ic_wc_3_3,'Normalization','pdf','BinWidth',0.2)
xlabel('$\xi$', 'Interpreter','latex')
%ylim([0,3])
xlim([0,2.5])
yticks([0,0.3,0.6])
%yticks([])
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

set(f,'FontName','Times','FontSize', 16)
if 0
figure
g = tight_subplot(2,3,[.08 .03],[.15 .05],[.1 .1]);
axes(g(1))
histogram(ic_woc_2_1,'Normalization','pdf','BinWidth',0.2)
hold on
histogram(ic_woc_2_wp_1,'Normalization','pdf','BinWidth',0.2, 'FaceColor','#FF8800')
ylim([0,2])
xlim([0,2.5])
xticks([])
title('$\mathbf{a}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$P(\xi)$', 'Interpreter','latex')


axes(g(2))
histogram(ic_woc_2_2,'Normalization','pdf','BinWidth',0.2)
hold on
histogram(ic_woc_2_wp_2,'Normalization','pdf','BinWidth',0.2,'FaceColor','#FF8800')
ylim([0,2])
xlim([0,2.5])
xticks([])
yticks([])
title('$\mathbf{b}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

axes(g(3))
histogram(ic_woc_2_3,'Normalization','pdf','BinWidth',0.2)
hold on
histogram(ic_woc_2_wp_3,'Normalization','pdf','BinWidth',0.2,'FaceColor','#FF8800')
ylim([0,2])
xlim([0,2.5])
xticks([])
yticks([])
title('$\mathbf{c}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])


axes(g(4))
histogram(ic_wc_2_1,'Normalization','pdf','BinWidth',0.2)
hold on
histogram(ic_wc_2_wp_1,'Normalization','pdf','BinWidth',0.2, 'FaceColor','#FF8800')
ylim([0,2])
xlim([0,2.5])
title('$\mathbf{d}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
ylabel('$P(\xi)$', 'Interpreter','latex')
xlabel('$\xi$', 'Interpreter','latex')


axes(g(5))
histogram(ic_wc_2_2,'Normalization','pdf','BinWidth',0.2)
hold on
histogram(ic_wc_2_wp_2,'Normalization','pdf','BinWidth',0.2,'FaceColor','#FF8800')
ylim([0,2])
xlim([0,2.5])
yticks([])
title('$\mathbf{e}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])
xlabel('$\xi$', 'Interpreter','latex')

axes(g(6))
histogram(ic_wc_2_3,'Normalization','pdf','BinWidth',0.2)
hold on
histogram(ic_wc_2_wp_3,'Normalization','pdf','BinWidth',0.2,'FaceColor','#FF8800')
xlabel('$\xi$', 'Interpreter','latex')
ylim([0,2])
xlim([0,2.5])
yticks([])
title('$\mathbf{f}$','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8])

set(g,'FontName','Times','FontSize', 16)

end