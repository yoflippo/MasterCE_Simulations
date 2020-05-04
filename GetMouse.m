hfig = figure('pos',[100,100,300,300]);

global textBox;
textBox = uicontrol('parent',hfig,'style','text','string','Balance','pos',[40,14,200,90]);

t = timer('ExecutionMode', 'fixedRate', ...
    'Period', 0.01, ...
     'TimerFcn', @(~,~) set(textBox, 'string', sprintf('(X, Y) = (%g, %g)\n', get(0, 'PointerLocation'))) ...
    );
set(hfig, 'DeleteFcn', @(~,~) stop(t));
start(t);

%  https://nl.mathworks.com/matlabcentral/answers/331746-how-to-get-the-real-time-position-of-mouse-outside-matlab

function my_callback_fcn(obj, event, text_arg)
text_arg
global textBox;
set(textBox, 'string', sprintf('(X, Y) = (%g, %g)\n', text_arg));
end