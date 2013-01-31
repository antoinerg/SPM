classdef AbstractFitModel < handle
    %INTERACTIVEFITMODEL Abstract class for fitting model
    
    properties(Abstract=true)
        Name;
        fitType;
        fitOptions;
    end
    
    properties
        Box;
        fit;
    end
    
    properties(Transient=true)
        fitLine;
    end
    
    properties (Dependent = true, SetAccess = private,Hidden=true)
        Axes;
        Infobox;
        fitPanel;
    end
    
    
    methods
        function axes = get.Axes(obj)
            axes=obj.Box.Parent.Axes;
        end
        
        function infobox = get.Infobox(obj)
            infobox=findobj(obj.Box.Figure,'Tag','infobox');
        end
        
        function fitPanel = get.fitPanel(obj)
            fitPanel = findobj(obj.Box.Figure,'Tag','fitpanel');
        end
    end % dependent methods
    
    methods
        function fitModel=AbstractFitModel(box)
            fitModel.Box=box;
        end
        
        function outside=excludeOutside(fitModel)
            fitModel.fitOptions = fitoptions(fitModel.fitOptions,'Exclude',fitModel.Outside);
        end
        
        function outside=Outside(fitModel)
            ydata=fitModel.Box.Parent.Channel.Data';
            xdata=fitModel.Box.Parent.xChannel.Data';
            [x1 x2 y1 y2]=fitModel.Box.coord;
            
            outside1=excludedata(xdata,ydata,'box',[x1 x2 y1 y2]);
            outside2=excludedata(xdata,ydata,'indices',find(isnan(ydata)));
            outside = outside1|outside2;
        end
        
        function display(fitModel)
            % Update the information box to display current box's fit
            str={};
            str=vertcat(str,'EQUATION:');
            eqn = formula(fitModel.fit);
            str=vertcat(str,eqn);
            
            str=vertcat(str,'COEFFICIENTS:');
            coeff=coeffnames(fitModel.fit);
            values=coeffvalues(fitModel.fit);
            for i=1:length(coeff)
                str=vertcat(str,[coeff{i} ' = ' num2str(values(i))]);
            end
            
            set(fitModel.Infobox,'String',str);
        end
        
        function plot(fitModel)
            % Plot the resulting fit line in the interval of the box
            xdata=fitModel.Box.Parent.xChannel.Data';
            [x1 x2 y1 y2]=fitModel.Box.coord;
            range=xdata(xdata>x1 & xdata<x2);
            fitModel.fitLine=line(range,feval(fitModel.fit,range),'Parent',fitModel.Axes,'color','r',...
                'linewidth',2,'HitTest','off');
        end
        
        function s=summary(fitModel)
            s=struct;
            cname=coeffnames(fitModel.fit);
            cvalue=coeffvalues(fitModel.fit);
            for i=1:length(cname)
                s = setfield(s,cname{i},cvalue(i));
            end
        end
    end
    
    
    methods(Abstract=true)
        fitData(obj);
    end
    
end

