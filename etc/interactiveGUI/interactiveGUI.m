function filteredData=interactiveGUI(ch)
% Initialize GUI
f=figure;
ax=axes;
h=plot(ax,ch.Data0,'Tag','data');

% Set callback to create new selection box on axis and plot
set([ax,h],'ButtonDownFcn',@newSelectionBox);
% Set callback to react to keypress
set(f,'KeyPressFcn',@keyPress);

uiwait(f);

binaryMatrix = getappdata(f,'binaryMatrix');
filteredData = binaryMatrix;
close(f);
end