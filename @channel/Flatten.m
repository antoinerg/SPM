function nch=Flatten(channel)
%FLATTEN Return custom channel with flattened data
%Substract every data on a line by the mean value of this line
ch=channel;
h=findobj(ch.spm.UserChannel,'Type','Flatten','-and','ParentChannel',ch);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.parser.userchannel;
    nch.ParentChannel=ch;
    nch.Type = 'Flatten';
    nch.Name = [ch.Name ' | FLATTEN'];
    nch.Units = ch.Units;
    nch.spm = ch.spm;
    nch.Direction = ch.Direction;
    nch.setData(computeFlatten(ch.Data));
    
    ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
end

    function out=computeFlatten(A)
        [row,col]=size(A);
        for i=1:row
            A(i,:) = A(i,:) - mean( A(i,:));
        end
        out=A;
    end
end

