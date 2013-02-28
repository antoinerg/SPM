classdef viewer < handle
    properties
        Figure;
        Child=[];
        Size=[1,1];
    end
    methods
        function obj = viewer
            obj.Figure=figure('Visible','on');
            %set(obj.Figure,'Toolbar','none','menubar','none');
        end
        
        function v=add(v,ch,varargin)
            vCh=SPM.viewerModule.view(v,ch,varargin{:});
            v.Child=vertcat(v.Child,vCh);
            if v.Size(1)*v.Size(2) < length(v.Child)
                v.Size(1) = length(v.Child);
                v.Size(2) = 1;
            end
            v.draw;
        end
        
        function delete(v)
            if ishandle(v.Figure)
                %delete(v.Figure);
            end
        end
      
        function export(v,path)
            %print(v.Figure,'-dpng','-r72',path);
            SPM.lib.plot2svg(path,v.Figure);
            
            f=[];
            view=[];
            for i=1:length(v.Child)
               ch=v.Child(i).Channel;
               view = struct('Position',i,'Name',ch.Name,'Direction',ch.Direction,'ParentHash',ch.spm.Hash);
            end
            f=setfield(f,'View',view);
                        % Prepare final XML to be written
            final = [];
            % Information ends up inside a "Viewer" element
            final = setfield(final,'Viewer',f);
            final.Viewer.ATTRIBUTE.filename = path;
            
            % Writing the XML
            Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
            Pref.StructItem=false;
            SPM.lib.xml_io_tools.xml_write([path '.xml'],final,'SPM',Pref);
        end
        
        function draw(v)
            set(0,'CurrentFigure',v.Figure);
            L = length(v.Child);
            nrow=v.Size(1);ncol=v.Size(2);
            for i=1:L
                ax=subplot(nrow,ncol,i);
                v.Child(i).Axes=ax;
                v.Child(i).draw;
            end
            set(v.Figure,'Visible','on');
        end
    end
    
    methods(Static=true)
    end
end