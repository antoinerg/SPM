function struct = xml_read_xinclude(filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
parserFactory = javaMethod('newInstance',...
    'javax.xml.parsers.DocumentBuilderFactory');
javaMethod('setXIncludeAware',parserFactory,true);
javaMethod('setNamespaceAware',parserFactory,true);

p = javaMethod('newDocumentBuilder',parserFactory);
xdoc=xmlread(filename,p);
struct=SPM.lib.xml_io_tools.xml_read(xdoc);

end