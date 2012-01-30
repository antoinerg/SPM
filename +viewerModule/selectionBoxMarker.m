classdef selectionBoxMarker < handle
    properties
        Axes;
        Figure;
        selectionBox;
        handle; % Graphic handle
        index;
        pos; % [x;y];
    end
    methods
        function marker = selectionBoxMarker(box,i)
            marker.index=i;
            marker.selectionBox=box;
            marker.handle = line('parent', marker.Axes,'Marker','s',...
                'MarkerEdgeColor','none', 'MarkerFaceColor','k','MarkerSize',6,...
                'ButtonDownFcn',@marker.select,...
                'Visible','off');
            marker.draw;
            
        end
        
        function draw(marker)
            marker.updatePos;
            marker.show;
        end
        
        function updatePos(marker)
            for i=1:length(marker)
             set(marker(i).handle,{'XData','YData'},{marker(i).pos(1),marker(i).pos(2)});
            end
        end
        
        function v=get.pos(marker)
            % Get pos of the selection box
            c1=marker.selectionBox.c1;
            c2=marker.selectionBox.c2;
            x1=c1(1);x2=c2(1);y1=c1(2);y2=c2(2);
            
            % Compute the position of every markers
            mxy(1,:)=[x1,(y1+y2)/2];
            mxy(2,:)=[(x1+x2)/2,y2];
            mxy(3,:)=[x2,(y1+y2)/2];
            mxy(4,:)=[(x1+x2)/2,y1];
            
            % Return the pos of the marker based on its index
            v = [mxy(marker.index,1),mxy(marker.index,2)];
        end
        
        function v=get.Axes(marker)
            v=marker.selectionBox.Axes;
        end
        
        function v=get.Figure(marker)
            v=marker.selectionBox.Figure;
        end
        
        function hide(marker)
            set([marker.handle],'Visible','off');
        end
        
        function show(marker)
            uistack([marker.handle],'top');
            set([marker.handle],'Visible','on');
        end
        
        function select(marker,src,evt)
           sV=marker.selectionBox.Parent;
           
           % Broadcast event
           notify(sV,'selectionBoxChanging');
           
           % Hide markers
           marker.selectionBox.markersHandle.hide;
           
           % Start interactive resizing
           set(sV.Figure,'WindowButtonMotionFcn',@marker.resizing);
           set(sV.Figure,'WindowButtonUpFcn',@marker.endResizing);
        end
        
        function resizing(marker,src,evt)
            p=get(marker.Axes,'CurrentPoint');x=p(1,1);y=p(1,2); % get current position
            box = marker.selectionBox;
            switch marker.index
                case 1
                    box.c1(1) = x;
                case 2
                    box.c2(2) = y;
                case 3
                    box.c2(1) = x;
                case 4
                    box.c1(2) = y;
            end
            box.draw
        end
        
        function endResizing(marker,src,evt)
            sV=marker.selectionBox.Parent;
            
            % Broadcast event
            notify(sV,'selectionBoxChanged');
            
            % Stop interactive resizing
            set(sV.Figure,'WindowButtonMotionFcn','');
            set(sV.Figure,'WindowButtonUpFcn','');
            
            % Redraw the markers
            marker.selectionBox.markersHandle.draw;
        end
    end
    
    methods(Static=true)
        function initMarkers(box)
            box.markersHandle = [];
            for i=1:4
                marker = SPM.viewerModule.selectionBoxMarker(box,i);
                box.markersHandle = vertcat(box.markersHandle,marker);
            end
        end
    end
end