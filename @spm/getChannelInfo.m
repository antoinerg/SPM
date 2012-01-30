function getChannelInfo(spm)
%getChannlInfo outputs informations about the available channels
L=length(spm.Channel);
L1=length(spm.UserChannel);

if (L==0)
    disp('No channel loaded');
else
    disp('Available channels')
    for i=1:L
        fprintf('\t%i:  %s (%s) [%s]\n',i,spm.Channel(i).Name,spm.Channel(i).Units,spm.Channel(i).Direction);
    end
end

if (L1==0)
    disp('No userchannel available');
else
    disp('User channels')
    for i=1:L1
        fprintf('\t%i:  %s \n',i,spm.UserChannel(i).Name);
    end
end
end