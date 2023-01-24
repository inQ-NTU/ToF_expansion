classdef class_1d_correlation
    
    properties

        %input
        all_phase_profiles

        %inferred
        average_phase_profile
        longitudinal_resolution
        nmb_of_sampled_profiles

        %output
        cov_matrix

    end
    
    methods
        
        %implementing the constructor
        function obj = class_1d_correlation(phase_profile_matrix)
            obj.all_phase_profiles = phase_profile_matrix;
            obj.longitudinal_resolution = size(phase_profile_matrix,2);
            obj.nmb_of_sampled_profiles = size(phase_profile_matrix, 1);
            
            %calculating average phase profile - generally in our
            %simulation we set the average phase to be zero at every point,
            %but in this class, we do not assume that
            avg_phase_profile = zeros(1,obj.longitudinal_resolution);
            for i = 1:obj.nmb_of_sampled_profiles
                for j = 1:obj.longitudinal_resolution
                    avg_phase_profile(j) = avg_phase_profile(j)+phase_profile_matrix(i,j);           
                end
            end
            avg_phase_profile = (1/obj.nmb_of_sampled_profiles)*avg_phase_profile;
            obj.average_phase_profile = avg_phase_profile;

            %calculating covariance matrix
            cov_matrix = zeros(obj.longitudinal_resolution, obj.longitudinal_resolution);
            
            %averaging phi(z)phi(z') over all the samples
            for i = 1:obj.nmb_of_sampled_profiles
                for j = 1:obj.longitudinal_resolution
                    for k =1:obj.longitudinal_resolution
                        cov_matrix(j,k) = cov_matrix(j,k)+(phase_profile_matrix(i,j)-obj.average_phase_profile(j))*(phase_profile_matrix(i,k)-obj.average_phase_profile(k));
                    end
                end
            end

            cov_matrix = (1/obj.nmb_of_sampled_profiles)*cov_matrix;
            obj.cov_matrix = cov_matrix;

        end
    end

    methods (Static)
        %function to compute distance between inferred and reference
        %covariance matrix

        %Two-norm (largest singular values)
        function dist = two_norm_distance(reference_cov, inferred_cov)
            dist = norm(reference_cov-inferred_cov)/norm(reference_cov);
        end

        %Frobenius norm
        function dist = frobenius_norm_distance(reference_cov, inferred_cov)
            dist = norm(reference_cov-inferred_cov, 'fro')/norm(reference_cov, 'fro');
        end
    
    
    end
end
            