function convertRawData(nsch)
nsch.Data = nsch.rawData;

% Following Nanonis convention
if strcmpi(nsch.Direction,'Backward')
    nsch.Data = fliplr(nsch.Data);
end
if strcmpi(nsch.spm.Header.scan_dir,'up')
	nsch.Data = flipud(nsch.Data)
end
end

