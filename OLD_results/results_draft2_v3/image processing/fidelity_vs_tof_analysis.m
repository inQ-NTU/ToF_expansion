
%clear all
%close all

load('fidelity_coh_stats_vs_tof.mat')

t_tof = t_tof*1e3;
median_woc = zeros(1,length(t_tof));
median_wc = zeros(1,length(t_tof));
median_woc_ref = zeros(1,length(t_tof));
median_wc_ref = zeros(1,length(t_tof));

iqr_woc = zeros(1,length(t_tof));
iqr_wc = zeros(1,length(t_tof));
iqr_woc_ref = zeros(1,length(t_tof));
iqr_wc_ref = zeros(1,length(t_tof));

for i = 1:length(t_tof)
    median_woc(i) = median(fidelity_woc_stats(i,:));
    median_wc(i) = median(fidelity_wc_stats(i,:));
    median_woc_ref(i) = median(fidelity_woc_stats_ref(i,:));
    median_wc_ref(i) = median(fidelity_wc_stats_ref(i,:));

    iqr_woc(i) = quantile(fidelity_woc_stats(i,:),0.75) - quantile(fidelity_woc_stats(i,:),0.25);
    iqr_wc(i)= quantile(fidelity_wc_stats(i,:),0.75) - quantile(fidelity_wc_stats(i,:),0.25);
    iqr_woc_ref(i) = quantile(fidelity_woc_stats_ref(i,:),0.75) - quantile(fidelity_woc_stats_ref(i,:),0.25);
    iqr_wc_ref(i) = quantile(fidelity_wc_stats_ref(i,:),0.75) - quantile(fidelity_wc_stats_ref(i,:),0.25);
end

load('fidelity_coh_stats_vs_tof.mat')

t_tof = t_tof*1e3;
median_woc = zeros(1,length(t_tof));
median_wc = zeros(1,length(t_tof));
median_woc_ref = zeros(1,length(t_tof));
median_wc_ref = zeros(1,length(t_tof));

iqr_woc = zeros(1,length(t_tof));
iqr_wc = zeros(1,length(t_tof));
iqr_woc_ref = zeros(1,length(t_tof));
iqr_wc_ref = zeros(1,length(t_tof));

for i = 1:length(t_tof)
    median_woc(i) = median(fidelity_woc_stats(i,:));
    median_wc(i) = median(fidelity_wc_stats(i,:));
    median_woc_ref(i) = median(fidelity_woc_stats_ref(i,:));
    median_wc_ref(i) = median(fidelity_wc_stats_ref(i,:));

    iqr_woc(i) = quantile(fidelity_woc_stats(i,:),0.75) - quantile(fidelity_woc_stats(i,:),0.25);
    iqr_wc(i)= quantile(fidelity_wc_stats(i,:),0.75) - quantile(fidelity_wc_stats(i,:),0.25);
    iqr_woc_ref(i) = quantile(fidelity_woc_stats_ref(i,:),0.75) - quantile(fidelity_woc_stats_ref(i,:),0.25);
    iqr_wc_ref(i) = quantile(fidelity_wc_stats_ref(i,:),0.75) - quantile(fidelity_wc_stats_ref(i,:),0.25);
end
fontsize = 20;
%Plotting
figure
f(1) = subplot(2,2,1);
histogram(fidelity_wc_stats(2,:),'Normalization', 'probability','BinWidth',0.07)
xlabel('$F$', 'Interpreter','latex')
ylabel('$P(F)$','Interpreter','latex')
ylim([0,0.25])
title('\textbf{e}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.75]);

f(2) = subplot(2,2,2);
histogram(fidelity_wc_stats(7,:),'Normalization','probability')
xlabel('$F$', 'Interpreter','latex')
title('\textbf{f}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.72]);


f(3) = subplot(2,2,[3,4]);
errorbar(t_tof,median_woc,iqr_woc, 'o','Color','red');
hold on
errorbar(t_tof, median_wc, iqr_wc, 'x','Color','red')
errorbar(t_tof,median_woc_ref,iqr_woc_ref, 'o','Color','black')
errorbar(t_tof,median_wc_ref, iqr_wc_ref, 'x','Color','black')
%ylim([-0.6,1.1])
xlabel('$t\; (\rm ms)$', 'Interpreter','latex','FontSize',fontsize)
ylabel('$\tilde{F}$', 'Interpreter','latex','FontSize',fontsize)
yticks([0,0.5,1])
yticklabels([0,0.5,1])
xlim([5.8,16.2])
ylim([0,1.15])
title('\textbf{g}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.05,0.8]);


g(1) = axes('Position',[.55 .18 .3 .15]);
box on
plot(t_tof,median_woc,'o','Color','red')
hold on
plot(t_tof,median_wc, 'x', 'Color','red')
plot(t_tof,median_woc_ref,'o','Color','black')
plot(t_tof,median_wc_ref, 'x', 'Color','black')
ylim([0.8,0.92])
xticks([6,8,10,12,14,16])
set(g(1), 'FontSize', fontsize-5,'FontName', 'Times')
set(f, 'FontSize', fontsize,'FontName', 'Times')