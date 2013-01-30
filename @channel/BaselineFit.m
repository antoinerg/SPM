function nch=BaselineFit(ch,varargin)
h=findobj(ch.spm.UserChannel,'Type','BaselineFit','-and','ParentChannel',ch);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.parser.userchannel;
    nch.Type = 'BaselineFit';
    nch.ParentChannel=ch;
    nch.Name = [ch.Name ' | Subtracted baseline '];
    nch.Units = ch.Units;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    
    % Call interactive GUI
    ss=SPM.viewerModule.BaselineFitGUI(ch);
    ss.draw;
    set(ss.Figure,'Name','Baseline fitting','NumberTitle','off');
    
    % Disp instructions
    set(ss.Figure,'KeyPressFcn',@keyPress);
    disp('Add points on baseline and press s when done');
    uiwait(ss.Figure);
    terminate;  
end

    function keyPress(src,event)
        if strcmp(event.Character,'s')
            % Close the figure
            close(ss.Figure);
        end
    end

    function terminate
        baseline_fit=ss.corrected_data;
        nch.setData(ch.Data./baseline_fit-1);
        
        % Append to spm object
        ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
        disp('Done');
    end
end