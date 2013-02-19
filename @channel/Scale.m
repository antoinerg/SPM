function nch=Scale(channel,factor)
%OFFSET Return custom channel with offset

ch=channel;
h=findobj(ch.spm.UserChannel,'Type','Scale','-and','ParentChannel',ch,'-and','Parameters',factor);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.parser.userchannel;
    nch.ParentChannel=ch;
    nch.Type = 'Scale';
    nch.Name = [ch.Name ' | Scaled by (' num2str(factor) ')'];
    nch.Units = ch.Units;
    nch.Parameters = factor;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    nch.setData(computeOffset(ch.Data));
    
    ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
end

    function out=computeOffset(A)
        out=A*factor;
    end
end

