function deleteBox(src,event,box)
markers = getappdata(box{1},'Markers');
unselectCurrentBox;
delete(box{1},markers);
end