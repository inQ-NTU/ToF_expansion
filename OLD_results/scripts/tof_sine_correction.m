%Delta TOF - sine term
        function delta_rho_tof = tof_sine_correction(obj, relative_phase)
            if nargin < 2
                relative_phase = obj.get_relative_phase_profile;
            end
            %resolution
            res = length(obj.input_grid_z);

            %longitudinal expansion length scale
            l = sqrt(obj.hbar*obj.expansion_time/(2*obj.m));
            
            %derivative of phase profile
            grad_rel_phase = gradient(relative_phase,obj.condensate_length_Lz/res);
            grad2_rel_phase = gradient(grad_rel_phase,obj.condensate_length_Lz/res);
            
            root_longitudinal_density = zeros(1,res);

            %longitudinal density
            for j = obj.nmb_buffer_points_z+1:length(obj.input_grid_z)+obj.nmb_buffer_points_z
                root_longitudinal_density(j) = sqrt(obj.longitudinal_density(obj.output_grid_z(j)));
            end
            grad_root_density = gradient(root_longitudinal_density,obj.condensate_length_Lz/res);
            grad2_root_density = gradient(grad_root_density, obj.condensate_length_Lz/res);


            %Gamma and Pi functions
            gamma_func = grad2_root_density - root_longitudinal_density.*((grad_rel_phase).^2)/4;
            pi_func = grad_root_density.*grad_rel_phase + (root_longitudinal_density.*grad2_rel_phase)/2;
            
            delta_rho_tof = zeros(length(obj.output_grid_z), length(obj.output_grid_x));
            for j = obj.nmb_buffer_points_z+1:length(obj.input_grid_z)+obj.nmb_buffer_points_z
                %delta_rho_tof(j,:) = (l^4)*gamma_func(j)*pi_func(j)*obj.transversal_density_avg_squared ...
                %.*sin(relative_phase(j-obj.nmb_buffer_points_z)+ obj.phase_shift_d_x_t ) ;
                delta_rho_tof(j,:) = obj.transversal_density_avg_squared.*sin(relative_phase(j-obj.nmb_buffer_points_z)+ obj.phase_shift_d_x_t ) ;
            end
        end