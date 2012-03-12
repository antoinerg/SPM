function nch=correctDissipation(channel,ne)
%Correct dissipation
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','correctDissipation','-and','ParentChannel',ch);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    if isa(ne,'SPM.channel');
        nch = SPM.parser.userchannel;
        nch.ParentChannel=ch;
        nch.Parameters = ne;
        nch.Type = 'correctDissipation';
        nch.Name = 'correctedDissipation';
        nch.Units = ch.Units;
        nch.spm = ch.spm;
        nch.Direction = ch.Direction;
        nch.setData((ch.Data./ne.Data-1));
        
        ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
    end
end
end

