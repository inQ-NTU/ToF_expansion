classdef class_physical_parameters < handle
   
    properties
        % fundamental parameters
        c = 3e8; %speed of light
        m = (85.4678*931.494e6)/(3e8*3e8); %mass of Rubidium atoms (eV s^2/m^2)
        hbar = 6.5821e-16; %reduced Planck constant (eV s)

        %setting up default condensate parameters, geometry, and tof
        max_longitudinal_density = 100e6; %peak longitudinal density 100 atoms per microns
        omega = 4000; %x oscillator frequencies - transverse (s^-1)
        
        %by default, we have a condensate of length 100 microns, separated
        %a distance 3 microns initially, and spread over 120 microns after
        %tof
        x_min = -60e-6; 
        x_max = 60e-6;
        default_condensate_length = 100e-6;
        default_separation_distance = 3e-6; 
        default_expansion_time = 15.6e-3;
        
        %default convolution scale
        default_1d_conv_scale = 0.003;
        default_2d_conv_scale = 0.03; 
        
    end
    
end