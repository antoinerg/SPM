classdef BaselineFitGUI < handle
    properties
        selectedPoint;
        selectionPoint;
        Channel;
    end
    
    properties(Transient=true)
        Figure;
        Axes;
        Line;
        BaselineLine;
    end
    
    events
        selectionPointInitialized
        selectionPointChanging
        selectionPointChanged
        selectionPointSelected
        selectionPointDeleted
    end
    
    methods
        function ifit = BaselineFitGUI(channel,varargin)
            % Call spectrum selection constructor
            ifit.Channel=channel;
        end
        
        function draw(sV)
            sV.Figure=figure;
            sV.Axes=axes;
            set(sV.Figure,'Name','Baseline Fit');
            set(sV.Figure,'Toolbar','none','menubar','none');
            set(sV.Axes,'NextPlot','add');
            
            % Plot the channel
            fplot=plot(sV.Axes,sV.Channel.Data,'Tag','data');
            sV.Line=fplot;
            
            % Label axes
            ylabel(sV.Axes,sV.Channel.Name);
            %xlabel(sV.Axes,sV.xChannel.Name);
            
            % Freeze the axis
            sV.freezeAxes;
            
            % Set callback to create new selection box on axis and plot
            set([sV.Axes,sV.Line],'ButtonDownFcn',@sV.newSelectionPoint);
            
            % If retrieving a saved session, redraw all points
            if ~isempty(sV.selectionPoint)
                for i=1:length(sV.selectionPoint)
                    sV.selectionPoint(i).draw;
                    sV.selectionPoint(i).attachUI;
                end
                
                interpolateDisplay;
            end
            
            % React to user interaction with the selection boxes
            addlistener(sV,'selectionPointInitialized',@interpolateDisplay);
            addlistener(sV,'selectionPointChanged',@interpolateDisplay);
            addlistener(sV,'selectionPointDeleted',@interpolateDisplay);
            %addlistener(sV,'selectionPointSelected',@interpolateDisplay);
            
            function interpolateDisplay(s,e)
                delete(sV.BaselineLine);
                if (length(sV.selectionPoint) > 1)
                    x=[];y=[];
                    for j=1:length(sV.selectionPoint)
                        pt = sV.selectionPoint(j);
                        x(j)=pt.pos(1);y(j)=pt.pos(2);
                    end
                    xi = 1:length(sV.Channel.Data);
                    yi = interp1(x,y,xi,'pchip');
                    sV.BaselineLine=line(xi,yi,'Parent',sV.Axes,'color','r',...
                        'linewidth',1,'HitTest','off');
                end
            end
            
        end
        
        function yi=corrected_data(sV)
            if (length(sV.selectionPoint) > 1)
                    x=[];y=[];
                    for j=1:length(sV.selectionPoint)
                        pt = sV.selectionPoint(j);
                        x(j)=pt.pos(1);y(j)=pt.pos(2);
                    end
                    xi = 1:length(sV.Channel.Data);
                    yi = interp1(x,y,xi,'pchip');
            else
                yi = [];
            end
        end
        
        function freezeAxes(sV)
            set(sV.Axes,'XLim',get(sV.Axes,'XLim'));
            set(sV.Axes,'YLim',get(sV.Axes,'YLim'));
        end
        
        function unfreezeAxes(sV)
            set(sV.Axes,'XLimMode','auto');
            set(sV.Axes,'YLimMode','auto');
        end 
    end
    
    methods(Access=private)
        function newSelectionPoint(sV,src,evt)
            % Get current cursor position
            p1=get(gca,'CurrentPoint'); p1=p1(1,1:2); % button down detected
            
            % Initialize the selectionPoint object specifying its position
            point = SPM.viewerModule.selectionPoint(sV,p1);
            
            % Append to the list of selectionPoint associated with this figure
            sV.selectionPoint = vertcat(sV.selectionPoint,point); % retain handle to selectionBox
            
            % Broadcast the event
            notify(sV,'selectionPointInitialized'); % this shouldn't go here 
        end
    end
end

