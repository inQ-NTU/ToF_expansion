function w4 = wick_fourth(second_order_data)
    dim = size(second_order_data,1);
    w4 = zeros(dim, dim, dim, dim);
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    w4(i,j,k,l) = second_order_data(i,j)*second_order_data(k,l)+...
                        second_order_data(i,k)*second_order_data(j,l) +...
                        second_order_data(i,l)*second_order_data(j,k);
                end
            end
        end
    end

end