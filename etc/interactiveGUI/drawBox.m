function drawBox(box)
% Draw box as long as 'coord' is set
coord = getappdata(box,'coord');

x1=coord(1,1);y1=coord(2,1);x2=coord(1,2);y2=coord(2,2);

% Draw the box
x = [x1 x1 x2 x2];
y = [y1 y2 y2 y1];
set(box,'XData',x,'YData',y,'Visible','on');
end