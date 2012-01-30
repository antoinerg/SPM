function wbu_MoveMarker(src,event)
box = getappdata(gca,'selectedBox');
drawMarker(box);
turnMarkers('on');
set(gcf,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
end