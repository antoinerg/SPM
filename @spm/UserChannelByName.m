function ch=UserChannelByName(sf,name)
%ChannelByName returns userchannel based on its name
    ch = findobj(sf.UserChannel,'Name',name);
    if isempty(ch)
        throw(MException('SPM:Not_found',['No UserChannels named ' name]));
end