function nch=Offset(channel,offset)
%OFFSET Return custom channel with offset

ch=channel;
h=findobj(ch.spm.UserChannel,'Type','Offset','-and','ParentChannel',ch,'-and','Parameters',offset);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.format.userchannel;
    nch.ParentChannel=ch;
    nch.Type = 'Offset';
    nch.Name = [ch.Name ' | OFFSET (' num2str(offset) ')'];
    nch.Units = ch.Units;
    nch.Parameters = offset;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    nch.setData(computeOffset(ch.Data));
    
    ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
end

    function out=computeOffset(A)
        out=A+offset;
    end
end

