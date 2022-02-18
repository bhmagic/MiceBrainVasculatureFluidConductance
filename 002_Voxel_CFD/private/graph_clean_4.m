function node_to_remove_par = graph_clean_4(wierdNode_in_name_par,wierdNode_out_name_par,link_table_wierd_full_par)

connection_count = length(wierdNode_out_name_par);



switch connection_count
    case 0
        
        
        node_to_remove_par = sort([ wierdNode_in_name_par; wierdNode_out_name_par]);

    case 1
        
        
        node_to_remove_par = sort([ wierdNode_in_name_par; wierdNode_out_name_par]);
        
        
    case 2
        list = [wierdNode_in_name_par;wierdNode_out_name_par];
        name = find(list);
        out_name = name(ismember(list,wierdNode_out_name_par));
        [~, link_table_wierd_full_par(:,1)] = ismember(link_table_wierd_full_par(:,1),list);
        [~, link_table_wierd_full_par(:,2)] = ismember(link_table_wierd_full_par(:,2),list);
        temp_graph = graph(link_table_wierd_full_par(:,1),link_table_wierd_full_par(:,2));
        
        node_to_keep = shortestpath(temp_graph,out_name(1),out_name(2));
        node_to_keep = list(node_to_keep);
        
        node_to_remove_par = wierdNode_in_name_par(~ismember(wierdNode_in_name_par, node_to_keep));
        
    otherwise
        list = [wierdNode_in_name_par;wierdNode_out_name_par];
        name = find(list);
        out_name = name(ismember(list,wierdNode_out_name_par));
        [~, link_table_wierd_full_par(:,1)] = ismember(link_table_wierd_full_par(:,1),list);
        [~, link_table_wierd_full_par(:,2)] = ismember(link_table_wierd_full_par(:,2),list);
        temp_graph = graph(link_table_wierd_full_par(:,1),link_table_wierd_full_par(:,2));
        
        dist_list = distances(temp_graph,out_name);
        dist_list = sum(dist_list);
        [~, loc] = min(dist_list);
        
        node_to_keep = [];
        for ii = 1:length(out_name)
            node_to_keep = [node_to_keep, shortestpath(temp_graph,out_name(ii),loc)];
        end
        node_to_keep = list(node_to_keep');
        node_to_remove_par = wierdNode_in_name_par(~ismember(wierdNode_in_name_par, node_to_keep));
        
        
end
