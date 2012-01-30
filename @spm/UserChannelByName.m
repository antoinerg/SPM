function ch=UserChannelByName(sf,name)
%ChannelByName returns userchannel based on its name
    ch = findobj(sf.UserChannel,'Name',name);
end