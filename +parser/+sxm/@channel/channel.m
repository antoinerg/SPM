classdef channel < SPM.channel
    properties(Hidden=true)
        id;
        pos;
    end
    
    properties(Hidden=true,SetAccess='protected')
        rawData=[];
        Data=[];
    end
    
    methods
        function sxmch = channel(ns)
            if (~isa(ns,'SPM.parser.sxm.spm')), MException('Parent must be a sxm object');end;
            sxmch.spm = ns;
        end
        
        function Data = get.Data(sxmch)
            if isempty(sxmch.Data)
                sxmch.convertRawData;
            end
            Data=sxmch.Data;
        end
        
        function rawData = get.rawData(sxmch)
            if isempty(sxmch.rawData)
                sxmch.loadRawData;
            end
            rawData=sxmch.rawData;
        end 
    end
    
    methods(Access='private')
        convertRawData(sxmch)
        loadRawData(sxmch)
    end
end

