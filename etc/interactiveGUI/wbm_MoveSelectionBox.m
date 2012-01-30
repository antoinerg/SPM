function wbm_MoveSelectionBox(src,event)
box = getappdata(gca,'selectedBox');
coord = getappdata(box,'coord');
oldPos = getappdata(gca,'oldPos');
p1=get(gca,'CurrentPoint');p1=p1(1,1:2); % get current position
setappdata(gca,'oldPos',p1); % set as the new position
delta=p1-oldPos; % Get delta from last position
coord=coord+repmat(delta',1,2); % Update the coord
setappdata(box,'coord',coord); % Save the coord
drawBox(box); % Draw the box at its new position
end