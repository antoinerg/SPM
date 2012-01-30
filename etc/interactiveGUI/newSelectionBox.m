function newSelectionBox(src,event)
p1=get(gca,'CurrentPoint'); p1=p1(1,1:2); % button down detected
rbbox;
p2=get(gca,'CurrentPoint');p2=p2(1,1:2);  %button up detected

% Instantiate a box object
box = patch('FaceColor','r','FaceAlpha',0.2,'LineStyle','--',...
    'Parent',gca,'Visible','off','Tag','selectionBox');
set(box,'ButtonDownFcn',@clickSelectionBox);

% Save the coords [x1,x2;y1,y2] on the box object and draw
setappdata(box,'coord',[p1(1),p2(1);p1(2),p2(2)]);
drawBox(box);

initMarker(box); % Draw markers

% Make the new box current
selectBox(box);

% Add a contextual menu
cmenu = uicontextmenu;
item = uimenu(cmenu, 'Label','Delete', 'Callback', {@deleteBox,{box}});

% Add application-specific menu
cmenu=addFitMenu(cmenu,box);

set(box,'uicontextmenu',cmenu);
end