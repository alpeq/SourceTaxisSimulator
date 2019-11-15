function [FFMean, FFStd] = Fgaden2map(name, iteration, axesHandle)


sf = strcat(name,'_iteration_',iteration);   
a = load(sf);
%   x,y,z 
   %a(:,1)a(:,2)a(:,3)
% Gas_conc[10^⁻3ppm]	 Wind_u[10^⁻3m/s]	 Wind_v[10^⁻3m/s]	 Wind_w[10^⁻3m/s]
    % a(:,4)a(:,5)a(:,6)a(:,7)
zcut = a(a(:,3) == 14, :);      % The cut in volume
x = zcut(:,1);
y = zcut(:,2);
c = zcut(:,4); % concentration

xv = linspace(min(x), max(x));
yv = linspace(min(y), max(y));

[X,Y] = meshgrid(xv, yv);
Z = griddata(x,y,c,X,Y);


% Resize
nx=[-6 6];
ny=[0 24];
xv=linspace(nx(1),nx(2));
yv=linspace(ny(2),ny(1));
%Z(1:10,:) = 0;                      % Do we need to filter??
%Z(40:60,40:60) = Z(40:60,40:60)/1000;                      % Do we need to filter??

%map_mean = flipud(Z./max(max(Z)));
map_mean = Z./max(max(Z));
map_mean(isnan(map_mean)) = 0;      % Remove nans
map_std = 0.05 * ones(size(map_mean));

imagesc(axesHandle, xv,yv,map_mean)
%title('Gaden data')
%colormap default;   % set colormap
%tin=colorbar;
%title(tin,'Normalize Odorant');


%Interpolation already in the .mat
  [FFMean, FFStd] = create_interpFunc_out(map_mean, map_std, -6,6,0,24);

  
  
end