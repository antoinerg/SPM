classdef nanoscope5 < SPM.spm
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
        PointsPerLine;
        Lines;
    end
    
    methods
        function n5 = nanoscope5(path)
            % Loads an SDF file with given filename sdf(filename)
            n5 = n5@SPM.spm(path);
            if n5.FromCache==false
                n5.Format='nanoscope5';
                parseHeader(n5);
            end
        end
        
    end
    
    methods(Access='private')
        % External file functions
        parseHeader(sf);
    end
    
    methods(Access='public',Static=true)
        % External file functions
        bool=is_valid_format(filename);
    end
    
    methods(Static=true,Access='private')
        % External file functions
        val = extract_number(str);
    end
end