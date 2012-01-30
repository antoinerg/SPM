function wbu_MoveSelectionBox(src,event)
set(gcf,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
box = getappdata(gca,'selectedBox');
drawMarker(box);
end