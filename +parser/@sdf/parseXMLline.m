function [xml name attr] = parseXMLline(line)
% Read a line and return whether it is a an XML declaration.
% If it is it will return the name of the element along
% with a struct representing the attributes.
name='';attr='';xml=false;
expr='^<([^\s]+) ([^>]*)>';
[s,tokens] = regexp(line,expr,'start','tokens');
if (s)
    xml=true;
    tokens=tokens{1};
    name=tokens(1);
    attributes=tokens(2);
    
    expr='([^=]+)="([^"]+)"';
    [tokens] = regexp(attributes,expr,'tokens');
    tokens=tokens{1};
    
    attr=struct;
    for i=1:length(tokens)
        field=tokens{i};
        eval(['attr.' field{1} '=field{2};']);
    end
end
end