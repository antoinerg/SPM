function ss=InteractiveFit(channel,varargin)
% Call interactive GUI
ss=SPM.viewerModule.InteractiveFitGUI(channel,varargin{:});
ss.draw;

% Disp instructions
set(ss.Figure,'KeyPressFcn',@keyPress);
disp('Fit your stuff and press s when done');
uiwait(ss.Figure);
terminate;

    function keyPress(src,event)
        if strcmp(event.Character,'s')
            % Close the figure
            close(ss.Figure);
        end
    end

    function terminate
        disp('Done');
    end
end