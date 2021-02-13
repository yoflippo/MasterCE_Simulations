function UKF_plot_results_for_thesis(ts,clean,position,UKFout,velocity,add2title)
figure('units','normalized','outerposition',[0.1 0.1 0.8 0.8])
if not(exist('add2title','var'))
    add2title = '';
else
    add2title = [add2title ' '];
end
nOutput = length(UKFout);

idxPosX = 1;
idxPosY = 2;
idxAngRate = 4;
idxVelRes = 6;
idxAngles = 3;

% plot(position.x, position.y,'r', 'LineWidth', 2,'LineStyle','--','DisplayName','disturbed signal'); hold on;
plot(clean.position.x, clean.position.y,'g', 'LineWidth', 2,'DisplayName','ground truth'); hold on;
plot(UKFout(:, idxPosX), UKFout(:, idxPosY),'Color',[0 0 1],'LineWidth', 2,'DisplayName','UKF result');
grid on; grid minor; legend
axis equal;
axis tight;
title([add2title])
exportgraphics(gcf,['example_offseting_' replace(add2title,' ','') '.png'],'BackgroundColor','none');