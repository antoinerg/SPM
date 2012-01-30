function selectMarker(src,event)
box = getappdata(gca,'selectedBox');
setappdata(gca,'selectedMarker',src);
turnMarkers('off');
p1=get(gca,'CurrentPoint');p1=p1(1,1:2); % get current position
setappdata(gca,'oldPos',p1); % set old position
set(gcf,'WindowButtonMotionFcn',@wbm_MoveMarker,...
    'WindowButtonUpFcn',@wbu_MoveMarker);

end