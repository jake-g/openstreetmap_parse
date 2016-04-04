function [key_set, node_coor, clr] = parse_ways(key_set, node, way_nodes, tag)
% Look at tags and filter ways based off them

    %% Get tag key value pair
    %tags can be struct or cell of struct
    if isstruct(tag) == 1
        key = tag.Attributes.k;
        val = tag.Attributes.v;
    elseif iscell(tag) == 1 
        key = tag{1}.Attributes.k;
        val = tag{1}.Attributes.v;
    else
        %  disp('Way has NO tag.')
        key = ''; val = '';
    end
%     disp(key);  disp(val);

    %% Populate key_set
    if ~isempty(key)
        if isempty(find(ismember(key_set, key) == 1, 1)) % add if unique
            key_set(1, end+1) = {key};  % append 
        end
    end
    
    %% Filter
    % See ways_tags_list for properties
    switch key
        case 'highway'
            clr = 'b';
            %  disp(val)
        case 'access'
            clr = 'b';
        case 'access:lanes'
            clr = 'm';
        case 'area'
            clr = 'c';
        case '' % unknown
            clr = 'ignore';
        otherwise
            clr = 'ignore';
            % disp('way without tag.')
    end

    %% Get Node Coordindates
    n_nodes = size(way_nodes, 2);
    node_coor = zeros(2, n_nodes);
    for j=1:n_nodes
        cur_node = way_nodes(1, j);
        if ~isempty(node.xy(:, cur_node == node.id))
             node_coor(:, j) = node.xy(:, cur_node == node.id);
        end
    end
    node_coor(any(node_coor==0,2),:)=[]; % remove zeros
    
end

