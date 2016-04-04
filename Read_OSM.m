%% DEMO
% download an OpenStreetMap XML Data file (extension .osm) from the
% OpenStreetMap website (press export): http://www.openstreetmap.org/
% Zoom to area of interest and click Exports, save in maps/ as *.osm
%clear all; close all; clc
set(0,'DefaultFigureWindowStyle','docked')

filename = 'all_seattle.osm';
path = 'maps/';
%% Convert osm XML -> matlab struct
map_osm = xml2structure([path filename]); % downloaded osm file
osm_xml = map_osm.osm; % matlab structure of XML osm file
parsed_osm = parse_osm(osm_xml);  % $$$ Money

%% Properties
bounds = parsed_osm.bounds; 
nodes = parsed_osm.node;
ways = parsed_osm.way;      
% relations = parsed_osm.relation;

%% Display Info
disp( ['Bounds: xmin = ' num2str(bounds(1,1)), ', xmax = ', num2str(bounds(1,2)),...
        ', ymin = ', num2str(bounds(2,1)), ', ymax = ', num2str(bounds(2,2)) ] )
disp( ['Number of nodes: ' num2str(size(nodes.id, 2))] )
disp( ['Number of ways: ' num2str(size(ways.id, 2))] )

%% Plots
% Parameters
figure
ax = gca; hold(ax, 'on')
xlabel(ax, 'Longitude'); ylabel(ax, 'Latitude')
xlim(bounds(1,:)); ylim(bounds(2,:));
title(ax, 'OSM FIle')

% Border
plot(ax, [bounds(1,1), bounds(1,1), bounds(1,2), bounds(1,2), bounds(1,1)],...
         [bounds(2,1), bounds(2,2), bounds(2,2), bounds(2,1), bounds(2,1)],...
         'ro-')
% All nodes
% plot(nodes.xy(1,:), nodes.xy(2,:), 'g.')

% Itereate ways and append plot
key_set = {};
for i=1:size(ways.id, 2) % for each way
    % Parse and filter ways based off tag
    tag = ways.tag{1,i};
    way_nodes = ways.nd{1, i};
    [key_set, node_coor, clr] = parse_ways(key_set, nodes, way_nodes, tag);
    % Append to plot
    if ~isempty(node_coor) 
        if ~strcmp(clr, 'ignore')
            plot(ax, node_coor(1,:), node_coor(2,:), clr)
        end
    end
end  
disp(key_set.')

    
    
    
    
    
    
    
    
%% find connectivity
% [connectivity_matrix, intersection_node_indices] = extract_connectivity(parsed_osm);
% [uniquend] = get_unique_node_xy(parsed_osm, intersection_node_indices);
