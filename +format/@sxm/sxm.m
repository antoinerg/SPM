classdef sxm < SPM.spm
    % Mandatory fields for the interface
    properties(SetAccess='protected')
        Channel;
        Date;
        Width;
        Height;
        Format;
        Type;
    end
    
    properties
        %PointsPerLine;
        %Lines;
    end
    
    methods
        function sxmObj = sxm(path)
            % Loads an nanonisspectrum (.dat) file 
            sxmObj = sxmObj@SPM.spm(path);
            if sxmObj.FromCache==false
                sxmObj.Format='sxm';
                parseHeader(sxmObj);
            end
        end
        
    end
    
    methods(Access='private')
        % External file functions
        parseHeader(sxmObj);
    end
    
    methods(Access='public',Static=true)
        % External file functions
        bool=is_valid_format(filename);
    end
    
    methods(Static=true,Access='private')
        % External file functions
    end
end