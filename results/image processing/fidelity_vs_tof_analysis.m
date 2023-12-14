clear all
close all

load('fidelity_coh_stats_vs_tof.mat')

t_tof = t_tof*1e3;
mean_woc = zeros(1,length(t_tof));
mean_wc = zeros(1,length(t_tof));
mean_woc_ref = zeros(1,length(t_tof));
mean_wc_ref = zeros(1,length(t_tof));

std_woc = zeros(1,length(t_tof));
std_wc = zeros(1,length(t_tof));
std_woc_ref = zeros(1,length(t_tof));
std_wc_ref = zeros(1,length(t_tof));

for i = 1:length(t_tof)
    mean_woc(i) = mean(fidelity_woc_stats(i,:));
    mean_wc(i) = mean(fidelity_wc_stats(i,:));
    mean_woc_ref(i) = mean(fidelity_woc_stats_ref(i,:));
    mean_wc_ref(i) = mean(fidelity_wc_stats_ref(i,:));

    std_woc(i) = std(fidelity_woc_stats(i,:));
    std_wc(i)= std(fidelity_wc_stats(i,:));
    std_woc_ref(i) = std(fidelity_woc_stats_ref(i,:));
    std_wc_ref(i) = std(fidelity_wc_stats_ref(i,:));
end
fontsize = 16;
%Plotting
figure
f(1) = subplot(1,3,1);
histogram(fidelity_wc_stats(1,:),'Normalization', 'probability','BinWidth',0.1)
xlabel('$F$', 'Interpreter','latex')
ylabel('$P(F)$','Interpreter','latex')
ylim([0,0.25])
title('\textbf{a}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);

f(2) = subplot(1,3,2);
histogram(fidelity_wc_stats(5,:),'Normalization','probability')
xlabel('$F$', 'Interpreter','latex')
title('\textbf{b}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.8]);
ylim([0,0.25])
yticks([])

f(3) = subplot(1,3,3);
errorbar(t_tof,mean_woc,std_woc, 'o-','Color','red');
hold on
errorbar(t_tof, mean_wc, std_wc, 'x','Color','red')
errorbar(t_tof,mean_woc_ref,std_woc_ref, 'o','Color','black')
errorbar(t_tof,mean_wc_ref, std_wc_ref, 'x','Color','black')
%ylim([-0.6,1.1])
xlabel('$t\; (\rm ms)$', 'Interpreter','latex','FontSize',fontsize)
ylabel('$\langle F\rangle$', 'Interpreter','latex','FontSize',fontsize)
yticks([0,0.5,1])
yticklabels([0,0.5,1])
%xlim([5.8,16.2])
ylim([0,1.1])
title('\textbf{c}','FontName','Times','Color','black','Units', 'normalized','Interpreter','latex','Position',[0.1,0.85]);


g(1) = axes('Position',[.79 .4 .1 .25]);
box on
plot(t_tof,mean_woc,'o','Color','red')
hold on
plot(t_tof,mean_wc, 'x', 'Color','red')
plot(t_tof,mean_woc_ref,'o','Color','black')
plot(t_tof,mean_wc_ref, 'x', 'Color','black')
ylim([0.85,0.9])
xticks([8,9,10,11])
set(g(1), 'FontSize', fontsize-5,'FontName', 'Times')
set(f, 'FontSize', fontsize,'FontName', 'Times')