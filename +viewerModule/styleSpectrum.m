function styleSpectrum(v)
%% For convenience
fig = v.Viewer.Figure;
ax = v.Axes;
hd = v.Handle;
ch = v.Channel;
xch = v.xChannel;

%% Title
title(ax,ch.Name)
ch.Name

%% Axes size
%set(ax,'Position',[0 0.05 1 0.9]);

%% Axes label

xlabel(v.Axes,xch.Units);
ylabel(v.Axes,ch.Units);

%% Figure size
width=800;
height=300;
set(fig,'Position',[0 0 width height]); % Size in pixels

%% Fonts
%set(ax,'FontName','Helvetica','FontSize',14,'FontWeight','bold');

%% Vertical axis
%set(v.Axes,'CLim',[-5 5]);

%% Printing / saving
%dpi = 72;
%set(fig, 'paperposition', [0 0 width/dpi height/dpi]);
%set(fig, 'papersize', [width/dpi height/dpi]);

end