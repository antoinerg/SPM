function nch=InteractiveFit(ch,varargin)
h=findobj(ch.spm.UserChannel,'Type','InteractiveFit','-and','ParentChannel',ch);

if ~isempty(h)
    nch = h;
    disp('From cache');
    ss = h.UserObj;
    ss.draw;
    set(ss.Figure,'KeyPressFcn',@keyPress);
    uiwait(ss.Figure);
    update;
    disp('Done');
else
    nch = SPM.parser.userchannel;
    nch.Type = 'InteractiveFit';
    nch.ParentChannel=ch;
    nch.Name = [ch.Name ' | InteractiveFit session'];
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
    update;
    terminate;
    
end

    function keyPress(src,event)
        if strcmp(event.Character,'s')
            % Close the figure
            close(ss.Figure);
        end
    end

    function update
       nch.UserObj = ss;
       nch.UserData.Fit = [];
       for i=1:length(ss.selectionBox)
           nch.UserData.Fit = cat(1,nch.UserData.Fit,ss.selectionBox(i).UserData.fitModel.summary);
       end
    end

    function terminate
        % Append to spm object
        if ~isempty(nch.UserData.Fit)
            ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
        end
        disp('Done');
    end
end