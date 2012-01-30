function selectBox(box)
unselectCurrentBox;
setappdata(gca,'selectedBox',box);
turnMarkers('on');
end