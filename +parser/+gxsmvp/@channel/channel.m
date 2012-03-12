classdef channel < SPM.channel
% gxsmvp channel

    properties(Hidden=true)
        pos
    end
    
    properties(Hidden=true,SetAccess='protected')
        rawData=[];
        Data=[];
    end
    
    methods
        function vpch = channel(sdf)
            if (~isa(sdf,'SPM.parser.gxsmvp.spm')), MException('Parent must be a gxsmvp object');end;
            vpch.spm = sdf;
        end
        
        function Data = get.Data(vpch)
            if isempty(vpch.Data)
                vpch.Data=vpch.rawData;
            end
            Data=vpch.Data;
        end
        
        function rawData = get.rawData(vpch)
            if isempty(vpch.rawData)
                vpch.loadRawData;
            end
            rawData=vpch.rawData;
        end
    end
    
    methods(Access='private')
        convertRawData(vpch)
        loadRawData(vpch)
    end
end

