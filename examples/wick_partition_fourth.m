function wick_fourth = wick_partition_fourth(second_order_data)
    dim = size(second_order_data,1);
    wick_fourth = zeros(dim, dim, dim, dim);
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    wick_fourth(i,j,k,l) = second_order_data(i,j)*second_order_data(k,l)+...
                        second_order_data(i,k)*second_order_data(j,l) +...
                        second_order_data(i,l)*second_order_data(j,k);
                end
            end
        end
    end

end