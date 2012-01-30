function clickSelectionBox(src,event)
box = src; % Box that triggedred the callback
selectedBox=getappdata(gca,'selectedBox'); % Current selected box
if selectedBox==box % Drag
    %coord = getappdata(box,'coord');
    p1=get(gca,'CurrentPoint');p1=p1(1,1:2); % button down detected
    setappdata(gca,'oldPos',p1);
    turnMarkers('off');
    set(gcf,'WindowButtonMotionFcn',@wbm_MoveSelectionBox,...
        'WindowButtonUpFcn',@wbu_MoveSelectionBox);
else % Select the box
    selectBox(box);
end
end