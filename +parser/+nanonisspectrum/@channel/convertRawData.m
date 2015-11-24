function convertRawData(nsch)
% Backward data is saved in an misleading way. We need to flip the data for backward scan to make sure they are associated with the right bias value
if strcmp(nsch.Direction,'Backward')
	nsch.Data = fliplr(nsch.rawData)
else
	nsch.Data = nsch.rawData;
end
end
