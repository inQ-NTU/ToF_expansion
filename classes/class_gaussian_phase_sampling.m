classdef class_gaussian_phase_sampling < class_physical_parameters
    
    properties
        
        %Basic stats
        covariance_matrix
        mean_vector
        nmb_longitudinal_points
        nmb_sampled_profles
        phase_profiles

        %convolution
        convolution_scale
    end
    
    methods
    
    %1. Implement the constructor   
    function obj = class_gaussian_phase_sampling(cov_matrix, convolution_sigma, mean_vector)
        
        if issymmetric(cov_matrix)
            obj.covariance_matrix = cov_matrix;
        else
            obj.covariance_matrix = (cov_matrix+cov_matrix')/2;
        end
        
        obj.nmb_longitudinal_points = size(cov_matrix, 1);
        
        if nargin < 2
            obj.convolution_scale = obj.default_1d_conv_scale; %default convolution scale
        else
            obj.convolution_scale = convolution_sigma;
        end

        if nargin < 3
            obj.mean_vector = zeros(1, obj.nmb_longitudinal_points);
        else
            obj.mean_vector = mean_vector;
        end
    end

    %2. Convolving the phase profile
    function conv_profile = convolution_1d(obj, phase_profile, convolution_scale)
        if nargin < 3
            convolution_scale = obj.convolution_scale;
        end
        sigma = convolution_scale * obj.nmb_longitudinal_points;
        S = obj.convolution_matrix(sigma, obj.nmb_longitudinal_points);
        conv_profile = (S*phase_profile')';
    end

    %3. Generating phase profile samples
    function samples = generate_profiles(obj, nmb_of_samples)
        if nargin < 2
            nmb_of_samples = 1;
        end
        samples = mvnrnd(obj.mean_vector, obj.covariance_matrix, nmb_of_samples);
        for i = 1:nmb_of_samples
            samples(i,:) = obj.convolution_1d(samples(i,:));
        end
        obj.phase_profiles = samples;
        obj.nmb_sampled_profles = nmb_of_samples; 
    end

    %4. Coarse-graining phase profile
    function coarse_profile = coarse_grain(obj, target_longitudinal_points, profile)
            if nargin < 3
                profile = obj.phase_profiles;
            end
            [Z] = ndgrid(1:obj.nmb_longitudinal_points)';
            nmb_samples = size(profile,1);
            coarse_profile = zeros(nmb_samples,target_longitudinal_points);
            
            for i = 1:nmb_samples
                profile_interpolant = griddedInterpolant(Z,profile(i,:));
                coarse_profile(i,:) = profile_interpolant(linspace(1,obj.nmb_longitudinal_points, target_longitudinal_points));
            end
    end
    
    %5. Referencing phase profile (to remove zero mode)
    %Set the phase in the middle of the condensate to be zero
    function referenced_profile = reference_profiles(obj, profile)
        if nargin < 2
            profile = obj.phase_profiles;
        end
        res = size(profile, 2);
        for i = 1:obj.nmb_sampled_profles
            if rem(res, 2) == 0
                profile(i,:) = profile(i,:) - (profile(i,res/2) + profile(i,res/2+1))/2;
            elseif rem(res,2) == 1
                profile(i,:) = profile(i,:) - profile(i,ceil(res/2));  
            end
        end
        referenced_profile = profile;
    end
    
    %end methods
    end

    methods (Static)
        %1D convolution matrix
        
        function S = convolution_matrix( sigma, nmb_grid_points)
            % Calculates the convolution matrix
            S = zeros( nmb_grid_points );
            for x = 1:nmb_grid_points
                S( x, : ) = exp( - (  (1:nmb_grid_points) - x ).^2 / (2 * sigma^2) );
            end
            %normalising the convolution matrix
            for x = 1:nmb_grid_points
                norm = sum( S(x,:));
                S( x, : ) = S( x,: ) / norm;
            end
        end
   end
    
    
end