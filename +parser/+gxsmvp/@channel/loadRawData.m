function loadRawData(vpch)
% Get handle of the parent object
vp=vpch.spm;
% Open the file
fid = fopen(vp.Path,'r');

% Set flags
eof=0;
i=1;

pos=vpch.pos;
rawData=zeros(vp.NPoints,1);

myHeader = '#C Index';

while(~eof)
    line=fgets(fid);
    if (strfind(line,myHeader));
        line=fgets(fid);
        while(line(1) ~= '#')
            myNums=str2num(line);
            rawData(i)=myNums(pos);
            i=i+1;
            line=fgets(fid);
        end
        break;
    end
	if( (-1)==line ), eof  = 1; end % End of file condition
end
fclose(fid);
vpch.rawData=rawData;
end
