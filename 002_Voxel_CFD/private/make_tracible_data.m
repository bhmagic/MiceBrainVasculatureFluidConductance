function [link_graph_link, S_link, S_link_group, wierdNode, wierdNode_group] = make_tracible_data(S_skel,S_radii,CropSize)


[~,nh] = get_nh_save_memory(S_skel,CropSize);
distance_table = zeros(3,3,3);

distance_table(:,:,1) = [1.732, 1.414, 1.732; 1.414, 1, 1.414; 1.732, 1.414, 1.732];
distance_table(:,:,2) = [1.414, 1, 1.414; 1, 0, 1; 1.414, 1, 1.414];
distance_table(:,:,3) = [1.732, 1.414, 1.732; 1.414, 1, 1.414; 1.732, 1.414, 1.732];

distance_table = distance_table(:);

s_length = nh.*distance_table';
s_length = sum(s_length,2);
sum_nh_full = sum(nh,2);
S_link.name = find(sum_nh_full==3);

if length(S_link.name) < 100
    link_graph_link = [];
    S_link = [];
    S_link_group = [];
    wierdNode = [];
    wierdNode_group = [];
   return 
end

[S_link_link_table] = get_all_link_par(S_skel(S_link.name),CropSize);
S_link.group = grouping_remake(length(S_link.name), S_link_link_table);
clear S_link_link_table

S_link.group = S_link.name(S_link.group);
S_link_group.name = unique(S_link.group);

[~,idx] = ismember(S_link.group,S_link_group.name);
S_link_group.length = accumarray(idx,1);

Judging_length = 4;
badLinks = S_link_group.name(S_link_group.length<Judging_length);
badLinks_list = ismember( S_link.group,badLinks);
wierdNode.name = S_link.name(badLinks_list);
wierdNode.name = [find(sum_nh_full>3 | sum_nh_full <= 2 ); wierdNode.name ];
clear sum_nh_full badLinks
clear  S_link* badLinks_list

wierdNode.name = sort(wierdNode.name);

if isempty(wierdNode.name)
    link_graph_link = [];
    S_link = [];
    S_link_group = [];
    wierdNode = [];
    wierdNode_group = [];
   return 
end

[link_table_wierd] = get_all_link_par(S_skel(wierdNode.name),CropSize);
wierdNode.group = grouping_remake(length(wierdNode.name), link_table_wierd);
wierdNode.group = wierdNode.name(wierdNode.group);
clear link_table_wierd

logi = true(size(S_skel));
logi(wierdNode.name) = 0;
S_link.name = find(logi);
S_link.length = s_length(logi);

if isempty(S_link.name)
    link_graph_link = [];
    S_link = [];
    S_link_group = [];
    wierdNode = [];
    wierdNode_group = [];
   return 
end

[link_table_S_link] = get_all_link_par(S_skel(S_link.name),CropSize);
S_link.group = grouping_remake(length(S_link.name), link_table_S_link);
S_link.group = S_link.name(S_link.group);
clear link_table_S_link
[S_link_group.name,~,S_link.group_ic] = unique(S_link.group);
[wierdNode_group.name,~,wierdNode.group_ic] = unique(wierdNode.group);

[link_table_full] = get_all_link_par(S_skel,CropSize);
link_table_wierd_out = link_table_full(xor(ismember(link_table_full(:,1),wierdNode.name) , ismember(link_table_full(:,2),wierdNode.name)),:);
link_graph_link = zeros(size(link_table_wierd_out));

[logi,loca] = ismember(link_table_wierd_out,wierdNode.name);
[~,wierdNode.group_ic] = ismember(wierdNode.group,wierdNode_group.name);
link_graph_link(logi) = wierdNode.group_ic(loca(logi));

group_off_set = length(wierdNode_group.name);
[logi,loca] = ismember(link_table_wierd_out,S_link.name);
[~,S_link.group_ic] = ismember(S_link.group,S_link_group.name);
link_graph_link(logi) = S_link.group_ic(loca(logi))+group_off_set;


flag = link_graph_link(:,1)>link_graph_link(:,2);
link_graph_link(flag,:) = [link_graph_link(flag,2), link_graph_link(flag,1)];

S_link_group.ave_radii = accumarray(S_link.group_ic, S_radii(S_link.name), size(S_link_group.name), @mean);
S_link_group.sum_length = accumarray(S_link.group_ic, S_link.length, size(S_link_group.name), @sum)./2;

%wierdNode_group.ave_radii = accumarray(wierdNode.group_ic, S_radii(wierdNode.name), size(wierdNode_group.name), @mean);







