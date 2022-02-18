function [S_skel,S_radii,length_node_to_remove_par] = Skeketon_clean_up_1(S_skel, S_radii,CropSize,Judging_length)



tic

%%% isolate segments (S_link) and nasty skeletons (wierdNode)
[sum_nh_full] = get_all_sum_nh_par(S_skel,CropSize);
S_link.name = find(sum_nh_full==3);
[S_link_link_table] = get_all_link_par(S_skel(S_link.name),CropSize);

S_link.group = grouping_remake(length(S_link.name), S_link_link_table);
clear S_link_link_table

S_link.group = S_link.name(S_link.group);
S_link_group.name = unique(S_link.group);
S_link_group.length = histc(S_link.group,S_link_group.name);

badLinks = S_link_group.name(S_link_group.length<Judging_length);



removal = ismember( S_link.group,badLinks);
clear badLinks

wierdNode.name = S_link.name(removal);
wierdNode.name = [find(sum_nh_full>3 | sum_nh_full <= 2 ); wierdNode.name ];
clear sum_nh_full

clear S_link*

wierdNode.name = sort(wierdNode.name);


%fprintf('Group and map the connectivity of the problematic nodes \n');


%%% group and map the connectivity of the problematic nodes


[link_table_wierd] = get_all_link_par(S_skel(wierdNode.name),CropSize);
wierdNode.group = grouping_remake(length(wierdNode.name), link_table_wierd);
wierdNode.group = wierdNode.name(wierdNode.group);
clear link_table_wierd


[wierdNode_group.name] = unique(wierdNode.group);

[link_table_full] = get_all_link_par(S_skel,CropSize);

link_table_wierd_out = link_table_full(xor(ismember(link_table_full(:,1),wierdNode.name) , ismember(link_table_full(:,2),wierdNode.name)),:);
link_table_wierd_full = link_table_full(ismember(link_table_full(:,1),wierdNode.name) | ismember(link_table_full(:,2),wierdNode.name),:);
clear link_table_full



lia1 = ismember(link_table_wierd_out(:,1),wierdNode.name);
lia2 = ismember(link_table_wierd_out(:,2),wierdNode.name);


node_wierd_out_in = zeros(length(link_table_wierd_out),1);
node_wierd_out_out = zeros(length(link_table_wierd_out),1);
node_wierd_out_out(lia1) = link_table_wierd_out(lia1,2);
node_wierd_out_out(lia2) = link_table_wierd_out(lia2,1);
node_wierd_out_in(lia1) = link_table_wierd_out(lia1,1);
node_wierd_out_in(lia2) = link_table_wierd_out(lia2,2);

[~, loc] = ismember(node_wierd_out_in,wierdNode.name);

node_wierd_out_group = wierdNode.group(loc);

clear lia1 lia2 loc link_table_wierd_out node_wierd_out_in
link_wierd_full_group = zeros(size(link_table_wierd_full,1),1);
[lia, loc] = ismember(link_table_wierd_full(:,1),wierdNode.name);
link_wierd_full_group(lia) = wierdNode.group(loc(lia));
[lia, loc] = ismember(link_table_wierd_full(:,2),wierdNode.name);
link_wierd_full_group(lia) = wierdNode.group(loc(lia));

clear lia loc









%%% Clean up #1
%fprintf('Cleaning Up  \n');




temp_w = [wierdNode.name, wierdNode.group];
temp_w = sortrows(temp_w,2);
[~,loc] = ismember(temp_w(:,2), wierdNode_group.name);
binsize = histcounts(loc,[0; find(wierdNode_group.name)]+0.5);

wierdNode_in_name_par = mat2cell(temp_w(:,1),binsize);



temp_w = [node_wierd_out_out, node_wierd_out_group];
temp_w = sortrows(temp_w,2);
[~,loc] = ismember(temp_w(:,2), wierdNode_group.name);
binsize = histcounts(loc,[0; find(wierdNode_group.name)]+0.5);

wierdNode_out_name_par = mat2cell(temp_w(:,1),binsize);



temp_w = [link_table_wierd_full, link_wierd_full_group];
temp_w = sortrows(temp_w,3);
[~,loc] = ismember(temp_w(:,3), wierdNode_group.name);
binsize = histcounts(loc,[0; find(wierdNode_group.name)]+0.5);

link_table_wierd_full_par = mat2cell(temp_w(:,1:2),binsize);
connection_count = zeros(size(wierdNode_group.name));

for ii = 1:length(wierdNode_group.name)
    connection_count(ii) = length(wierdNode_out_name_par{ii});
end
fprintf(['Isolated short segments count: ' num2str(sum(connection_count(:) == 0))  ' \n' ]);
fprintf(['Single connected short segments count: ' num2str(sum(connection_count(:) == 1))  ' \n' ]);
fprintf(['2x connected short segments count: ' num2str(sum(connection_count(:) == 2))  ' \n' ]);
fprintf(['3x connected pile count: ' num2str(sum(connection_count(:) == 3))  ' \n' ]);
fprintf(['4x connected pile count: ' num2str(sum(connection_count(:) == 4))  ' \n' ]);
fprintf(['>=5x connected pile count: ' num2str(sum(connection_count(:) >=5 ))  ' \n' ]);



clear node_to_remove_par
node_to_remove_par{length(wierdNode_group.name)} = [];

%if Judging_length>5000
%    parfor ii = 1:length(wierdNode_group.name)
%        node_to_remove_par{ii} = graph_clean_3(wierdNode_in_name_par{ii},wierdNode_out_name_par{ii},link_table_wierd_full_par{ii});
%    end
    
%else
    parfor ii = 1:length(wierdNode_group.name)
        node_to_remove_par{ii} = graph_clean(wierdNode_in_name_par{ii},wierdNode_out_name_par{ii},link_table_wierd_full_par{ii});
    end
%end
node_to_remove_par = cell2mat(node_to_remove_par');


S_skel(node_to_remove_par) = [];
S_radii(node_to_remove_par) = [];

toc

length_node_to_remove_par = length(node_to_remove_par);
fprintf( [num2str(length_node_to_remove_par) ' skeleton points removed  \n']);



