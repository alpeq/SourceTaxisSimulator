function [FMean, FStd] = create_interpFunc_out(map_mean, map_std, xmin, xmax, ymin, ymax)
 % It is important to have same real distance between the x and y axis
 % otherwise the representation is not accurate think in an ellipsoid
 % instead of a circle
 
    res = map_mean./max(max(map_mean));
    std = map_std;

    x=linspace(xmin,xmax,size(res,2)); % Original 2,-3
    y=linspace(ymin,ymax,size(res,1));
    [X, Y] = meshgrid(x,y);

    vX = reshape(X.', [], 1);
    vY = reshape(Y.', [], 1);
    vMean = reshape(res.', [], 1);
    vStd = reshape(std.', [], 1);

    % figure(1)
    % stem3(vX,vY,vMean,'^','fill')
    % title('Raw Data')
    % 
    % figure(2)
    % Z = griddata(vX,vY,vMean,X,Y);
    % surf(X,Y,Z);
    % title('Raw Data')

    % First Interpolation square distance neighbours 100x100 'natural'
    FMean = scatteredInterpolant(vX,vY,vMean);
    FStd = scatteredInterpolant(vX,vY,vStd);

    % Example
    % [XFine,YFine]= meshgrid(linspace(5.5,-6.5),linspace(0,12));
    % Vq = FMean(XFine,YFine);
    % figure(3)
    % surf(XFine,YFine,Vq);
    % title('Mean interpolated plot')
    % 
    % Vq = FStd(XFine,YFine);
    % figure(4)
    % surf(XFine,YFine,Vq);
    % title('Deviation interpolated plot')

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Interpolation of 1d for angle representation %

    %x = 1:-2/(numel(theta3l)-1):-1
    %interp1(x,theta3l,0.9,'nearest');
    % Be carefull of the non defined points
end