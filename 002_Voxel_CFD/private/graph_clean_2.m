function node_to_remove_par = graph_clean_2(wierdNode_in_name_par,wierdNode_out_name_par,~,~)

connection_count = length(wierdNode_out_name_par);



switch connection_count
    case 0
        
        
            node_to_remove_par = [];
        
    case 1
        
        
        node_to_remove_par = sort([ wierdNode_in_name_par; wierdNode_out_name_par]);
        
        
    case 2
        node_to_remove_par = [];
        
        
    otherwise
        
        node_to_remove_par = [];
        
        
end
