classdef nanoscope5channel < SPM.channel
    properties(Hidden=true)
        pos;
        scaling;
        zsens;
    end
    properties(Hidden=true,SetAccess='protected')
        rawData=[];
        Data=[];
    end
    
    methods
        function n5ch = nanoscope5channel(n5)
            if (~isa(n5,'SPM.format.nanoscope5')), MException('Parent must be a nanoscope5 object');end;
            n5ch.spm = n5;
        end
        
        function Data = get.Data(sfchannel)
            if isempty(sfchannel.Data)
                sfchannel.convertRawData;
            end
            Data = sfchannel.Data;
        end
        
        function rawData = get.rawData(sfchannel)
            if isempty(sfchannel.rawData)
                sfchannel.loadRawData;
            end
            rawData=sfchannel.rawData;
        end
        
    end
    
    methods(Access='private')
        convertRawData(sfchannel);
        loadRawData(sfchannel);
    end
end

