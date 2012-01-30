function map = gold(n)
%GOLD Gold colormap from Gwyddion

if nargin < 1
   n = 64;
end

% Definition of colormap
colors=[0,0,0; ...
       88,28,0; ...
       188,128,0; ...
       252,252,128];

% Output of the properly formatted colormap for use with CONTOUR, SURF and
% PCOLOR
map=zeros(n*(length(colors)-1),3);
for i=1:length(colors)-1
    for j=1:3
        map((i-1)*n+1:i*n,j)=linspace(colors(i,j),colors(i+1,j),n);
    end
end
map=map./255;
%%

end

