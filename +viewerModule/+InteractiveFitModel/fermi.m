classdef fermi < SPM.viewerModule.InteractiveFitModel.AbstractFitModel
    %Classical regime as presented in Lynda's thesis
    
    properties
        Name='fermi';
        fitType;
        fitOptions=[];
    end
    
    methods
        function obj=fermi(box)
            obj = obj@SPM.viewerModule.InteractiveFitModel.AbstractFitModel(box);
        end
        
        function display(fitModel)
            fitPanel=fitModel.fitPanel;
            % Build the lower, startpoint, higher boxes
            coeff=coeffnames(fitModel.fitType);
            LowerPoint=fitModel.fitOptions.Lower;
            sPoint=fitModel.fitOptions.Startpoint;
            UpperPoint=fitModel.fitOptions.Upper;
            left=0;bottom=0;width=50;height=20;
            
            function changeStartPoint(src,evt,fitModel,i)
                box=fitModel.Box;
                newsPoint=str2num(get(src,'String'));
                fitModel.fitOptions.StartPoint(i)=newsPoint;
                notify(box.Parent,'selectionBoxChanged');
            end
            
            for i=1:length(coeff)
                uicontrol('Parent',fitPanel,'Style','text','String',coeff{i},...
                    'Units','Pixels','Position',[left bottom+i*(height) width height],'HorizontalAlignment','left',...
                    'FontSize',12);
                lowerBox=uicontrol('Parent',fitPanel,'Style','edit','Units','Pixels',...
                    'Position',[left+width bottom+i*(height) width height],'String',LowerPoint(i)...
                    );
                startBox=uicontrol('Parent',fitPanel,'Style','edit','Units','Pixels',...
                    'Position',[left+2*width bottom+i*(height) width height],'String',sPoint(i),...
                    'Callback',{@changeStartPoint,fitModel,i});
                endBox=uicontrol('Parent',fitPanel,'Style','edit','Units','Pixels',...
                    'Position',[left+3*width bottom+i*(height) width height],'String',UpperPoint(i)...
                    );
            end
            
            % Display the default output
            display@SPM.viewerModule.InteractiveFitModel.AbstractFitModel(fitModel);
        end
        
        function fitData(fitModel)
            ydata=fitModel.Box.Parent.Channel.Data';
            xdata=fitModel.Box.Parent.xChannel.Data';
            fitModel.excludeOutside;
            fitModel.guessXpeak;
            fitModel.fit = fit(xdata,ydata,fitModel.fitType,fitModel.fitOptions);
        end
        
        function out=get.fitType(fitModel)
            x=sym('x');Vo=sym('Vo');c=sym('c');beta=sym('beta');b=sym('b');
            kb=1.3806488E-23;
            q=1.602176565E-19;
            %T=77;
            factor=q/(2*kb);
            %fermi=1/(exp(alpha*(x-Vo))+1);
            %eqn=c*fermi*(1-fermi)+b;
            eqn=c*cosh(factor*beta*(x-Vo))^-2;
            eqn=SPM.viewerModule.InteractiveFitModel.sym2str(eqn);
            out=fittype(eqn);
        end
        
        function out=get.fitOptions(fitModel)
            if isempty(fitModel.fitOptions)                
                % Prepare the fitOptions object
                fo = fitoptions(fitModel.fitType);
                fo.Startpoint=[0 0.001 1];
                fo.Lower=[-10 0 0];
                fo.Upper=[10 1 Inf];
                fo.Robust='on';
                fo.MaxIter=1e7;
                fitModel.fitOptions = fo;
                fitModel.guessXpeak;
            end
            out = fitModel.fitOptions;
        end
        
        function guessXpeak(fitModel)
            ydata=fitModel.Box.Parent.Channel.Data';
            xdata=fitModel.Box.Parent.xChannel.Data';
            %Guess initial values
            outside=fitModel.Outside;
            [c,i]=max(ydata(~outside));
            xpeak=xdata(~outside);xpeak=xpeak(i);
            fitModel.fitOptions.Startpoint(1)=xpeak;
        end
    end
end

