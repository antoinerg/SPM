classdef userchannel < SPM.channel
    properties
        ParentChannel
        Type
        Parameters
        UserData
    end
    
    properties(Hidden=true)
       UserObj; 
    end
    
    properties(Hidden=true,SetAccess='protected')
       rawData=[];
       Data=[];
    end
    
    methods
        function Data = get.Data(cch)
            Data=cch.Data;
        end
        function rawData = get.rawData(cch)
            rawData=cch.rawData;
        end
        
        function setData(cch,data)
            cch.Data=data;
        end
        
        function Delete(cch)
            ch2Delete=findobj(cch.spm.UserChannel,'ParentChannel',cch);
            ch2Delete=vertcat(ch2Delete,cch);
            
            for i=1:length(ch2Delete)
                cch.spm.UserChannel(cch.spm.UserChannel==ch2Delete(i))=[];
            end
            
            if size(cch.spm.UserChannel) == [1,0]
                cch.spm.UserChannel = [];
            end
        end
    end
end

