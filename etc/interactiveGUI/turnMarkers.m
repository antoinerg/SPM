function turnMarkers(bool)
if isappdata(gca,'selectedBox');
    box=getappdata(gca,'selectedBox');
    if ~isempty(box)
        markers=getappdata(box,'Markers');
        set(markers,'Visible',bool);
    end
end
end