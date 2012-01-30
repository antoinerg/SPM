function ch=ChannelByName(sf,name)
%ChannelByName returns channel based on its name
    ch = findobj(sf.Channel,'Name',name);
end