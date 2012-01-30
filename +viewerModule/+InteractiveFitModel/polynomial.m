classdef polynomial < SPM.viewerModule.InteractiveFitModel.AbstractFitModel
    %POLYNOMIAL
    
    properties
        Name='polynomial';
        fitType=fittype('poly2');
        fitOptions=fitoptions(fittype('poly2'));
    end
    
    methods
        function obj=polynomial(box)
            obj = obj@SPM.viewerModule.InteractiveFitModel.AbstractFitModel(box);
        end
        function display(fitModel)
            display@SPM.viewerModule.InteractiveFitModel.AbstractFitModel(fitModel);
        end
        
        function fitData(fitModel)
            ydata=fitModel.Box.Parent.Channel.Data';
            xdata=fitModel.Box.Parent.xChannel.Data';
            fitModel.excludeOutside;
            fitModel.fit = fit(xdata,ydata,fitModel.fitType,fitModel.fitOptions);            
        end
        
    end
end

