function val = extract_number(str)
% Function to extract number from string in header


%Ascii table of relevant numbers
%character    ascii code
%  e          101
%  E          69
%  0          48
%  1          49
%  2          50
%  3          51
%  4          52
%  5          53
%  6          54
%  7          55
%  8          56
%  9          57

eos = 0;
R = str;

while(~eos)
    
    [T,R] = strtok(str);
    if( length(R) == 0) eos = 1; end
    I = find( (T>=48) & (T<=57) | 101==T | 69==T | T==173 | T== 45 | T==46 | T==40);
    
    LT = length(T);
    LI = length(I);
    
    if( LI == LT )
        J = find(T~='(');
        val = str2num(T(J));
        break
    end
    str =R;
end
end