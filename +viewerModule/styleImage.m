function styleImage(v)
%% For convenience
fig = v.Viewer.Figure;
ax = v.Axes;
hd = v.Handle;
ch = v.Channel;

%% Axes size
set(ax,'Position',[0 0 1 1]);

%% Axes aspect ratio
axis ij;
axis square;
xreal=ch.spm.Height;
yreal=ch.spm.Width;
[x,y]=size(ch.Data);

%% Axes label

%nb_ticks=4;
%[m,n]=size(ch.Data);
set(v.Axes,'visible','off');
%set(v.Axes,'XTick',0:m/nb_ticks:m,'XTickLabel',num2cell(0:floor(xreal/nb_ticks):xreal),'Visible','on');
%set(v.Axes,'YTick',0:n/nb_ticks:n,'YTickLabel',num2cell(0:floor(yreal/nb_ticks):yreal),'YDir','reverse');
%set(v.Axes,'CLimMode','auto');
%xlabel(v.Axes,ch.Units);

%% Colorbar
colormap(SPM.viewerModule.gold);
c_bar=colorbar('location','east');
set(c_bar,'YColor','white','XColor','white');

%% Figure size
width=x;
height=y;
set(fig,'Position',[0 0 width height]); % Size in pixels

%% Fonts
set(ax,'FontName','Arial','FontSize',12,'FontWeight','bold');

%% Vertical axis
set(v.Axes,'CLim',[-5 5]);

%% Printing / saving
dpi = 72;
set(fig, 'paperposition', [0 0 width/dpi height/dpi]);
set(fig, 'papersize', [width/dpi height/dpi]);

end