classdef class_physical_parameters < handle
   
    properties
       % fundamental parameters
        m = 86.909*1.66054e-27; %mass of Rubidium atoms (kg)
        hbar = 1.054571817e-34; %reduced Planck constant (J s)
        kb = 1.380649e-23

        %setting up default condensate parameters, geometry, and tof
        max_longitudinal_density = 75e6; %peak longitudinal density 50 atoms per microns
        omega = 2*pi*2e3; %x oscillator frequencies - transverse (s^-1)
        scattering_length = 5.2e-9; %scattering length for interaction broadening
        
        %by default, we have a condensate of length 100 microns (in z-axis), separated
        %a distance 3 microns initially, and spread over x_{max} - x_{min} microns after
        %tof
        default_condensate_length = 100e-6;%100 microns
        x_min = -50e-6; 
        x_max = 50e-6;
        default_separation_distance = 3e-6; %3 microns
        default_expansion_time = 15e-3; %15 ms
        default_tunneling_strength_J = 0; %default tunnel coupling
        default_insitu_density = 'InverseParabola'
        
    end
    
end