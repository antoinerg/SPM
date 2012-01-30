classdef viewer < handle
    properties
        FigHandle % Store figure handle
        ImgHandle % Store image handle
        AxesHandle % Store the axes handle
        Channel % Store channel handle
        cmenu % Store contextual menu handle
        spm % store spm object
        ch % current channel
    end
    methods
        
        function v = viewer(filename)
            v.FigHandle = figure;
            v.spm=SPM.load(filename);
            
            v.AxesHandle=axes;
            iptsetpref('ImshowAxesVisible','on');
            v.draw;
        end
        
        
        function attachContextMenu(v)
            % Add a contextual menu
            v.cmenu = uicontextmenu;
            % Define callbacks for context menu items that change
            % channels
            for j=1:length(v.spm.Channel)
                nch = v.spm.Channel(j);
                item = uimenu(v.cmenu, 'Label', nch.Name, 'Callback', {@changeChannel,{v,nch}});
            end
            
            set(v.ImgHandle,'uicontextmenu',v.cmenu)
        end
        
        function draw(v)
            %Spectrum
            if strcmpi(v.spm.Type,'spectroscopy')
                ubias_ch=v.spm.getChannelByName('bias voltage');
                friction_ch=v.spm.getChannelByName('friction');
                fshift_ch=v.spm.getChannelByName('deflection');
                
                ubias = [ubias_ch.Data,ubias_ch.Data('back')];
                friction = [friction_ch.Data,friction_ch.Data('back')];
                fshift = [fshift_ch.Data,fshift_ch.Data('back')];
                
                windowSize=100;
                
                filtered_dissipation=filter(ones(1,windowSize)/windowSize,1,friction);
                filtered_fshift=filter(ones(1,windowSize)/windowSize,1,fshift);
                
                [v.AxesHandle,v.ImgHandle]=plotyy(ubias,filtered_dissipation,ubias,filtered_fshift);
                
                ylabel(v.AxesHandle(1),['Dissipation']);
                ylabel(v.AxesHandle(2),['Frequency shift']);
                
            else
                %2D image
                v.ch = v.spm.Channel(1);
                data=flipud(v.ch.Flatten.removepolyBG(2,2).Data);
                
                v.ImgHandle=imshow(data,'Parent',v.AxesHandle);
                
                v.attachContextMenu;
                % Set axes
                xres=v.spm.PointsPerLine;
                yres=v.spm.PointsPerLine;
                xreal=v.spm.Height;
                yreal=v.spm.Width;
                
                nb_ticks=2;
                
                set(v.AxesHandle,'XTick',0:xres/nb_ticks:xres,'XTickLabel',num2cell(0:floor(xreal/nb_ticks):xreal));
                set(v.AxesHandle,'YTick',0:yres/nb_ticks:yres,'YTickLabel',num2cell(0:floor(yreal/nb_ticks):yreal));
                
                xlabel(v.AxesHandle,['X (' v.ch.Units ')']);
                ylabel(v.AxesHandle,['Y (' v.ch.Units ')']);
                
                title(v.spm.Filename);
                set(v.AxesHandle,'CLimMode','auto');
            end
        end
    end
end


% Function handle
function changeChannel(src,event,i)
v=i{1};
nch=i{2};

v.ch = nch;
v.draw;
end