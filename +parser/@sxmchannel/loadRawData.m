function loadRawData(sxmch)
% Get handle of the parent sxm object
sxm=sxmch.spm;
header=sxm.Header;

% Open the file
fid = fopen(sxm.Path, 'r', 'ieee-be');    % open with big-endian

%Set flags
eof=0;

% \1A\04 (hex) indicates beginning of binary data
s1 = [0 0];
while s1~=[26 4]
    s2 = fread(fid, 1, 'char');
    s1(1) = s1(2);
    s1(2) = s2;
end

% read the data
im_nr = sxmch.pos*2;
size = prod(header.scan_pixels)*4;   % 4 Bytes per pixel
fseek(fid, im_nr*size, 0);

pix = header.scan_pixels;
data = fread(fid, [pix(1) pix(2)], 'float');
data = transpose(data);

fclose(fid);


sxmch.rawData=data;
end