function nch=Exclude(channel,name,varargin)
%Exclude Brings up a GUI to exclude data points
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','Exclude','-and','ParentChannel',ch,'-and','Parameters',name);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.parser.userchannel;
    nch.Type = 'Exclude';
    nch.Parameters = name;
    nch.ParentChannel=ch;
    nch.Name = [ch.Name ' | EXCLUDE: ' name];
    nch.Units = ch.Units;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    
    % Call interactive GUI
    v=SPM.viewerModule.spectrumSelection(ch,varargin{:});
    set(v.Figure,'Name','EXCLUDE DATA POINTS','NumberTitle','off');
    
    % Disp instructions
    set(v.Figure,'KeyPressFcn',@keyPress);
    disp('Select the data points you want to remove and press s when done');
    
    uiwait(v.Figure);
    terminate;
end

    function keyPress(src,event)
        if strcmp(event.Character,'s')
            % Close the figure
            close(v.Figure);
        end
    end

    function terminate
        % Compute new data
        bM=v.binaryMatrix;
        data=ch.Data;data(bM)=NaN;
        nch.setData(data);
        
        % Append to spm object
        ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
    end
end

