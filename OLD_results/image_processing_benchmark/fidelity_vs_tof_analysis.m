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

fontsize = 16;

f(1) = subplot(1,1,1);
errorbar(t_tof,median_woc,iqr_woc, 'o','Color','red');
hold on
errorbar(t_tof, median_wc, iqr_wc, 'x','Color','red')
errorbar(t_tof,median_woc_ref,iqr_woc_ref, 'o','Color','black')
errorbar(t_tof,median_wc_ref, iqr_wc_ref, 'x','Color','black')
%ylim([-0.6,1.1])
xlabel('$t\; (\rm ms)$', 'Interpreter','latex','FontSize',fontsize)
ylabel('$\langle\phi^{\rm (in)}_-, \phi^{\rm (out)}_-\rangle$', 'Interpreter','latex','FontSize',fontsize)
yticks([-0.6,-0.2,0.2,0.6,1])
xlim([5.8,16.2])

g(1) = axes('Position',[.55 .3 .3 .3]);
box on
plot(t_tof,median_woc,'o','Color','red')
hold on
plot(t_tof,median_wc, 'x', 'Color','red')
plot(t_tof,median_woc_ref,'o','Color','black')
plot(t_tof,median_wc_ref, 'x', 'Color','black')
ylim([0.8,0.95])
xlabel('$t\; (\rm ms)$', 'Interpreter','latex','FontSize',fontsize-2)
xticks([6,8,10,12,14,16])
set(g(1), 'FontSize', fontsize-2,'FontName', 'Times')
set(f(1), 'FontSize', fontsize,'FontName', 'Times')