classdef spectrumSelection < handle
    properties
        Line;
        selectedBox;
        selectionBox;
        xChannel;
        Figure;
        Axes;
        Channel;
    end
    
    events
        selectionBoxInitialized
        selectionBoxChanging
        selectionBoxChanged
        selectionBoxSelected
        selectionBoxDeleted
    end
    
    methods
        function sV = spectrumSelection(ych,varargin)
            if ~isempty(varargin)
                xch = varargin{1};
            else
                xch = '';
            end
            if (nargin == 1) || ~isa(xch,'SPM.channel')
                % Prompt user to choose
                allch=vertcat(ych.spm.Channel);
                index=menu('Choose X channel',{allch.Name});
                if index==0 % If user abort choosing we create a temporary channel that holds indexes
                    xch = SPM.format.userchannel;
                    xch.Name = 'indices';
                    xch.setData(1:length(ych.Data));
                else % Or we use user's selection
                    xch=allch(index);
                end
            end
            
            % Call superclass constructor
            %sV=sV@SPM.viewer(ych);
            sV.Channel=ych;
            sV.xChannel=xch;
            
            sV.draw;
        end
        
        function draw(sV)
            sV.Figure=figure;
            sV.Axes=axes;
            set(sV.Figure,'Name','spectrum Selection');
            set(sV.Figure,'Toolbar','none','menubar','none');
            set(sV.Axes,'NextPlot','add');
            
            % Plot the channel
            fplot=plot(sV.Axes,sV.xChannel.Data,sV.Channel.Data,'Tag','data');
            sV.Line=fplot;
            
            % Label axes
            ylabel(sV.Axes,sV.Channel.Name);
            xlabel(sV.Axes,sV.xChannel.Name);
            
            % Freeze the axis
            sV.freezeAxes;
            
            % Set callback to create new selection box on axis and plot
            set([sV.Axes,sV.Line],'ButtonDownFcn',@sV.newSelectionBox);
            
            % If retrieving a saved session, redraw all boxes
            if ~isempty(sV.selectionBox)
               for i=1:length(sV.selectionBox)
                   sV.selectionBox(i).draw;
                   sV.selectionBox(i).attachUI;
               end
            end
        end
        
        function set.selectedBox(sV,box)
            if isa(box,'SPM.viewerModule.selectionBox')
                if ~isempty(sV.selectedBox)
                    sV.selectedBox.unselect;
                end
                sV.selectedBox = box;
                box.select;
                if box.UserData.New
                    box.UserData.New=0;
                else
                    notify(sV,'selectionBoxSelected');
                end
            else
                sV.selectedBox = [];
            end
        end
        
        function bM=binaryMatrix(sV)
            ydata = sV.Channel.Data;
            xdata = sV.xChannel.Data;
            
            for i=1:length(sV.selectionBox)
                [x1 x2 y1 y2]=sV.selectionBox(i).coord;
                xdata(xdata > x1 & xdata < x2)=0;
                ydata(ydata > y1 & ydata < y2)=0;
            end
            
            bM = ~(xdata|ydata);
        end
        
        function freezeAxes(sV)
            set(sV.Axes,'XLim',get(sV.Axes,'XLim'));
            set(sV.Axes,'YLim',get(sV.Axes,'YLim'));
        end
        
        function unfreezeAxes(sV)
            set(sV.Axes,'XLimMode','auto');
            set(sV.Axes,'YLimMode','auto');
        end
        
%         function b=saveobj(a)
%             b=a;
%             hgsave(a.Figure,'fig');
%         end
    end
    
    methods(Static=true)
%         function b=loadobj(a)
%             b.Figure=hgload('fig');
%         end 
    end
    
    methods(Access=private)
        function newSelectionBox(sV,src,evt)
            % Get current cursor position
            p1=get(gca,'CurrentPoint'); p1=p1(1,1:2); % button down detected
            
            % Initialize the selectionBox object specifying the first
            % corner
            box = SPM.viewerModule.selectionBox(sV,p1); % initialize the box, setting the parent and coords
            
            % Append to the list of selectionBox associated with this
            % figure
            sV.selectionBox = vertcat(sV.selectionBox,box); % retain handle to selectionBox
        end
    end
end