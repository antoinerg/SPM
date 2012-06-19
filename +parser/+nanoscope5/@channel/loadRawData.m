function loadRawData(n5ch)
% Get handle of the parent sdf object
n5=n5ch.spm;
% Open the file
fid = fopen(n5.Path,'r');

%Set flags
eof=0;

rawData=[];
% Loop through the file
while (~eof)
    fseek(fid,n5ch.pos,-1); 
    rawData = fread(fid, [n5.PointsPerLine n5.Lines],'int16');
    eof=1;
end
fclose(fid);

n5ch.rawData=rawData';
end