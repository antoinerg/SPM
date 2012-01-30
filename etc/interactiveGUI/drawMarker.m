function drawMarker(box)
coord = getappdata(box,'coord');
markers = getappdata(box,'Markers');
x1=coord(1,1);x2=coord(1,2);y1=coord(2,1);y2=coord(2,2);
mxy(1,:)=[x1,(y1+y2)/2];
mxy(2,:)=[(x1+x2)/2,y2];
mxy(3,:)=[x2,(y1+y2)/2];
mxy(4,:)=[(x1+x2)/2,y1];

for i=1:4
    set(markers(i),'XData',mxy(i,1),'YData',mxy(i,2),'Visible','on');
end
end