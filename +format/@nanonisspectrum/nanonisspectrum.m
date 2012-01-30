classdef nanonisspectrum < SPM.spm
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
        function nspectrum = nanonisspectrum(path)
            % Loads an nanonisspectrum (.dat) file 
            nspectrum = nspectrum@SPM.spm(path);
            if nspectrum.FromCache==false
                nspectrum.Format='nanonisspectrum';
                parseHeader(nspectrum);
            end
        end
        
    end
    
    methods(Access='private')
        % External file functions
        parseHeader(nspectrum);
    end
    
    methods(Access='public',Static=true)
        % External file functions
        bool=is_valid_format(filename);
    end
    
    methods(Static=true,Access='private')
        % External file functions
    end
end