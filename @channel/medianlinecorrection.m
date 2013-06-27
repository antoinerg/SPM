function nch=medianlinecorrection(channel)
%medianlinecorrection Return custom channel with corrected data
%Substract every data on a line by the median value of this line and the
%median of the already corrected line above
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','Median line correction','-and','ParentChannel',ch);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.parser.userchannel;
    nch.ParentChannel=ch;
    nch.Type = 'Median line correction';
    nch.Name = [ch.Name ' | Median Line Correction'];
    nch.Units = ch.Units;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    nch.setData(computeMedianline(ch.Data));
    
    ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
end

    function out=computeMedianline(A)
        [row,col]=size(A);
        for i=1:1
            A(i,:) = A(i,:) - median( A(i,:));
        end
        for i=2:row
%            A(i,:) = A(i,:) - 0*median( A(i,:)) - (median( A(i,:)) - median( A(i-1,:)));
             A(i,:) = A(i,:) - (median( A(i,:)) - median( A(i-1,:)));
        end
        out=A;
    end
end

