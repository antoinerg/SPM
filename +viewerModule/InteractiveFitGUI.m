classdef InteractiveFitGUI < SPM.viewerModule.spectrumSelection
    properties
        fitModelList = {'fermi_offset' 'fermi' 'polynomial'};
    end
    
    methods
        function ifit = InteractiveFitGUI(channel,varargin)
            % Call spectrum selection constructor
            ifit=ifit@SPM.viewerModule.spectrumSelection(channel,varargin{:});
        end
    end
    
    methods
        function draw(ifit)
            draw@SPM.viewerModule.spectrumSelection(ifit);
                     
            function setFitModel(id)
                box=ifit.selectedBox;
                eval(['box.UserData.fitModel=SPM.viewerModule.InteractiveFitModel.' ifit.fitModelList{id} '(box);']);
            end
            
            %% PANEL
            
            %Set Figure size
            set(ifit.Figure,'Units','Pixels','Position',[300,300,1200,600],'toolbar','figure');
            
            %Preview Panel
            previewPanel=uipanel(ifit.Figure,'Title','Preview','Position',[.25 0 0.75 1],...
                'ResizeFcn',@resizePreviewPanel);
            set(ifit.Axes,'Parent',previewPanel);
            %set(ifit.Axes,'Position',[0 0 1 1]);
            
            % Fit panel
            fitPanel=uipanel(ifit.Figure,'Title','Fit information','Position',[0 0 0.25 1],...
                'ResizeFcn',@resizeFitPanel,'Tag','fitpanel');
            widthFitPanel=200;
            
            % Resize panel
            resizeFitPanel;resizePreviewPanel;
            
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
                'Position',[left bottom width height],'String',ifit.fitModelList,'Callback',@changeFitModel);
            height=360;bottom=bottom-height-10;
            infobox=uicontrol('Parent',fitPanel,'Style','text','String','','Tag','infobox',...
                'Units','Pixels','Position',[left bottom width height],'HorizontalAlignment','left');
            
            % Delete backward scan for now as we don't have a clean way of dealing with
            % it
            % delete(ifit.Line(2));
            
            %% USER INTERACTION
            
            % React to user interaction with the selection boxes
            addlistener(ifit,'selectionBoxInitialized',@boxInitialized);
            addlistener(ifit,'selectionBoxChanged',@boxChanged);
            addlistener(ifit,'selectionBoxDeleted',@boxDeleted);
            addlistener(ifit,'selectionBoxSelected',@boxSelected);
            
            
            
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
            
            % Callback
            function changeFitModel(src,evt)
                box=ifit.selectedBox;
                delete(box.UserData.fitModel.fitLine);
                setFitModel(get(src,'Value'));
                notify(ifit,'selectionBoxChanged');
            end
            
            %     function changeStartPoint(src,evt,i)
            %         box=ifit.selectedBox;
            %         newsPoint=str2num(get(src,'String'));
            %         box.UserData.fitOptions.StartPoint(i)=newsPoint;
            %         notify(ifit,'selectionBoxChanged');
            %     end
            
            function boxChanged(s,e)
                box=ifit.selectedBox;
                delete(box.UserData.fitModel.fitLine);
                fitDisplay;
            end
            
            function boxSelected(s,e)
                % box=ifit.selectedBox;
                % f=box.UserData.fit;
                display;
            end
            
            function boxDeleted(s,e)
                box=ifit.selectedBox;
                delete(box.UserData.fitModel.fitLine);
            end
            
            function boxInitialized(s,e)
                % box = ifit.selectedBox;
                % addprop(box,'fit');
                % addprop(box,'fitLine');
                % box=ifit.selectedBox;
                setFitModel(get(fitMenu,'Value'));
                fitDisplay;
            end
            
            function fitDisplay
                box = ifit.selectedBox;
                fitModel = box.UserData.fitModel;
                fitModel.fitData;
                fitModel.plot;
                display;
            end
            
            function display
                box = ifit.selectedBox;
                fitModel = box.UserData.fitModel;
                % Update the fitMenu
                checklist=cellfun(@(str) ['SPM.viewerModule.InteractiveFitModel.' str],ifit.fitModelList,'UniformOutput',false);
                id=find(ismember(checklist,class(fitModel)));
                set(fitMenu,'Value',id);
                fitModel.display;
            end
                        
            % If retrieving a saved session, redraw all fits
            if ~isempty(ifit.selectionBox)
               for i=1:length(ifit.selectionBox)
                 box = ifit.selectionBox(i);
                 box.attachUI;
                 box.UserData.fitModel.plot;
               end
            end
            
        end
    end
end

