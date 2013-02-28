function nch=substractFit(channel,fitmodel)
%Substract given fit from a channel
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','substractFit','-and','ParentChannel',ch);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    if isa(fitmodel,'SPM.viewerModule.InteractiveFitModel.AbstractFitModel');
        nch = SPM.parser.userchannel;
        nch.ParentChannel=ch;
        nch.UserObj = fitmodel;
        nch.Type = 'substractFit';
        nch.Name = [ch.Name ' | substractedFit'];
        nch.Units = ch.Units;
        nch.spm = ch.spm;
        nch.Direction = ch.Direction;
        data=ch.Data - feval(fitmodel.fit,fitmodel.Box.Parent.xChannel.Data)';
        nch.setData(data);
        
       ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
    end
end
end

