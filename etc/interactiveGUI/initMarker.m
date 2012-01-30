function initMarker(box)
for i=1:4
    m(i) = line('parent', gca,'Marker','s','MarkerEdgeColor','none', ...
        'MarkerFaceColor','k','MarkerSize',6,'ButtonDownFcn',@selectMarker,...
        'Tag',num2str(i),'Visible','off','Tag',num2str(i));
end
setappdata(box,'Markers',m);
drawMarker(box);
end