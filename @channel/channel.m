classdef channel < hgsetget
    properties
        Name
        Units
        Direction='Forward';
    end
    
    properties(Hidden=true,SetAccess='protected')
        spm 
    end
    
    properties(Abstract=true,Hidden=true,SetAccess='protected')
        Data;
        rawData;
    end
    
    methods
       
        function nch=copyChannel(ch)
            nch = SPM.parser.userchannel;
            nch.ParentChannel=ch;
            nch.Type = '';
            nch.Name = ch.Name;
            nch.Units = ch.Units;
            nch.Direction = ch.Direction;
            nch.spm = ch.spm;
            nch.setData(ch.Data);
            
            ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
        end
        
        % UNIFY REFERENCING TO CHANNELS : s.Channel(5), s.Channel('friction')
        %
        %         function [sref]=subsref(ch,s)
        %             if strcmp(s(1).type,'()') && ischar(s(1).subs{1})
        %                 [sref]=findobj(ch,'Name',s.subs{1});
        %             else
        %                 [sref]=builtin('subsref',ch,s);
        %             end
        %         end
        
        function v=plot(ch,varargin)
            v=SPM.viewerModule.view(ch,varargin{:});
            v.draw;            
        end
       
    end
end