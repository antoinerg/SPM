function out=RMS(channel)
%removeBGdissipation Return custom channel with removed BG
ch=channel;

out=std(ch.Data(:));
end

