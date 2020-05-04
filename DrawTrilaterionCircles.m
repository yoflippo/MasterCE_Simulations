function DrawTrilaterionCircles(xc,yc,r,namefig)
close all;
h=figure('WindowState','maximized','visible','off');
hold on;

%% # circles
cols = ["r:"; "g:"; "b:";]; global colcnt; colcnt = 1;
thick = linspace(8,2,length(xc));

for nCb = nchoosek(1:length(xc),2)' % binomial coeff combinations
    h_cir = circle(xc(nCb(1)),yc(nCb(1)),r(nCb(1)),cols(colcnt),thick(colcnt));
    h_cir = circle(xc(nCb(2)),yc(nCb(2)),r(nCb(2)),cols(colcnt),thick(colcnt));
    intersectionLineCircle(xc(nCb),yc(nCb),r(nCb),cols(colcnt),h_cir)
    colcnt = colcnt + 1;
end
axis equal; set(h,'Visible','on')

MatrixMiddle(xc,yc,r)
hold off;
pause(1)
if ~exist('namefig','var')
    namefig = mfilename;
end
saveTightFigure(gcf,[namefig '.png'])

%% END SCRIPT, Begin HelperFunctions
    function h = circle(x,y,rad,color,lineth)
        if not(exist('rad','var'))
            rad = 3;
        end
        if not(exist('lineth','var'))
            lw = 1;
        else
            lw = lineth;
        end
        
        p = 0:pi/100:2*pi;
        xcor = rad * cos(p) + x;
        ycor = rad * sin(p) + y;
        
        if not(exist('color','var'))
            1 = plot(xcor, ycor,'Linewidth',lw);
            plot(x,y,'+','Linewidth',lw,'MarkerSize',13);
        else
            tmpcolor = char(color);
            h = plot(xcor, ycor,tmpcolor(1),'Linewidth',lw);
            plot(x,y,[tmpcolor(1) '+'],'Linewidth',round(lw/2),'MarkerSize',15);
        end
    end

    function intersectionLineCircle(xc,yc,r,color,h)
        %% Subtract two equation which gives line
        x = xlim; x = linspace(x(1),x(2),length(h.XData));
        y = ((r(1)^2 - r(2)^2 - xc(1)^2 + xc(2)^2 - yc(1)^2 + yc(2)^2) - ((-2*xc(1) + 2*xc(2))*x))  / ((-2*yc(1) + 2*yc(2)));
        
        if ~exist('color','var')
            plot(x, y,'Linewidth',1);
        else
            plot(x, y,color,'Linewidth',2);
        end
    end

    function MatrixMiddle(xc,yc,r)
        A = [(-2*yc(1) + 2*yc(2)) (-2*xc(1) + 2*xc(2)) 1;
            (-2*yc(1) + 2*yc(3)) (-2*xc(1) + 2*xc(3)) 1;
            (-2*yc(3) + 2*yc(2)) (-2*xc(3) + 2*xc(2)) 1;];
        
        b = [r(1)^2 - r(2)^2 - xc(1)^2 + xc(2)^2 - yc(1)^2 + yc(2)^2 ...
            r(1)^2 - r(3)^2 - xc(1)^2 + xc(3)^2 - yc(1)^2 + yc(3)^2 ...
            r(3)^2 - r(2)^2 - xc(3)^2 + xc(2)^2 - yc(3)^2 + yc(2)^2]';
        
        y = A\b;
        plot(y(2),y(1),'k+','Linewidth',3,'MarkerSize',18);
    end


%% End Helperfunctions
end
