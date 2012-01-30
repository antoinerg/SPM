classdef view < handle
    properties
        Viewer;
        Axes;
        Handle;
        Channel;
        xChannel=[];
        ContextualMenu;
    end
    
    methods
        function v = view(viewer,ch,varargin)
            v.Viewer=viewer;
            v.Channel=ch;
            if ~isempty(varargin)
                v.xChannel = varargin{1};
            end
        end
        
        function draw(v)
            [m,n]=size(v.Channel.Data);
            if m==1 || n==1
                v.plotSpectrum;
            else
                v.plotImage;
            end
        end
        
        function plotImage(v)
            ch=v.Channel;
            %colormap(gold);
            %v.Handle=pcolor(v.Channel.Data,'Parent',v.Axes);
            %shading interp;
            v.Handle=imshow(ch.Data,'Parent',v.Axes,'Colormap',SPM.viewerModule.gold);
            
            % Set axes
            xreal=ch.spm.Height;
            yreal=ch.spm.Width;
            
            % Set tick
            nb_ticks=2;
            [m,n]=size(ch.Data);
            set(v.Axes,'XTick',0:m/nb_ticks:m,'XTickLabel',num2cell(0:floor(xreal/nb_ticks):xreal),'Visible','on');
            set(v.Axes,'YTick',0:n/nb_ticks:n,'YTickLabel',num2cell(0:floor(yreal/nb_ticks):yreal));
            set(v.Axes,'CLimMode','auto');
            v.attachContextMenu;
            v.showTitle;
        end
        
        function plotSpectrum(v)
            ych=v.Channel;
            xch=v.xChannel;
            % If xChannel not yet set
            if ~isa(xch,'SPM.channel')
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
            v.xChannel = xch;
            
            % Plot
            fplot=plot(v.Axes,xch.Data,ych.Data,'Tag','data');
            %bplot=plot(v.Axes,v.Channel.Data('back'),'Tag','data');
            %set(v.Axes,'DataAspectRatio',[1 1 1]);
            v.Handle=fplot;
            v.attachContextMenu;
            v.showTitle;
        end
        
        function showTitle(v)
            title(v.Axes,v.Channel.Name);
        end
        
        function attachContextMenu(v)
            spm=v.Channel.spm;
            
            % Add a contextual menu
            v.ContextualMenu = uicontextmenu;
            
            % Add an 'Open file' menu
            uimenu(v.ContextualMenu,'Label','Open file','Callback',@v.openFile);
            
            % List available channels and their descendants
            for j=1:length(spm.Channel)
                nch = spm.Channel(j);
                v.generateSubMenu(nch,v.ContextualMenu);
            end
            
            % List userchannel
            UserChannelMenu = uimenu(v.ContextualMenu,'Label','UserChannel','Separator','on');
            for j=1:length(spm.UserChannel)
                nch = spm.UserChannel(j);
                item = uimenu(UserChannelMenu, 'Label', [nch.Name ' [' nch.Direction ']'], 'Callback', {@v.changeChannel,nch});
            end
            
            
            set([v.Handle,v.Axes],'uicontextmenu',v.ContextualMenu);
        end
        
        
        function changeChannel(v,src,evt,nch)
            v.Channel=nch;
            v.draw;
        end
        
        function openFile(v,src,evt)
            [filename,pathname] = uigetfile('*');
            path=fullfile(pathname,filename);
            if filename==0
                
            else
                s=SPM.load(path);
                v.Channel=s.Channel(1);
                v.draw;
            end
            
        end
    end
    
    methods(Access=private)
        function generateSubMenu(v,ch,ParentMenu)
            spm=ch.spm;
            item = uimenu(ParentMenu, 'Label', [ch.Name ' [' ch.Direction ']']);
            
            % if j==1, set(item,'separator','on');end
            
            subitems=findobj(spm.UserChannel,'-depth',1,'ParentChannel',ch);
            L=length(subitems);
            if L==0
                set(item,'Callback', {@v.changeChannel,ch});
            elseif L > 0
                uimenu(item,'Label','Self','Callback',{@v.changeChannel,ch});
                for i=1:length(subitems)
                    nch=subitems(i);
                    v.generateSubMenu(nch,item);
                end
            end
        end
    end
    
end