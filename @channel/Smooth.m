function nch=Smooth(channel,varargin)
%removeBGdissipation Return custom channel with removed BG
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','Smooth','-and','ParentChannel',ch,'-and','Parameters',varargin);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.parser.userchannel;
    nch.Type = 'Smooth';
    nch.Parameters = varargin;
    nch.ParentChannel=ch;
    nch.Name = [ch.Name ' | SMOOTHED'];
    nch.Units = ch.Units;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    
    nch.setData(compute(ch.Data));
        
    ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
end

    function out=compute(A)
        out=smooth(A,varargin{:})';
    end
end

