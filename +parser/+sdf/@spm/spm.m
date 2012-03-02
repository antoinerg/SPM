classdef spm < SPM.spm
% sdf spm
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
        PointsPerLine=0;
        Line=0;
    end
    
    methods
        function sf = spm(path)
            % Loads an SDF file with given filename sdf(filename)
            sf = sf@SPM.spm(path);
            if sf.FromCache==false
                sf.Format='sdf';
                parseHeader(sf);
            end
        end
        
        function nb = get.PointsPerLine(sfchannel)
            if (sfchannel.PointsPerLine==0)
                sfchannel.getPointsPerLine;
            end
            nb=sfchannel.PointsPerLine;
        end
        
        function nb = get.Line(sfchannel)
            if (sfchannel.Line==0)
                sfchannel.getLine;
            end
            nb=sfchannel.Line;
        end
    end
    
    methods(Access='private')
        % External file functions
        parseHeader(sf);
        ch=getChannelById(sf,id);
        getPointsPerLine(sf);
        getLine(sf);
    end
    
    methods(Access='public',Static=true)
        % External file functions
        bool=is_valid_format(filename);
    end
    
    methods(Static=true,Access='private')
        % External file functions
        [empty name attr] = parseXMLline(line);
    end
end
