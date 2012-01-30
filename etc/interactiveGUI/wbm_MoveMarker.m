function wbm_MoveMarker(src,event)
box = getappdata(gca,'selectedBox');
selectedMarker = getappdata(gca,'selectedMarker');
p1=get(gca,'CurrentPoint');p1=p1(1,1:2); % get current position
oldPos=getappdata(gca,'oldPos'); % get old position
setappdata(gca,'oldPos',p1); % set old position
delta=p1-oldPos; % Get delta from last position
coord = getappdata(box,'coord');

i=get(selectedMarker,'Tag');
switch i
    case '1'
        coord(1) = coord(1) + delta(1);
    case '2'
        coord(4) = coord(4) + delta(2);
    case '3'
        coord(3) = coord(3) + delta(1);
    case '4'
        coord(2) = coord(2) + delta(2);
end

setappdata(box,'coord',coord);
drawBox(box);
end