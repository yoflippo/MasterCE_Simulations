function [XYclean,XYrotated] = createWMPMdata(t)
if isequal(nargout,0) && not(exist('t','var'))
    t = 0:1/100:10;
end

R = getRotationMatrixZ(60);
R = R(2:end,2:end);

maxX = 4500;
maxY = 10000;
[x,y] = eightshape_with_variation(t,maxX,maxY);

XYclean = [x; y];
XYrotated = R*XYclean;
XYrotated = addGradualRotation(XYrotated);
XYrotated = addOffset(XYrotated);
XYrotated = addSomeVariation(XYrotated);

if isequal(nargout,0)
    close all;
    plot(x,y,'b','DisplayName','Original data'); hold on;
    plot(XYrotated(1,:),XYrotated(2,:),'r','DisplayName','Gradual rotated');
    grid on; grid minor; legend;
    title('Simulated WMPM data');
end

    function [xy] = addGradualRotation(xy)
        Rot = getRotationMatrixZ(0.05); Rot = Rot(2:end,2:end);
        for nS = 1:length(xy)
            xy(:,nS:end) = Rot*xy(:,nS:end);
        end
    end

    function xy = addOffset(xy)
        xy = [xy(1,:)+5000; xy(2,:)+200;];
    end

    function xy = addSomeVariation(xy)
        x1 = xy(1,:); y1 = xy(2,:);
        factor = 5;
        xuwb = x1 + factor*randn(size(x1));
        yuwb = y1 + factor*randn(size(y1));
        xy = [xuwb; yuwb];
    end

end