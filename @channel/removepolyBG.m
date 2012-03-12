function nch = removepolyBG(channel,ordver,ordhor)
% Remove polynomial background
ch=channel;
params=[ordver,ordhor];
h=findobj(ch.spm.UserChannel,'Type','removepolyBG','-and','ParentChannel',ch,'-and','Parameters',params);

if ~isempty(h)
    disp('From cache');
    nch=h;
else
    nch = SPM.parser.userchannel;
    nch.ParentChannel=ch;
    nch.Name = [ch.Name ' | REMOVEDPOLYBG (' num2str(ordver) ',' num2str(ordhor) ')'];
    nch.spm = ch.spm;
    nch.Units = ch.Units;
    nch.Parameters = params;
    nch.Direction = ch.Direction;
    nch.setData(computeData(ch.Data));
    nch.Type = 'removepolyBG';
    
    ch.spm.UserChannel = cat(1,ch.spm.UserChannel,nch);
end
    function out=computeData(data)
        out=data-surfit(data,ordver,ordhor);
    end
end


% Code below was found on internet.
% Would be cleaner to move to the curve fitting toolbox scripts

function BAS=surfit(D,ORDVER,ORDHOR)
%	polynomial SURface FIT with separate orders
%   in vertical and horizontal directions
%Input:
%		D = matrix
%		ORDVER polynomial ORDer for VERtical fit, def. 1
%       ORDHOR polynomial ORDer for HORizontal fit, def. ORDVER
%Output:
%       BAS = Fitted Surface
%--------------------------------
% Demo
%       [X,Y]=meshgrid(1:100,1:100);
%       D=(X.^3/100-X.*Y+3000-Y.^2/2)/1000;
%       F=surfit(D,2,3);
%       norm(D(:)-F(:),Inf)
% ----------------------------------
%See also: POLYFIC, POLYVAC
%    Vassili Pastushenko,	11.11.2004. [PFE]
%==============================================================
NAR=nargin;
if NAR<1, error('Data needed'),end
if NAR<2,ORDVER=1;end
if NAR<3,ORDHOR=ORDVER;end
[R,C]=size(D);
x=(0:C-1)/(C-1);
y=(0:R-1)/(R-1);
BAS=polyfic(y,D,ORDVER);
BV=polyvac(BAS,y)';
V=polyfic(x,BV,ORDHOR);
BAS=polyvac(V,x)';
end

function D = polyvac(V,x)
%POLYnomial VAlues of vectors corresponding to Columns
%POLYVAC = generalization of POLYFIT,
% for matrices V(ORD+1,512) acceleration abou 7 to 12 times
%compared to POLYVAL
%
% Call:
%               V = polyfic(V,x)
%
%Input:     x = vector (independent variable)
%           V = columns of polynomial coefficients, usually produced by POLYFIC
%Output
%           D = data, matrix length(x)*size(V,2)
%           see also POLYFIC
%Vassili Pastushenko Aug. 2 2004

x=x(:);
%Vandermond
W=ones(size(x));
LEV=size(V,1);
for i=2:LEV
    W(:,i)=W(:,i-1).*x;
end
W=fliplr(W);
D=W*V;
end

function V = polyfic(x,y,ORD)
%   Matlab function POLYFIT(x,y,ORD) allows only the same size of
%   x and y inputs. If x is a vector of N elements, and
%   size(y) =[N, M], and one needs to fit each column of y with a polynomial,
%   POLYFIT can only be used in connection with some loop FOR, WHILE etc.
%   This essentially decreases the practical power of MATLAB, and can become quite
%   nasty, especially in the case of big matrices (image analysis: tyoically 512*512).
%   Program POLYFIC allows to fit colomns, using the power of matrix operations, which
%   leads to acceleration 20 to 80 times (512*512, ORDers 1:15)
%
%POLYFIC = POLYnomial FIT of Columns: generalization of POLYFIT
% Fits polynomials of degree ORD to columns of data.
%
% Call:
%               V = polyfic(x,y,ORD)
%
%Input:     x = vector of independent variable
%           y = data
%           ORD = polynomial order (ORD=3 for cubic)
%Output
%           V = polynomials in columns, matrix ORD+1 * nColumns(y)
%           See also: POLYVAC
%Vassili Pastushenko Aug. 2 2004

x=x(:); %Make column of x;
[R,C]=size(y);

LX=length(x);

%Vandermond
V=ones(size(x));
for i=2:2*ORD+1
    V(:,i)=V(:,i-1).*x;
end
V=fliplr(V);
VV=sum(V);
for i=1:ORD+1
    M(i,:)=VV(i:i+ORD);
end
R=V(:,ORD+1:2*ORD+1);
B=(y.'*R)';
V=M\B;
end




