function [filteredData,patches]=interactiveGUI(ch)
% Initialize GUI
f=figure;
ax=axes;
h=plot(ax,ch.Data0);

% Set callback to create new selection box on axis and plot
set([ax,h],'ButtonDownFcn',@newSelectionBox);
% Set callback to react to keypress
set(f,'KeyPressFcn',@keyboard);

    function newSelectionBox(src,event)
        p1=get(ax,'CurrentPoint'); p1=p1(1,1:2); % button down detected
        rbbox;
        p2=get(ax,'CurrentPoint');p2=p2(1,1:2);  %button up detected
        
        % Instantiate a box object
        box = patch('FaceColor','r','FaceAlpha',0.2,'LineStyle','--',...
            'Parent',ax,'Visible','off','Tag','selectionBox');
        set(box,'ButtonDownFcn',@clickSelectionBox);
        
        % Save the coords [x1,x2;y1,y2] on the box object and draw
        setappdata(box,'coord',[p1(1),p2(1);p1(2),p2(2)]);
        drawBox(box);
        
        initMarker(box); % Draw markers
        
        % Make the new box current
        selectBox(box);
        
        % Add a contextual menu
        cmenu = uicontextmenu;
        item = uimenu(cmenu, 'Label','Delete', 'Callback', {@deleteBox,{box}});
        set(box,'uicontextmenu',cmenu);
    end

    function drawBox(box)
        % Draw box as long as 'coord' is set
        coord = getappdata(box,'coord');
        
        x1=coord(1,1);y1=coord(2,1);x2=coord(1,2);y2=coord(2,2);
        
        % Draw the box
        x = [x1 x1 x2 x2];
        y = [y1 y2 y2 y1];
        set(box,'XData',x,'YData',y,'Visible','on');
    end

    function clickSelectionBox(src,event)
        box = src; % Box that triggedred the callback
        selectedBox=getappdata(ax,'selectedBox'); % Current selected box
        if selectedBox==box % Drag
            %coord = getappdata(box,'coord');
            p1=get(ax,'CurrentPoint');p1=p1(1,1:2); % button down detected
            setappdata(ax,'oldPos',p1);
            turnMarkers('off');
            set(f,'WindowButtonMotionFcn',@wbm_MoveSelectionBox,...
                'WindowButtonUpFcn',@wbu_MoveSelectionBox);
        else % Select the box
            selectBox(box);
        end
    end

    function wbm_MoveSelectionBox(src,event)
        box = getappdata(ax,'selectedBox');
        coord = getappdata(box,'coord');
        oldPos = getappdata(ax,'oldPos');
        p1=get(ax,'CurrentPoint');p1=p1(1,1:2); % get current position
        setappdata(ax,'oldPos',p1); % set as the new position
        delta=p1-oldPos; % Get delta from last position
        coord=coord+repmat(delta',1,2); % Update the coord
        setappdata(box,'coord',coord); % Save the coord
        drawBox(box); % Draw the box at its new position
    end

    function wbu_MoveSelectionBox(src,event)
        set(f,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
        box = getappdata(ax,'selectedBox');
        drawMarker(box);
    end

    function drawMarker(box)
        coord = getappdata(box,'coord');
        markers = getappdata(box,'Markers');
        x1=coord(1,1);x2=coord(1,2);y1=coord(2,1);y2=coord(2,2);
        mxy(1,:)=[x1,(y1+y2)/2];
        mxy(2,:)=[(x1+x2)/2,y2];
        mxy(3,:)=[x2,(y1+y2)/2];
        mxy(4,:)=[(x1+x2)/2,y1];
        
        for i=1:4
            set(markers(i),'XData',mxy(i,1),'YData',mxy(i,2),'Visible','on');
        end
    end

    function initMarker(box)
        for i=1:4
            m(i) = line('parent', ax,'Marker','s','MarkerEdgeColor','none', ...
                'MarkerFaceColor','k','MarkerSize',6,'ButtonDownFcn',@selectMarker,...
                'Tag',num2str(i),'Visible','off','Tag',num2str(i));
        end
        setappdata(box,'Markers',m);
        drawMarker(box);
    end

    function selectBox(box)
        unselectCurrentBox;
        setappdata(ax,'selectedBox',box);
        turnMarkers('on');
    end

    function selectMarker(src,event)
        box = getappdata(ax,'selectedBox');
        setappdata(ax,'selectedMarker',src);
        turnMarkers('off');
        p1=get(ax,'CurrentPoint');p1=p1(1,1:2); % get current position
        setappdata(ax,'oldPos',p1); % set old position
        set(f,'WindowButtonMotionFcn',@wbm_MoveMarker,...
            'WindowButtonUpFcn',@wbu_MoveMarker);
        
    end

    function unselectCurrentBox
        turnMarkers('off');
        setappdata(ax,'selectedBox',[]);
    end

    function turnMarkers(bool)
        if isappdata(ax,'selectedBox');
            box=getappdata(ax,'selectedBox');
            if ~isempty(box)
                markers=getappdata(box,'Markers');
                set(markers,'Visible',bool);
            end
        end
    end

    function wbm_MoveMarker(src,event)
        box = getappdata(ax,'selectedBox');
        selectedMarker = getappdata(ax,'selectedMarker');
        p1=get(ax,'CurrentPoint');p1=p1(1,1:2); % get current position
        oldPos=getappdata(ax,'oldPos'); % get old position
        setappdata(ax,'oldPos',p1); % set old position
        delta=p1-oldPos; % Get delta from last position
        coord = getappdata(box,'coord');
        
        i=get(selectedMarker,'Tag');
        switch i
            case '1'
                coord(1) = coord(1) + delta(1);
            case '2'
                coord(4) = coord(4) + delta(2);
            case '3'
                coord(3) = coord(3) + delta(1);
            case '4'
                coord(2) = coord(2) + delta(2);
        end
        
        setappdata(box,'coord',coord);
        drawBox(box);
    end

    function wbu_MoveMarker(src,event)
        box = getappdata(ax,'selectedBox');
        drawMarker(box);
        turnMarkers('on');
        set(f,'WindowButtonMotionFcn','','WindowButtonUpFcn','');
    end

    function keyboard(src,event)
        if strcmp(event.Character,'q')
            disp('Filtering');
            
            selectionBoxes = findall(f,'Type','patch','Tag','selectionBox');
            NBoxes=length(selectionBoxes);
            
            [m,n]=size(ch.Data);
            binaryMatrix=ones(m,n);
            
            for i=1:NBoxes
                x=get(selectionBoxes(i),'XData');
                y=get(selectionBoxes(i),'YData');
                
                x1=floor(min(x));
                x2=ceil(max(x));
                y1=min(y);
                y2=max(y);
                id=find(ch.Data0(x1:x2) > y1 & ch.Data0(x1:x2) < y2);
                binaryMatrix(x1+id)=NaN;
                
                filteredData=binaryMatrix;
                patches=NBoxes;
            end
            
            disp('Done');
            close(f);
        end
    end

    function deleteBox(src,event,box)
        markers = getappdata(box{1},'Markers');
        unselectCurrentBox;
        delete(box{1},markers);
  
    end

uiwait(f);
end