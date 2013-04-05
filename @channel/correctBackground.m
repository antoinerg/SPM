function nch=correctBackground(channel,ne)
%Correct dissipation
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','correctDissipation','-and','ParentChannel',ch,'UserObj',ne);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    if isa(ne,'SPM.channel');
        nch = SPM.parser.userchannel;
        nch.ParentChannel=ch;
        nch.UserObj = ne;
        nch.Type = 'correctBackground';
        nch.Name = [ch.Name 'with corrected background'];
        nch.Units = ch.Units;
        nch.spm = ch.spm;
        nch.Direction = ch.Direction;
        nch.setData((ch.Data./ne.Data-1));
        
        ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
    end
end
end

