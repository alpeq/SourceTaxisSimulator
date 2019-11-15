%% Import data from text file.
% Script for importing data from the following text file:
%
%    /home/alejandro/Projects/croaches/croachesOscillator/SourceSeekerSimulator/dataU_sim10.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2019/07/09 15:12:19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize variables.
filename = '/home/alejandro/Projects/croaches/croachesOscillator/SourceSeekerSimulator/lib/Maps/mapsFromCFD/dataU_sim10.csv';
delimiter = ',';
startRow = 2;

%% Format for each line of text:
%   column10: double (%f)
%	column11: double (%f)
%   column12: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%*q%*q%*q%*q%*q%*q%*q%*q%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
dataUsim10 = table(dataArray{1:end-1}, 'VariableNames', {'Points3','Points4','Unormxy'});

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


x=dataUsim10.Points3;
y=dataUsim10.Points4;
z=dataUsim10.Unormxy;

% figure(1)
% stem3(x, y, z)
% grid on


%Remove nozzle from the map 
CUT = 12;
a = (y<CUT); % -12 to 12 in the map
x = x(a);
y = y(a);
z = z(a);

% -12, 12 to 0,24
y = abs(y - CUT);

xv = linspace(min(x), max(x), 100);
yv = linspace(min(y), max(y), 100);
[X,Y] = meshgrid(xv, yv);
Z = griddata(x,y,z,X,Y);

map_mean = Z./max(max(Z));
figure()
    imh = imagesc(x,y,map_mean); %flip 
    colormap default;   % set colormap
    tin=colorbar;
    title(tin,'Normalize Odorant');
    hold on
    
    
map_std = 0.05 * ones(size(map_mean));            % 1% of std deviation correspond to 1 in std normal value
save('odormap1_CFD_long.mat','map_mean', 'map_std')

    

% figure()
% surf(X, Y, Z);
% grid on
% set(gca, 'ZLim',[0 100])
% shading interp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%