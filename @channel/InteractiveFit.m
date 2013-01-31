function nch=InteractiveFit(ch,varargin)
h=findobj(ch.spm.UserChannel,'Type','InteractiveFit','-and','ParentChannel',ch);

if ~isempty(h)
    nch = h;
    disp('From cache');
    ss = h.UserData;
    ss.draw;
    set(ss.Figure,'KeyPressFcn',@keyPress);
    uiwait(ss.Figure);
    nch.UserData = ss;
    disp('Done');
else
    nch = SPM.parser.userchannel;
    nch.Type = 'InteractiveFit';
    nch.ParentChannel=ch;
    nch.Name = [ch.Name ' | InteractiveFit session '];
    nch.Units = ch.Units;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    
    % Call interactive GUI
    ss=SPM.viewerModule.InteractiveFitGUI(ch,varargin{:});
    ss.draw;
    
    % Disp instructions
    set(ss.Figure,'KeyPressFcn',@keyPress);
    disp('Fit your stuff and press s when done');
    uiwait(ss.Figure);
    nch.UserData = ss;
    terminate;
    
end

    function keyPress(src,event)
        if strcmp(event.Character,'s')
            % Close the figure
            close(ss.Figure);
        end
    end

    function terminate
        % Append to spm object
        ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
        disp('Done');
    end
end