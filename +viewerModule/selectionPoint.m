classdef selectionPoint < handle
    properties
        pos; % coordinates of corner 1
        Parent; % handle to the parent object
        %markersHandle; % handles of the markers accessed by selectionBoxMarker
        ContextualMenu;
        UserData;
    end
    
    properties(Transient=true)
        handle; % graphic handle
        Axes;
        Figure;
    end
    
    properties(Access=private)
        oldPos;
    end
    
    methods
        function point = selectionPoint(f,p1)
            % Initialize properties
            point.Parent=f;
            point.pos = p1;
            point.draw;
            point.attachUI;
        end
        
       
        function attachUI(point)
            sV = point.Parent;
            % Attach callback to the graphic handle
            set(point.handle,'ButtonDownFcn',@point.clickSelectionPoint);
            
            % Attach contextual menu
            point.ContextualMenu = uicontextmenu;
            i = uimenu(point.ContextualMenu, 'Label', 'Delete', 'Callback', @point.delete);
            set(point.handle,'uicontextmenu',point.ContextualMenu);
            
            % Attach markers to the selectionBox
            %SPM.viewerModule.selectionBoxMarker.initMarkers(box);
            
            box.UserData.New = 1;
            sV.selectedPoint = point;
        end
        
        function startDragging(point)
            % Get current position
            p=get(point.Axes,'CurrentPoint');x=p(1,1);y=p(1,2);
            point.oldPos=[x,y];
            
            % Start interactive dragging
            set(point.Figure,'WindowButtonMotionFcn',@point.dragging);
            set(point.Figure,'WindowButtonUpFcn',@point.endDragging);
            
            % Broadcast event
            notify(point.Parent,'selectionPointChanging');
            
            %box.markersHandle.hide;
        end
        
        function dragging(point,src,evt)
            % Get current position
            mouse_pos=get(point.Axes,'CurrentPoint');mouse_pos=mouse_pos(1,1:2);
            
            % Get difference with old position and update the oldPos
            delta = mouse_pos-point.oldPos;
            point.oldPos=mouse_pos;
            
            % Update the position
            point.pos = point.pos+delta;
            
            % Redraw the point
            point.draw
        end
        
        function endDragging(point,srv,evt)
            % Stop interactive dragging
            set(point.Figure,'WindowButtonMotionFcn','');
            set(point.Figure,'WindowButtonUpFcn','');
            
            % Broadcast the event!
            notify(point.Parent,'selectionPointChanged');
            
            % Redraw the markers
            %box.markersHandle.draw;
        end
        
        function draw(point)
            % Draw the point
            set(point.handle,'XData',point.pos(1),'YData',point.pos(2),'Visible','on');
        end
        
        function v=get.handle(point)
            % Instantiate a patch for visual representation of region if not
            % already done
            if isempty(point.handle)
                point.handle = line('Parent',point.Axes,'Visible','off','Tag','selectionBox','Marker','o');
            end
            v=point.handle;
        end
        
        function v=get.Axes(point)
            v=point.Parent.Axes;
        end
        
        function v=get.Figure(point)
            v=point.Parent.Figure;
        end
        
        function delete(point,varargin)
            sV=point.Parent;
            sV.selectionPoint(sV.selectionPoint==point)=[];
            sV.selectedPoint=[];
            %point.unselect;
            delete(point.handle);
            % Broadcast event
            notify(sV,'selectionPointDeleted');
        end

    end
    
    methods(Access=private)
        function clickSelectionPoint(point,src,evt)
          point.startDragging;
        end
    end
end
