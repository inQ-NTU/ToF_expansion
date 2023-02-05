nmb_repetitions = 100;
fidelity = zeros(1,nmb_repetitions);
count = 0;
for i = 1:nmb_repetitions
    methods_section;
    fidelity(i) = extraction_suite.fidelity_coh(coarse_phase_profile(1,:), final_phase);
    count = count+1;
    disp(count)
end
disp(mean(fidelity))
disp(std(fidelity))