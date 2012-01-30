function Save(spm)
%Save current state of object to hard drive
%Filepath to the saved file is computed in cachedFile method which reads
%the configuration file.

%Get the filepath and filename of the soon to be cached file
[path_cached_file,cached_filename] = spm.cachedFile;

%We generate a dummy variable from the filename and store the object in it
saved_variable_name = genvarname(spm.Filename);
str=[saved_variable_name '=spm;'];
eval(str);

%We then save this dummy variable
str=['save ' path_cached_file ' ' saved_variable_name ';'];
eval(str);
disp('Object saved');
end