function convertRawData(nsch)
if strcmpi(nsch.Direction,'Backward')
    nsch.Data = fliplr(nsch.rawData);
else
    nsch.Data = nsch.rawData;
end
end


