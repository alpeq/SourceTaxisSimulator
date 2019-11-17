function [] = cleanPlot_GUI(plotHandles)
% CLEANPLOT_GUI Deletes all the handlers 
% 
%   cleanPlot_GUI(plotHandles)
%   -> plotHandles: list of handlers to delete
%


for i=1:numel(plotHandles)
    delete(plotHandles(i));
end