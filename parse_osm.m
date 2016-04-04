function [parsed_osm] = parse_osm(osm_xml)
%PARSE_OSM  Parse into a structure a loaded OSM XML structure.
%
%   parsed_osm = matlab structure parsed into the primatives
%
%   data primitives (from docs)
%       1) nodes
%           id (unique between nodes)
%           lat \in [-90, 90] (latitude)
%           lon \in [-180, 180] (longitude)
%           ele (elevation  = altitude - optional)
%           tags
%       2) ways    (& closed ways = areas)
%           id
%           nodes (node ids)
%           tags
%       3) relations
%           members
%           tags (k=v)
%           Attributes


%% Get bounding box
bounds = osm_xml.bounds.Attributes;
ymax = str2double(bounds.maxlat);
xmax = str2double(bounds.maxlon);
ymin = str2double(bounds.minlat);
xmin = str2double(bounds.minlon);
parsed_osm.bounds = [xmin, xmax; ymin, ymax];


%% Parse Node
n_nodes = size(osm_xml.node, 2);
id = zeros(1, n_nodes); 
xy = zeros(2, n_nodes);
h = waitbar(0,'Parsing Nodes...');

for i=1:n_nodes
    id(1,i) = str2double(osm_xml.node{i}.Attributes.id);
    xy(:,i) = [str2double(osm_xml.node{i}.Attributes.lon);...
               str2double(osm_xml.node{i}.Attributes.lat)];
    waitbar(i/n_nodes)
end
close(h)
parsed_osm.node.id = id;
parsed_osm.node.xy = xy;


%% Parse Ways
n_ways = size(osm_xml.way,2);
id = zeros(1, n_ways);
nd = cell(1, n_ways);
tag = cell(1, n_ways);
h = waitbar(0,'Parsing Ways...');

for i=1:n_ways
    waytemp = osm_xml.way{i};
    
    id(1,i) = str2double(waytemp.Attributes.id);
    
    n_nodes = size(waytemp.nd, 2);
    ndtemp = zeros(1, n_nodes);
    
    for j=1:n_nodes
        if n_nodes == 1
            ndtemp(1,j) = str2double(waytemp.nd.Attributes.ref);
        else
            ndtemp(1, j) = str2double(waytemp.nd{j}.Attributes.ref);
        end
    end
    
    nd{1, i} = ndtemp;
    
    % way with or without tag(s) ?
    if isfield(waytemp, 'tag')
        tag{1, i} = waytemp.tag;
    else
        tag{1, i} = []; % no tags for this way
    end
    waitbar(i/n_ways)
end
close(h)
parsed_osm.way.id = id;
parsed_osm.way.nd = nd;
parsed_osm.way.tag = tag;


%% Parse Relation
parsed_osm.relation = []; % dont need?
% n_relation = size(osm.relation, 2);
% 
% id = zeros(1,n_relation);
% %member = cell(1, Nrelation);
% %tag = cell(1, Nrelation);
% h = waitbar(0,'Parsing Relations...');
% for i = 1:n_relation
%     currelation = osm.relation{i};
%     
%     curid = currelation.Attributes.id;
%     id(1, i) = str2double(curid);
%     waitbar(i/n_relation)
% end
% close(h)
% 
% parsed_osm.relation.id = id;



