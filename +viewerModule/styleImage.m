function styleImage(v)
%% For convenience
fig = v.Figure;
ax = v.Axes;
hd = v.Handle;
ch = v.Channel;

%% Title
title(ax,ch.Name)
ch.Name

%% Axes size
set(ax,'Position',[0 0.05 1 0.9]);

%% Axes aspect ratio
%axis ij;
%axis equal;
axis image;
xreal=ch.spm.Height;
yreal=ch.spm.Width;
[x,y]=size(ch.Data);

%% Axes label

%nb_ticks=4;
%[m,n]=size(ch.Data);
%set(v.Axes,'visible','off');
set(v.Axes,'XTick',[],'YTick',[]);
%set(v.Axes,'XTick',0:m/nb_ticks:m,'XTickLabel',num2cell(0:floor(xreal/nb_ticks):xreal),'Visible','on');
%set(v.Axes,'YTick',0:n/nb_ticks:n,'YTickLabel',num2cell(0:floor(yreal/nb_ticks):yreal),'YDir','reverse');
%set(v.Axes,'CLimMode','auto');
%xlabel(v.Axes,ch.Units);
%ylabel(v.Axes,ch.Units);

%% Scale bar
[m,n]=size(ch.Data);
offset = 0.05 * m;
length = 0.5 * m;
l=line([offset offset+length],[n-offset n-offset],'Color','white','LineWidth',1);
t=text(offset+length/2,n-offset,[num2str(xreal/2) ' nm']);
set(t,'Color','white','FontName','Arial','FontSize',10,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','Bottom');

%% Colorbar
colormap(SPM.viewerModule.gold);
c_bar=colorbar('location','eastoutside');
set(c_bar,'YColor','black','XColor','black');

%set(get(c_bar,'YLabel'),'String',ch.Units);

%% Figure size
%width=512;
%height=512;
%set(fig,'Position',[0 0 width height]); % Size in pixels

%% Fonts
set(ax,'FontName','Helvetica','FontSize',12,'FontWeight','bold');

%% Vertical axis
%set(v.Axes,'CLim',[-5 5]);

%% Printing / saving
%dpi = 72;
%set(fig, 'paperposition', [0 0 width/dpi height/dpi]);
%set(fig, 'papersize', [width/dpi height/dpi]);

end