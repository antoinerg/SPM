classdef channel < SPM.channel
    properties(Hidden=true)
        id;
    end
    
    properties(Hidden=true,SetAccess='protected')
        rawData=[];
        Data=[];
    end
    
    methods
        function nsch = channel(ns)
            if (~isa(ns,'SPM.parser.nanonisspectrum.spm')), MException('Parent must be a nanonispectrum object');end;
            nsch.spm = ns;
        end
        
        function Data = get.Data(nsch)
            if isempty(nsch.Data)
                nsch.convertRawData;
            end
            Data=nsch.Data;
        end
        
        function rawData = get.rawData(nsch)
            if isempty(nsch.rawData)
                nsch.loadRawData;
            end
            rawData=nsch.rawData;
        end 
    end
    
    methods(Access='private')
        convertRawData(nsch)
        loadRawData(nsch)
    end
end

