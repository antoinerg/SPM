function cmenu=addFitMenu(cmenu,box)
% Fitting theory
fitmenu = uimenu(cmenu,'Label', 'Fit');
item = uimenu('Parent', fitmenu, 'Label','Classical regime','Callback',{@fitClassical,{box}});
end

function fitClassical(src,event,box)
    box=box{1};
    f = fittype('gauss1');
    
    h = findobj(gcf,'Type','Line','-and','Tag','data');
    ydata = get(h,'YData');
    xdata = get(h,'XData');
    
    setappdata(box,'fit',f);
    
    coord=getappdata(box,'coord');
    x1=floor(min(coord(1,:)));
    x2=ceil(max(coord(1,:)));
    y1=min(coord(2,:));
    y2=max(coord(2,:));
    
    outside=excludedata(xdata,ydata,'box',[x1 x2 y1 y2]);
    fit1 = fit(xdata',ydata',f,'Exclude',outside)

    line(x1:x2,feval(fit1,x1:x2),'Parent',gca,'color','red','linewidth',2);
end