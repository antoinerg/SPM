function nch=BaselineFit(ch,varargin)
h=findobj(ch.spm.UserChannel,'Type','ManualFit','-and','ParentChannel',ch);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.parser.userchannel;
    nch.Type = 'ManualFit';
    nch.ParentChannel=ch;
    nch.Name = [ch.Name ' | Manual fit'];
    nch.Units = ch.Units;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    
    % Call interactive GUI
    ss=SPM.viewerModule.ManualFitGUI(ch);
    ss.draw;
    set(ss.Figure,'Name','Manual fitting','NumberTitle','off');
    
    % Disp instructions
    set(ss.Figure,'KeyPressFcn',@keyPress);
    disp('Add points on plot and press s when done');
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
    end

    function terminate
        manual_fit=ss.corrected_data;
        if isempty(manual_fit)
            nch = ch;
            return;
        else
        nch.setData(manual_fit);
        
        % Append to spm object
        ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
        end
        disp('Done');
    end
end