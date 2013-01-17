classdef selectionBox < handle
    properties
        c1; % coordinates of corner 1
        c2; % coordinates of corner 2
        Parent; % handle to the parent object
        markersHandle; % handles of the markers accessed by selectionBoxMarker
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
        function box = selectionBox(f,c1)
            % Initialize properties
            box.Parent=f;
            box.c1 = c1;
            
            % Interactively draw initial box
            set(box.Figure,'WindowButtonMotionFcn',@box.initialSizing);
            set(box.Figure,'WindowButtonUpFcn',@box.endInitialSizing);
        end
        
        function initialSizing(box,src,evt)
            p2=get(gca,'CurrentPoint'); p2=p2(1,1:2);
            box.c2=p2;
            box.draw;
        end
        
        function endInitialSizing(box,src,evt)
            set(box.Figure,'WindowButtonMotionFcn','');
            set(box.Figure,'WindowButtonUpFcn','');
            box.attachUI;
        end
        
        function attachUI(box)
            sV = box.Parent;
            
            % Attach callback to the graphic handle
            set(box.handle,'ButtonDownFcn',@box.clickSelectionBox);
            
            % Attach contextual menu
            box.ContextualMenu = uicontextmenu;
            i = uimenu(box.ContextualMenu, 'Label', 'Delete', 'Callback', @box.delete);
            set(box.handle,'uicontextmenu',box.ContextualMenu);

            % Attach markers to the selectionBox
            SPM.viewerModule.selectionBoxMarker.initMarkers(box);
            
            box.UserData.New = 1;
            sV.selectedBox = box;
            
            % Broadcast the event
            notify(sV,'selectionBoxInitialized');
        
        end
        
        function startDragging(box)
            % Get current position
            p=get(box.Axes,'CurrentPoint');x=p(1,1);y=p(1,2);
            box.oldPos=[x,y];
            
            % Start interactive dragging
            set(box.Figure,'WindowButtonMotionFcn',@box.dragging);
            set(box.Figure,'WindowButtonUpFcn',@box.endDragging);
            
            % Broadcast event
            notify(box.Parent,'selectionBoxChanging');
            
            box.markersHandle.hide;
        end
        
        function dragging(box,src,evt)
            % Get current position
            pos=get(box.Axes,'CurrentPoint');pos=pos(1,1:2);
            
            % Get difference with old position and update the oldPos
            delta = pos-box.oldPos;
            box.oldPos=pos;
            
            % Update the position of the corners accordingly
            box.c1 = box.c1+delta;
            box.c2 = box.c2+delta;
            
            % Redraw the box
            box.draw
        end
        
        function endDragging(box,srv,evt)
            % Stop interactive dragging
            set(box.Figure,'WindowButtonMotionFcn','');
            set(box.Figure,'WindowButtonUpFcn','');
            
            % Broadcast the event!
            notify(box.Parent,'selectionBoxChanged');
            
            % Redraw the markers
            box.markersHandle.draw;
        end
                   
        function draw(box)
            % Draw the box
            x = [box.c1(1) box.c1(1,1) box.c2(1) box.c2(1)];
            y = [box.c1(2) box.c2(2) box.c2(2) box.c1(2)];
            set(box.handle,'XData',x,'YData',y,'Visible','on');
        end
        
        function unselect(box)
            % Called when a new box is selected
            % We should unselect all the boxes before selecting one
            box.markersHandle.hide;
        end
        
        function select(box)
            % Called when user click on the box
            box.markersHandle.show;
        end
        
        function v=get.handle(box)
          % Instantiate a patch for visual representation of region if not
          % already done
          if isempty(box.handle)
            box.handle = patch('FaceColor','r','FaceAlpha',0.2,'LineStyle','--',...
                'Parent',box.Axes,'Visible','off','Tag','selectionBox');
          end
          v=box.handle;
        end
        
        function v=get.Axes(box)
            v=box.Parent.Axes;
        end
        
        function v=get.Figure(box)
            v=box.Parent.Figure;
        end
        
        function delete(box,varargin)
            sV=box.Parent;
            
            % Broadcast event
            notify(sV,'selectionBoxDeleted');
            
            sV.selectionBox(sV.selectionBox==box)=[];
            sV.selectedBox=[];
            box.unselect;
            delete(box.handle);
            delete(box.markersHandle);
        end
        
        function [x1 x2 y1 y2]=coord(box)
            x=[box.c1(1),box.c2(1)];y=[box.c1(2),box.c2(2)];
            x1=min(x);
            x2=max(x);
            y1=min(y);
            y2=max(y);
        end
    end
    
    methods(Access=private)
        function clickSelectionBox(box,src,evt)
            if box.Parent.selectedBox==box % Drag
                box.startDragging;
            else % Select the box
                box.Parent.selectedBox=box;
            end
        end
    end
end
