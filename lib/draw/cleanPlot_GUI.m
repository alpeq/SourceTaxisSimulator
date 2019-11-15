function [] = cleanPlot_GUI(plotHandles)
% Due to representation with the images the input parameter is tipL and
% tipR which will be processed like the other way around


for i=1:numel(plotHandles)
    delete(plotHandles(i));
end