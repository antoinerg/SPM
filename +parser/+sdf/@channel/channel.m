classdef channel < SPM.channel
    properties(Hidden=true)
        id
        n0
        n1
        d0
        d1
        pos
    end
    
    properties(Hidden=true,SetAccess='protected')
        rawData=[];
        Data=[];
    end
    
    methods
        function sfch = channel(sdf)
            if (~isa(sdf,'SPM.parser.sdf.spm')), MException('Parent must be a sdf object');end;
            sfch.spm = sdf;
        end
        
        function Data = get.Data(sfchannel)
            if isempty(sfchannel.Data)
                sfchannel.convertRawData;
            end
            Data=sfchannel.Data;
        end
        
        function rawData = get.rawData(sfchannel)
            if isempty(sfchannel.rawData)
                sfchannel.loadRawData;
            end
            rawData=sfchannel.rawData;
        end
    end
    
    methods(Access='private')
        convertRawData(sfchannel)
        loadRawData(sfchannel)
    end
end

