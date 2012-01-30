function sS=InteractiveFitGUI(channel,varargin)
% Call interactive GUI
sS=SPM.viewerModule.spectrumSelection(channel,varargin);

%% FITTING MODELS
fitModelList = {'fermi' 'polynomial' };

    function setFitModel(id)
        box = sS.selectedBox;
        eval(['box.UserData.fitModel=SPM.viewerModule.InteractiveFitModel.' fitModelList{id} '(box)']);
    end

%% PANEL

%Set Figure size
set(sS.Figure,'Units','Pixels','Position',[300,300,1200,600],'toolbar','figure');

%Preview Panel
previewPanel=uipanel(sS.Figure,'Title','Preview','Position',[.25 0 0.75 1],...
    'ResizeFcn',@resizePreviewPanel);
set(sS.Axes,'Parent',previewPanel);
%set(sS.Axes,'Position',[0 0 1 1]);

% Fit panel
fitPanel=uipanel(sS.Figure,'Title','Fit information','Position',[0 0 0.25 1],...
    'ResizeFcn',@resizeFitPanel,'Tag','fitpanel');
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
bottom=500;
height=20;
textbox=uicontrol('Parent',fitPanel,'Style','text','String','Select fitting model',...
    'Units','Pixels','Position',[left bottom width height],'HorizontalAlignment','left',...
    'FontSize',12);
height=20;bottom=bottom-height;
fitMenu=uicontrol('Parent',fitPanel,'Style','popupmenu','Units','Pixels',...
    'Position',[left bottom width height],'String',fitModelList,'Callback',@changeFitModel);
height=360;bottom=bottom-height-10;
infobox=uicontrol('Parent',fitPanel,'Style','text','String','','Tag','infobox',...
    'Units','Pixels','Position',[left bottom width height],'HorizontalAlignment','left');

%% USER INTERACTION

% React to user interaction with the selection boxes
addlistener(sS,'selectionBoxInitialized',@boxInitialized);
addlistener(sS,'selectionBoxChanged',@boxChanged);
addlistener(sS,'selectionBoxDeleted',@boxDeleted);
addlistener(sS,'selectionBoxSelected',@boxSelected);

% Callback
    function changeFitModel(src,evt)
        box=sS.selectedBox;
        delete(box.UserData.fitModel.fitLine);
        setFitModel(get(src,'Value'));
        notify(sS,'selectionBoxChanged');
    end

%     function changeStartPoint(src,evt,i)
%         box=sS.selectedBox;
%         newsPoint=str2num(get(src,'String'));
%         box.UserData.fitOptions.StartPoint(i)=newsPoint;
%         notify(sS,'selectionBoxChanged');
%     end

    function boxChanged(s,e)
        box=sS.selectedBox;
        delete(box.UserData.fitModel.fitLine);
        fitDisplay;
    end

    function boxSelected(s,e)
        % box=sS.selectedBox;
        % f=box.UserData.fit;
        display;
    end

    function boxDeleted(s,e)
        box=sS.selectedBox;
        delete(box.UserData.fitModel.fitLine);
    end

    function boxInitialized(s,e)
        % box = sS.selectedBox;
        % addprop(box,'fit');
        % addprop(box,'fitLine');
        % box=sS.selectedBox;
        setFitModel(get(fitMenu,'Value'));
        fitDisplay;
    end

%% FITTING AND DISPLAY

    function fitDisplay
        box = sS.selectedBox;
        fitModel = box.UserData.fitModel;
        fitModel.fitData;
        fitModel.plot;
        display;
    end

    function display
        box = sS.selectedBox;
        fitModel = box.UserData.fitModel;
        % Update the fitMenu
        checklist=cellfun(@(str) ['SPM.viewerModule.InteractiveFitModel.' str],fitModelList,'UniformOutput',false);
        id=find(ismember(checklist,class(fitModel)));
        set(fitMenu,'Value',id);
        fitModel.display;
    end
end

