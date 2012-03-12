classdef spm < SPM.spm
% GXSM vector probe parser

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
        Datenum;
	NPoints;
        %Lines;
    end
    
    methods
        function vp = spm(path)
            % Loads an nanonisspectrum (.dat) file 
            vp = vp@SPM.spm(path);
            if vp.FromCache==false
                vp.Format='sxm';
                parseHeader(vp);
            end
        end
        
    end
    
    methods(Access='private')
        % External file functions
        parseHeader(vp);
    end
    
    methods(Access='public',Static=true)
        % External file functions
        bool=is_valid_format(filename);
    end
    
    methods(Static=true,Access='private')
        % External file functions
    end
end
