function sS=InteractiveFit(channel,varargin)
% Call interactive GUI
sS=SPM.viewerModule.spectrumSelection(channel,varargin);

%% FITTING MODELS

fitModelList = 'polynomial|classical|f(1-f)';

    function setFitModel(id)
        box = sS.selectedBox;
        ydata=sS.Channel.Data';
        xdata=sS.xChannel.Data';
        
        [x1 x2 y1 y2]=box.coord;
        
        outside1=excludedata(xdata,ydata,'box',[x1 x2 y1 y2]);
        outside2=excludedata(xdata,ydata,'indices',find(isnan(ydata)));
        outside = outside1|outside2;
        
        switch id
            case 1
                fitType=fittype('poly2');
                fitOptions=fitoptions(fitType);
                %fitObj = fit(xdata,ydata,fitType,'Exclude',outside);
            case 2
                % MAPLE
                q=sym('q');alpha=sym('alpha');Vo=sym('Vo');kb=sym('kb');T=sym('T');x=sym('x');
                c=sym('c');omega0=sym('omega0');gamma=sym('gamma');k0=sym('k0');
                omega0=164744;
                q=1.602176565E-19;
                kb=1.3806488E-23;
                k0=40;
                T=4;
                fermi=1/(exp(q*alpha*(x-Vo)/(kb*T))+1);
                A=-c*x*(1-alpha);
                eqn=omega0^2*A^2*gamma/(k0*kb*T)*(1/(omega0^2+gamma^2))*fermi*(1-fermi);
                
                % Fittype object
                fitType=fittype(sym2str(eqn));      
                
                % Guess initial values
                [c,i]=max(ydata(~outside));
                xpeak=xdata(~outside);xpeak=xpeak(i);
                fitOptions = fitoptions(fitType);
                fitOptions.Startpoint=[xpeak 0.01 3e-8 3e-6];
                fitOptions.Lower=[-10 0 0 0];
                fitOptions.Upper=[10 1 1e-4 1e-4];
                fitOptions.Robust='on';
                
            case 3
                a=sym('a');b=sym('b');c=sym('c');x=sym('x');
                fermi=1/(exp(a*(x-b))+1);
                eqn=c*fermi*(1-fermi);
                
                fitType=fittype(sym2str(eqn));
                fitOptions=fitoptions(fitType);
        end
        box.UserData.fitModel = id;
        box.UserData.fitType = fitType;
        box.UserData.fitOptions = fitOptions;
    end

%% PANEL

%Set Figure size
set(sS.Figure,'Units','Pixels','Position',[0,0,1200,400]);

%Preview Panel
previewPanel=uipanel(sS.Figure,'Title','Preview','Position',[.25 0 0.75 1],...
    'ResizeFcn',@resizePreviewPanel);
set(sS.Axes,'Parent',previewPanel);
%set(sS.Axes,'Position',[0 0 1 1]);

% Fit panel
fitPanel=uipanel(sS.Figure,'Title','Fit information','Position',[0 0 0.25 1],...
    'ResizeFcn',@resizeFitPanel);
widthFitPanel=200;

% Resize panel
resizeFitPanel;resizePreviewPanel;

    function resizeFitPanel(src,evt)
        set(fitPanel,'Units','pixel');fitPanelPos=get(fitPanel,'Position');
        newpos=[0 0 widthFitPanel fitPanelPos(4)]; set(fitPanel,'Position',newpos);
        set(fitPanel,'Units','normalized');fitPanelPos=get(fitPanel,'Position');
        
        
    end
    function resizePreviewPanel(src,evt)
        fitPanelPos=get(fitPanel,'Position');
        newpos=[fitPanelPos(3) 0 1-fitPanelPos(3) 1];
        set(previewPanel,'Position',newpos);
    end



%% COMPONENTS
width=180;
left=10;
bottom=300;
height=20;
textbox=uicontrol('Parent',fitPanel,'Style','text','String','Select fitting model',...
    'Units','Pixels','Position',[left bottom width height],'HorizontalAlignment','left',...
    'FontSize',12);
height=20;bottom=bottom-height;
fitMenu=uicontrol('Parent',fitPanel,'Style','popupmenu','Units','Pixels',...
    'Position',[left bottom width height],'String',fitModelList,'Callback',@changeFitModel);
height=360;bottom=bottom-height-10;
infobox=uicontrol('Parent',fitPanel,'Style','text','String','',...
    'Units','Pixels','Position',[left bottom width height],'HorizontalAlignment','left');

