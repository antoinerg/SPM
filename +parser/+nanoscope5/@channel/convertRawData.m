function convertRawData(n5ch)
switch n5ch.Name
    case 'Height'
        n5ch.Units='nm' ;
        finalscaling=(n5ch.scaling*n5ch.zsens)/(2^16);
    case 'Deflection'
        n5ch.Units='V';
        finalscaling=(n5ch.scaling)/(2^16);
    case 'Amplitude'
        n5ch.Units='V';
        finalscaling=(n5ch.scaling)/(2^16);
    case 'Phase'
        n5ch.Units='Degree';
        finalscaling=(n5ch.scaling)/(2^16);
    case 'Current'
        n5ch.Units='Current';
        finalscaling=(n5ch.scaling)/(2^16);
end;
n5ch.Data = flipud(finalscaling*n5ch.rawData); % Needed to have same orientation as on gwyddion
end