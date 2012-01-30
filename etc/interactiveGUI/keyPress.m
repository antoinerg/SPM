function keyPress(src,event)
if strcmp(event.Character,'q')
    disp('Filtering');
    
    selectionBoxes = findall(gcf,'Type','patch','-and','Tag','selectionBox');
    NBoxes=length(selectionBoxes);
    
    h = findobj(gcf,'Type','Line','-and','Tag','data');
    ydata = get(h,'YData');
    [m,n]=size(ydata);
    binaryMatrix=ones(m,n);
    
    for i=1:NBoxes
        x=get(selectionBoxes(i),'XData');
        y=get(selectionBoxes(i),'YData');
        
        x1=floor(min(x));
        x2=ceil(max(x));
        y1=min(y);
        y2=max(y);
        id=find(ydata(x1:x2) > y1 & ydata(x1:x2) < y2);
        binaryMatrix(x1+id)=NaN;
    end
    setappdata(gcf,'binaryMatrix',binaryMatrix);
    disp('Done');
    uiresume(gcf);
end
end