% Delete backward scan for now as we don't have a clean way of dealing with
% it
delete(sS.Line(2));

%% USER INTERACTION

% React to user interaction with the selection boxes
addlistener(sS,'selectionBoxInitialized',@boxInitialized);
addlistener(sS,'selectionBoxChanged',@boxChanged);
addlistener(sS,'selectionBoxDeleted',@boxDeleted);
addlistener(sS,'selectionBoxSelected',@boxSelected);

% Callback
    function changeFitModel(src,evt)
        box=sS.selectedBox;
        setFitModel(get(src,'Value'));
        notify(sS,'selectionBoxChanged');
    end

    function changeStartPoint(src,evt,i)
        box=sS.selectedBox;
        newsPoint=str2num(get(src,'String'));
        box.UserData.fitOptions.StartPoint(i)=newsPoint;
        notify(sS,'selectionBoxChanged');
    end

    function boxChanged(s,e)
        box=sS.selectedBox;
        delete(box.UserData.fitLine);
        fitData;
    end

    function boxSelected(s,e)
        % box=sS.selectedBox;
        % f=box.UserData.fit;
        display;
    end

    function boxDeleted(s,e)
        box=sS.selectedBox;
        delete(box.UserData.fitLine);
    end

    function boxInitialized(s,e)
        % box = sS.selectedBox;
        % addprop(box,'fit');
        % addprop(box,'fitLine');
        box=sS.selectedBox;
        setFitModel(get(fitMenu,'Value'));
        fitData;
    end

%% FITTING AND DISPLAY

    function fitData
        box = sS.selectedBox;
        ydata=sS.Channel.Data';
        xdata=sS.xChannel.Data';
        
        [x1 x2 y1 y2]=box.coord;
        
        outside1=excludedata(xdata,ydata,'box',[x1 x2 y1 y2]);
        outside2=excludedata(xdata,ydata,'indices',find(isnan(ydata)));
        outside = outside1|outside2;
        
        fitOptions = fitoptions(box.UserData.fitOptions,'Exclude',outside);
        box.UserData.fit = fit(xdata,ydata,box.UserData.fitType,fitOptions);
        
        % Plot the resulting fit line in the interval of the box
        xdata=sS.xChannel.Data';[x1 x2 y1 y2]=box.coord;
        range=xdata(xdata>x1 & xdata<x2);
        box.UserData.fitLine=line(range,feval(box.UserData.fit,range),'Parent',sS.Axes,'color','r',...
            'linewidth',2,'HitTest','off');
        
        display;
    end

    function display
        box = sS.selectedBox;
        % Update the fitMenu
        set(fitMenu,'Value',box.UserData.fitModel);
        
        % Build the lower, startpoint, higher boxes
        coeff=coeffnames(box.UserData.fitType);
        LowerPoint=box.UserData.fitOptions.Lower;
        sPoint=box.UserData.fitOptions.Startpoint;
        UpperPoint=box.UserData.fitOptions.Upper;
        left=0;bottom=0;width=50;height=20;
        for i=1:length(coeff)
            uicontrol('Parent',fitPanel,'Style','text','String',coeff{i},...
    'Units','Pixels','Position',[left bottom+i*(height) width height],'HorizontalAlignment','left',...
    'FontSize',12);
            lowerBox=uicontrol('Parent',fitPanel,'Style','edit','Units','Pixels',...
                'Position',[left+width bottom+i*(height) width height],'String',LowerPoint(i)...
                );
            startBox=uicontrol('Parent',fitPanel,'Style','edit','Units','Pixels',...
                'Position',[left+2*width bottom+i*(height) width height],'String',sPoint(i),...
                'Callback',{@changeStartPoint,i});
            endBox=uicontrol('Parent',fitPanel,'Style','edit','Units','Pixels',...
                'Position',[left+3*width bottom+i*(height) width height],'String',UpperPoint(i)...
                );
        end
        
        
        % Update the information box to display current box's fit
        str={};
        str=vertcat(str,'EQUATION:');
        eqn = formula(box.UserData.fit);
        str=vertcat(str,eqn);
        
        str=vertcat(str,'COEFFICIENTS:');
        coeff=coeffnames(box.UserData.fit);
        values=coeffvalues(box.UserData.fit);
        for i=1:length(coeff)
            str=vertcat(str,[coeff{i} ' = ' num2str(values(i))]);
        end
        
        set(infobox,'String',str);
    end
end

