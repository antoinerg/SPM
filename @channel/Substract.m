function nch=Substract(channel,och)
%Correct dissipation
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','Substract','-and','ParentChannel',ch,'UserObj',och);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    if isa(och,'SPM.channel');
        nch = SPM.parser.userchannel;
        nch.ParentChannel=ch;
        nch.UserObj = och;
        nch.Type = 'Substract';
        nch.Name = ['Difference between ' channel.Name ' and ' och.Name];
        nch.Units = ch.Units;
        nch.spm = ch.spm;
        nch.Direction = ch.Direction;
        nch.setData(ch.Data - och.Data);
        
        ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
    end
end
end

