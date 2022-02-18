
clear


mat_name = {
'20201013_HB_HB294_C57J-NIA_FITC-fill_F_18mo_optical';

};

poking_distance = 100;





for kk = 1: length(mat_name)
    
    clear loaded_data A_temp AAA
    mat_list = dir([mat_name{kk}, '*']);
    
    parfor jj = 1:length(mat_list)
        
        loaded_data{jj} = load([mat_list(jj).folder, '/',  mat_list(jj).name]);
        A_temp{jj} = cell2mat(loaded_data{jj}.the_tensor);
    end
    
    A_temp = reshape(A_temp,[1,1,1,length(A_temp)]);
    A_temp = cell2mat(A_temp);
    A_logic = logical(A_temp);
    A_logic = sum(A_logic,4);
    flag = A_logic > 1;
    check_overlap = nnz(flag(:));
    if check_overlap > 0
        error('data overlap');
    end
    
    A =  sum(A_temp,4);
    
    easy_list = ceil(loaded_data{1}.poking_point_list./poking_distance);
    poking_point_list = loaded_data{1}.poking_point_list;
    
    AA = zeros(1,size(A,3));
    tic
    parfor ll = 1:size(A,3)
        AA(ll) = shereical_integral(A(:,:,ll));
    end
    toc
    AAA = accumarray(easy_list,AA);

    figure();
    cmap = colormap;

    spacing = 6;
    x_plot = 5;
    for ii = spacing:spacing:size(AAA,3)

        
        subplot(ceil(size(AAA,3)./spacing./x_plot),x_plot,ii./spacing)
        imshow(AAA(:,:,ii)*20000,cmap,'InitialMagnification',4000 )
        
    end
    
    suptitle_none([mat_name{kk}, ' 4um ']);
    save(['accumulated_', mat_name{kk}, '.mat'], 'A', 'AA', 'AAA', 'easy_list', 'poking_point_list');
    
    
end