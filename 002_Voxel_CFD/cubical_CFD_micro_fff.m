%function cubical_CFD_micro_function(mat_name)
%clear 
%mat_name = '20191212_UC_U504_C57J_FITC-fill_M_p67_optical.mat';


data_name = regexp(mat_name, '[\\/.]', 'split');
coreCount =22;
aa = parcluster
temp_folder = ['./matlab_cluster_', datestr(now,'yyyy-mm-dd-HH-MM-SS-FFF')];
mkdir(temp_folder);
aa.JobStorageLocation = temp_folder;
parpool(aa,coreCount ,'IdleTimeout',inf)

%[S_skel, S_radii, CropSize] = read_clean_skel(dir_root);
load(mat_name);
poking_size = [500, 500, 500];
poking_distance = 100;

[xxx,yyy,zzz] = ind2sub(CropSize,S_skel);


[X,Y,Z] = meshgrid(1:poking_distance:CropSize(1),1:poking_distance:CropSize(2),1:poking_distance:CropSize(3));

[Xi,Yi,Zi] = meshgrid(1:1:size(X,1),1:1:size(X,2),1:1:size(X,3));

total_poking = length(X(:));
%poking_point_list = zeros(total_poking,3);
poking_point_list = [X(:),Y(:),Z(:)];
easy_list = [Xi(:),Yi(:),Zi(:)];


the_tensor = zeros(3,3,total_poking);
the_tensor = num2cell(the_tensor,[1 2]);

the_vector = zeros(3,1,total_poking);
the_vector = num2cell(the_vector,[1 2]);



poking_group_size = 100;
poking_HPC_devider = 20;
total_HPC_poking_group = ceil(total_poking./poking_group_size);
HPC_poking_group_size = ceil(total_HPC_poking_group./poking_HPC_devider);

%HPC_poking_point = 1~20

starting_HPC = (HPC_poking_point-1).* HPC_poking_group_size ; 
if HPC_poking_point == 20
    ending_HPC = total_HPC_poking_group-1;
else
    ending_HPC = (HPC_poking_point).* HPC_poking_group_size -1; 
end



for jj = starting_HPC:ending_HPC
    tic
    starting_shift = jj.*poking_group_size ;
    ending = (jj+1).*poking_group_size;
    if jj == ceil(total_poking./poking_group_size)-1
        ending = total_poking;
    end
    
    for ii = 1:(ending - starting_shift)
        
        poking_point = poking_point_list(ii+starting_shift,:);
        
        flag = (floor((xxx-poking_point(1))./poking_size(1)) == 0) & ...
            (floor((yyy-poking_point(2))./poking_size(2)) == 0) & ...
            (floor((zzz-poking_point(3))./poking_size(3)) == 0);
        
        P_sk{ii} = S_skel(flag);
        P_radii{ii} = S_radii(flag);
        xyz_lower_upper{ii} = [poking_point(1), poking_point(1)+poking_size(1)-1;
            poking_point(2), poking_point(2)+poking_size(2)-1;
            poking_point(3), poking_point(3)+poking_size(3)-1]';
        
        
    end
    
    parfor ii = 1:(ending - starting_shift )
        
        [the_tensor{ii+starting_shift}, the_vector{ii+starting_shift}] = making_tensor_micro(P_sk{ii}, P_radii{ii}, CropSize, xyz_lower_upper{ii});
        
    end
    toc
end


save( [data_name{end-1},'_',num2str(HPC_poking_point,'%03d'), '_out.mat'],'the_tensor','the_vector', 'poking_point_list', 'easy_list', '-v7.3');
