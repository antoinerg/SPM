function XMLdump(spm)
%XMLDUMP Dump a summary of the object in XML

f=get(spm);

for i=1:length(spm.Channel)
    Channel(i)=get(spm.Channel(i));
end
f=rmfield(f,'Channel');
f=setfield(f,'Channel',Channel);

L = length(spm.UserChannel);
if L > 0
    for i=1:L
        uc=get(spm.UserChannel(i));
        UserChannel(i)=rmfield(uc,'ParentChannel');
    end
    f=rmfield(f,'UserChannel');
    f=setfield(f,'UserChannel',UserChannel);
end

Pref=[]; Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
Pref.StructItem=false;

% Prepare final XML
final = [];
% Read the original XML
original=spm.XML;
% Final is original with overwritten "Package" part
final = setfield(original,'Package',f);

SPM.lib.xml_io_tools.xml_write(spm.XMLDataFile,final,'SPM',Pref);

end

