function [the_tensor, the_vector] = making_tensor_micro(P_sk, P_radii, CropSize, xyz_lower_upper)
cutting = 4.0;

[xxx,yyy,zzz] = ind2sub(CropSize,P_sk);
P_xyz = [xxx,yyy,zzz];
clear xxx yyy zzz

if length(P_sk) < 100
    the_tensor = zeros(3,3);
    the_vector = zeros(3,1);
    return   
end



% grouping skeleton points into node and links
[P_link_graph_link, P_link, P_link_group, P_wierdNode, ~] = make_tracible_data(P_sk, P_radii, CropSize);

if length(P_link_graph_link)<100
    the_tensor = zeros(3,3);
    the_vector = zeros(3,1);
    return   
end

new_P_link = P_link.name(ismember(P_link.group_ic,find(P_link_group.ave_radii < cutting)));
flag = ismember(find(P_sk),[new_P_link; P_wierdNode.name]);
P_sk = P_sk(flag);
P_radii = P_radii(flag);
P_xyz = P_xyz(flag,:);


[P_link_graph_link, ~, P_link_group, P_wierdNode, P_wierdNode_group] = make_tracible_data(P_sk, P_radii, CropSize);



if length(P_link_graph_link)<100
    the_tensor = zeros(3,3);
    the_vector = zeros(3,1);
    return   
end

% find nodes on the walls
equal_lower = P_xyz == xyz_lower_upper(1,:);
equal_lower =[equal_lower, P_xyz == xyz_lower_upper(2,:)];
wall_tag = zeros(size(P_sk));
for ii = 1:6
    wall_tag(equal_lower(:,ii)) = ii;
end

P_wierdNode_group.wall_tag = zeros(size(P_wierdNode_group.name));
for ii = 1:6
    P_wierdNode_group.wall_tag(ismember(P_wierdNode_group.name,P_wierdNode.group(wall_tag(P_wierdNode.name) == ii))) = ii;
end

% building the array for the conservation of mass
Linear_array = zeros(length(P_wierdNode_group.name),length(P_wierdNode_group.name));

indddd = sub2ind(size(Linear_array),find(P_wierdNode_group.wall_tag ~= 0),find(P_wierdNode_group.wall_tag ~= 0));
Linear_array(indddd) = 1;

smaller_node = accumarray(P_link_graph_link(:,2),P_link_graph_link(:,1),[],@min);
bigger_node = accumarray(P_link_graph_link(:,2),P_link_graph_link(:,1),[],@max);


offset_t = length(P_wierdNode_group.name);
P_link_group.node_table = [ smaller_node(offset_t+1:end), bigger_node(offset_t+1:end)];


smaller_node = smaller_node(offset_t+1:end);
bigger_node = bigger_node(offset_t+1:end);
flag = smaller_node ~= bigger_node;

%mark singularities
bad_node = grouping_remake(length(P_wierdNode_group.name), P_link_group.node_table(flag,:));
bad_node = ismember(bad_node , bad_node(P_wierdNode_group.wall_tag ~= 0));



self_array_s = accumarray([smaller_node(flag),smaller_node(flag)],-P_link_group.ave_radii(flag).^4./P_link_group.sum_length(flag),size(Linear_array));
self_array_b = accumarray([bigger_node(flag),bigger_node(flag)],-P_link_group.ave_radii(flag).^4./P_link_group.sum_length(flag),size(Linear_array));
project_array_s = accumarray([smaller_node(flag),bigger_node(flag)],P_link_group.ave_radii(flag).^4./P_link_group.sum_length(flag),size(Linear_array));
project_array_b = accumarray([bigger_node(flag),smaller_node(flag)],P_link_group.ave_radii(flag).^4./P_link_group.sum_length(flag),size(Linear_array));



self_array = self_array_s + self_array_b + project_array_s + project_array_b;
wall_array = self_array(P_wierdNode_group.wall_tag ~= 0,:);
self_array(P_wierdNode_group.wall_tag ~= 0,:) = 0;

Linear_array = Linear_array + self_array;
Linear_array(~bad_node, :) = 0;

indddd = sub2ind(size(Linear_array),find(sum(logical(Linear_array),2)==0),find(sum(logical(Linear_array),2)==0));
Linear_array(indddd) = 1;

clear wall_flow P_link_group_flow

%{
%building array for checking flow rate
flow_array = zeros(length(P_link_group.name),offset_t);
flow_array = accumarray([find(flag),smaller_node(flag)],-P_link_group.ave_radii(flag).^4./P_link_group.sum_length(flag),size(flow_array));
flow_array = flow_array + accumarray([find(flag),bigger_node(flag)],P_link_group.ave_radii(flag).^4./P_link_group.sum_length(flag),size(flow_array));
%}

figure()

for dimention_working_on = 1:3
    
    dimention_span(dimention_working_on) = xyz_lower_upper(2,dimention_working_on) - xyz_lower_upper(1,dimention_working_on);
    RHS = zeros(length(P_wierdNode_group.name),1);
    
    wall_p = (P_xyz(P_wierdNode_group.name(P_wierdNode_group.wall_tag ~= 0),dimention_working_on) - xyz_lower_upper(1,dimention_working_on)) ./ dimention_span(dimention_working_on);
    RHS(P_wierdNode_group.wall_tag ~= 0) = wall_p;
    
    P_wierdNode_group.node_p = mldivide(Linear_array,RHS);

    wall_flow(:,dimention_working_on) = wall_array*P_wierdNode_group.node_p;
    
    %{
    %plot pressure
    P_link_group.pressure = zeros(size(P_link_group.name));
    P_link_group.pressure(flag) = (P_wierdNode_group.node_p(P_link_group.node_table(flag,1))+P_wierdNode_group.node_p(P_link_group.node_table(flag,2)))./2;
    subplot(2,3,dimention_working_on)
    P_link_pressure = P_link_group.pressure(P_link.group_ic);
    scatter3(P_xyz(P_link.name,1),P_xyz(P_link.name,2),P_xyz(P_link.name,3),P_radii(P_link.name).*4,P_link_pressure,'filled');
    axis equal
    
    
    %plot flow
    P_link_group_flow(:,dimention_working_on) = abs(flow_array*P_wierdNode_group.node_p);
    P_link_flow = P_link_group_flow(P_link.group_ic,dimention_working_on);
    subplot(2,3,dimention_working_on+3)
    scatter3(P_xyz(P_link.name,1),P_xyz(P_link.name,2),P_xyz(P_link.name,3),P_radii(P_link.name).*4,P_link_flow.^0.5,'filled');
    axis equal
    %}
end

clear the_tensor
block_volume = dimention_span(1).*dimention_span(2).*dimention_span(3);
for ii = 1:3
    for jj = 1:3
        halfway_point = dimention_span(ii)./2 + xyz_lower_upper(1,ii);
        flag2 = P_xyz(P_wierdNode_group.name(P_wierdNode_group.wall_tag ~= 0),ii) > halfway_point;
        the_tensor(ii,jj) = -sum(wall_flow(flag2,jj)) ./ block_volume .* dimention_span(ii) .* dimention_span(jj);
    end
end


the_vector = sum(the_tensor.^2,2).^0.5;




























