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
            %cov_matrix = zeros(obj.longitudinal_resolution, obj.longitudinal_resolution);
            
            %averaging phi(z)phi(z') over all the samples
            %for i = 1:obj.nmb_of_sampled_profiles
            %    for j = 1:obj.longitudinal_resolution
            %        for k =1:obj.longitudinal_resolution
            %            cov_matrix(j,k) = cov_matrix(j,k)+(phase_profile_matrix(i,j)-obj.average_phase_profile(j))*(phase_profile_matrix(i,k)-obj.average_phase_profile(k));
            %        end
            %    end
            %end

            %cov_matrix = (1/obj.nmb_of_sampled_profiles)*cov_matrix;
            %obj.cov_matrix = cov_matrix;

        end

        %Function to compute correlation function of any order
        function corr = correlation_func(obj, order, phase_profiles_data)
            if nargin<3
                phase_profiles_data = obj.all_phase_profiles;
            end
            data_size = size(phase_profiles_data, 2);
            num_profiles  = size(phase_profiles_data,1);
            
            %calculate all possible combination (and permutation)
            %of (z_1, z_2, ..., z_N) for N being the order
            combs = obj.nmultichoosek(1:data_size, order);
            for i = 1:size(combs,1)
                unique_perms = unique(perms(combs(i,:)),'rows');
                combs = [combs;unique_perms(2:end,:)];
            end
            
            %Computing the average of the product of the phases for each
            %possible (z_1, z_2, ..., z_N)
            for i = 1:size(combs,1)
                avg = 0;
                for j = 1:num_profiles
                    prod = 1;
                    for k = 1:order
                        prod = prod*phase_profiles_data(j,combs(i,k));
                    end
                    avg = avg+prod;
                end
                avg = avg/num_profiles;
                idx = num2cell(combs(i,:));
                corr(idx{:}) = avg;
             end
        end
    end

    methods (Static)
        %function to compute combination (with repetition)
        %Code from https://stackoverflow.com/questions/28284671/generating-all-combinations-with-repetition-using-matlab
        function combs = nmultichoosek(values, k)
            if numel(values)==1
                n = values;
                combs = nchoosek(n+k-1,k);
            else
                n = numel(values);
                combs = bsxfun(@minus, nchoosek(1:n+k-1,k), 0:k-1);
                combs = reshape(values(combs),[],k);
            end
        end
        
        
        %function to compute distance between inferred and reference
        %covariance matrix

        %Two-norm (largest singular values)
        function dist = two_norm_distance(reference_cov, inferred_cov)
            dist = norm(reference_cov-inferred_cov)/norm(reference_cov);
        end

        %trace norm
        function dist = trace_norm_distance(reference_cov, inferred_cov)
            dist = sum(svd(reference_cov - inferred_cov))/sum(svd(reference_cov));
        end

        %Frobenius norm
        function dist = frobenius_norm_distance(reference_cov, inferred_cov)
            dist = norm(reference_cov-inferred_cov, 'fro')/norm(reference_cov, 'fro');
        end
    end
end
            