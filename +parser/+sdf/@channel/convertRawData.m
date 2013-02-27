function convertRawData(sfchannel)
% Convert to real values using Mehdi's SDFReader java code
n10range=sfchannel.n1-sfchannel.n0;
dm=n10range/2^32;

data = convert(sfchannel.rawData);
if strcmpii(sfchannel.Direction,'Backward')
    sfchannel.Data = fliplr(data);
else
    sfchannel.Data = data;
end

    function out=convert(data)
        minus=bitshift(abs(data),-31);
        result=-minus.*(2^32-data)+(1-minus).*data;
        data=sfchannel.n0+(result+2^31).*dm;
        out=flipud(data);
    end
end


