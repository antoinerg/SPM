function parseHeader(vp)
% VP = VPREAD(filename)
%
%   returns vector probe data as a structure, vp, having easily accessible
%   fields
%
%   where it made sense, I have kept the capitalization and name
%   conventions that are used in the vpdata files
%   Fields:
%       Bias:       sample bias (from header)
%
%       comment:    GXSM main window comment box
%
%       Current:    current setpoint (from header)
%
%       datenum:    a serial date number which might be useful for
%                   processing in Matlab
%
%       datestr:    a date string in Matlab default format 
%                   e.g. '24-Oct-2003 12:45:07'
%
%       filename:   the original filename (from the vpdata file)
%
%       fileparts:  broken up filename with the sub-fields
%           pathstr:    path
%           name:       name (this could be useful for titling plots)
%           ext:        extension
%
%       Npoints:    TOTAL number of points
%
%       Nspectro:   number of spectro curves.  This is NOT the value from
%                   the header (#IV).  It is inferred from the number of
%                   sections ("VP-Section") of type '1' in the Section
%                   Boundaries header: vp.SB.VP_Section.  Why type 1 and
%                   not 0?  Because type 0 is not recorded unless "Full
%                   Ramp" recording is enabled.
%
%       offset:     subfields contain offset information
%                   These are just the gobal X0 and Y0 offsets.  To find
%                   the actual location of a vector probe, X0/Y0 need to be
%                   added to XS/YS which are usually zero.  Note that they
%                   will be nonzero if the scan was paused to take a VP, or
%                   if raster probe was enabled.
%           X0:     X offset (from header)
%           Y0:     Y offset (from header)
%
%       rawData:    raw data from the recorded channels, duplicates removed
%                   example of sub-fields: ZS, ADC0, ADC3, Bias ...
%                   Additionally, there are subfields created by vpread to
%                   help interface with rawData.  These are the same size
%                   as rawData vectors.
%           nspectro:   the repeat-number corresponding to the current
%                       spectro data (note that vp.Nspectro is the total
%                       number of spectra, vp.rawData.nspectro is the
%                       current specto)
%           VP_Section: the VP_Section number (found in Section Boundaries
%                       header corresponding to the current data point
%                   As an example, pull out just the 1st spectro data of
%                   ADC0: 
%                   vp.rawData.ADC0(vp.rawData.nspectro==1)
%                   Or, plot the data for 1st spectro, retract (which we
%                   know is Section #2 for a Z spectro):
%                   plot(vp.rawData.ADC0(vp.rawData.VP_Section==1&vp.rawData.nspectro==2))
%
%       rawDataMatrix:  the raw data matrix
%
%       rawDataMatrixCols:  the column titles of the rawDataMatrix
%
%       rawIndex:   the column index of the rawData channels that were
%                   extracted from the rawDataMatrix (duplicates removed)
%
%       SB:         section boundary position vector list from header
%
%       VPHLcols:   the names of the VP Header List columns (in appendix)
%
%       VPHL:       the data found in the VP Header List.  Refer to
%                   VPHLcols for the meaning of the columns.
%
%       Z0:         Z offset extracted from the column named 'Z[Ang]'.  If
%                   this column name is not found, Z0 will be assigned NaN.
%       
%   The parser is insensitive to the order in which lines appear, so if
%   they shuffle around, it shouldn't break.  The parser does however get
%   locked reading consecutive lines when it starts reading the comments
%   section. It reads until it finds the next field it expects to see - so
%   order does matter here (i.e. the next thing that comes after comments
%   should always come after comments).  It also does something similar
%   with the appendix section.  It reads consecutive lines in a while loop
%   until it breaks when it finds the appendix end tag.
%
%   Revisions:
%
%   2012-02-07 : Changed vp.SB.VP to vp.SB.Index to correspond to the
%   column name used for the data section.  Changed the way Nspectro is
%   inferred -- now looks at the Section Boundaries header info rather
%   than the Vector Probe Header List appendix which is currently missing
%   when recording raster-probe VPs (updated above).  Added
%   vp.rawData.nspectro and vp.rawData.VP_Section.
%
%   2012-02-06 : Remove the interpretation of data fields in order to have
%   just parsed data.  Implement comment section reading.  Implement full
%   VP header list appendix reading.  Improve commenting.  Add field
%   descriptions.  Drop reading #IV and deduce Nspectro from appendix.
%   Pre-allocate data matrix size (45s -> 19s on a 50010 data point file).
%   Monopolize parser while reading data to reduce number of times through
%   the large while loop (19s -> 7s on a 50010 data point file).
%
%   William Paul
%   McGill University
%   started September 10, 2011

fid = fopen(vp.Path,'r');
myLine = fgetl(fid);
myLineIndex = 1;

% the following while loop contains header strings to look for.  If a newly
% read line has at least the right number of characters in it, then the
% header string is checked for at the beginning of the line.  If the header
% string is found, then various parameters in the line are read.

% data lines are identified by checking if the first character of the line
% is a number.
while ischar(myLine)
    % date
    myHeader = '# Date';
    if strfind(myLine,myHeader) 
	myPattern = 'date=';
        myField = myLine((strfind(myLine,myPattern)+length(myPattern)):end);
        vp.Datenum = datenum(myField, 'ddd mmm dd HH:MM:SS');
        vp.Date = datestr(vp.Datenum);
    end

    % offset
    myHeader = '# GXSM-Main-Offset';
    if strfind(myLine,myHeader)
       myPattern = ' X0';
       x0 = strfind(myLine,myPattern)+length(myPattern);
       myPattern = ' Y0';
       y0 = strfind(myLine,myPattern)+length(myPattern);
       myPattern = 'Ang';
       a = strfind(myLine,myPattern);
       myField = myLine(x0+1:a(1)-1);
       vp.Offset.X0 = str2num(myField);
       myField = myLine(y0+1:a(2)-1);
       vp.Offset.Y0 = str2num(myField);
    end

   % FB parameters
   myHeader = '# GXSM-DSP-Control-FB';
   if strfind(myLine,myHeader)
     myPattern = ' Bias';
     b(1) = strfind(myLine,myPattern)+length(myPattern);
     myPattern = ' V';
     b(2) = strfind(myLine,myPattern);
     myField = myLine(b(1)+1:b(2)-1);
     vp.Header.Bias = str2num(myField);
     myPattern = ' Current';
     b(1) = strfind(myLine,myPattern)+length(myPattern);
     myPattern = ' nA';
     b(2) = strfind(myLine,myPattern);
     myField = myLine(b(1)+1:b(2)-1);
     vp.Header.Current = str2num(myField);
   end

    % comment
    myHeader = '# GXSM-Main-Comment';
    if strfind(myLine,myHeader)
	    c=textscan(myLine,'# GXSM-Main-Comment\t:: comment="%s')
	    vp.Header.Comment = c;
    end
    % # of points
    myHeader = '# Probe Data Number';
    if strfind(myLine,myHeader)
	npoints=textscan(myLine,'# Probe Data Number\t:: N=%n');	
	vp.NPoints = npoints{:};
    end

    % Channels to read
    myHeader = '#C Index';
    if strfind(myLine,myHeader)
	        % get names of columns
		columns=textscan(myLine,'%s','Delimiter','\t');
		columns=strrep(columns{:},'"','');
		for i=2:length(columns)
			vpch=SPM.parser.gxsmvp.channel(vp);
			C=textscan(columns{i},'%s (%[^)])');
			vpch.Name = C{1}{1};
			try,vpch.Units = C{2}{1};catch,end
			vpch.pos = i;
			vp.Channel=cat(1,vp.Channel,vpch);
		end
    end
    if( (-1)==line ), eof  = 1; end % End of file condition
% get another line
myLine = fgetl(fid);
myLineIndex = myLineIndex+1;
end

fclose(fid);
end % End parseHeader
