%% Computes that field at the relevant points

function h = computeField(data,type)

% Extract data from structure
% 
% Define complexified coordinate
% Z = X + 1i*Y;
% Zup = Z(X>=Y*d/s); % Upsteam region
% Zut = Z(X<Y*ds/s | X>=d); % Upstream triangle
% Zre = Z(X<d | X>=2); % Middle rectangle
% Zdt = Z(X>=2 + Y*d/s | X<2); % Downstream triangle
% Zdn = Z(X>=2); % Downstream region
% 
% upstream = field(data,type);
% upperTriangle = acousticFieldUpperTriangle(data,type);
% rectangle = acousticFieldRectangle(data,type);
% lowerTriangle = acousticFieldLowerTriangle(data,type);
% downstream = acousticFieldDownstream(data,type);
% 
% m = [1,1,1,1,size(kx,5)];
% 
% 

h = @(Z) evaluateField(Z,data);
h(rand(50))
function field = evaluateField(Z,data)

spac = data.spac;
d = spac(1); s = spac(2);
LPa = data.LPa(:).'; % Row vector of Lambda^+
ZPa = data.ZPa(:).'; % Row vector of Zeta^+
spac = data.spac;
SQRT = data.SQRTa(:).'; % Row vector of SQRT    
% Partition Z into different sections 
Zsz = size(Z); % Original size of Z
Z = Z(:); % Turn Z into a column vector
X = real(Z); Y = imag(Z);

Xre = X(X<d | X>=2); Yre = Y(X<d | X>=2);  % Middle rectangle
Xdt = X(X>=2 + Y*d/s | X<2); Ydt = X(X>=2 + Y*d/s | X<2); % Downstream triangle
Xdn = X(X>=2); Ydn = X(X>=2);  % Downstream region


% Calculate upstream field
data.comb=[1,0,1,0];
Xup = X(X>=Y*d/s); Yup = Y(X>=Y*d/s);  % Upsteam region
D13LP = D(LPa,data); %  D^{(1,3)} evaluated at Lambda^+
AR = AdR(Xup,Yup,LPa,ZPa,SQRT,spac) + AuR(Xup,Yup,LPa,ZPa,SQRT,spac); % 
phiUp = pi*1i*AR*D13LP.';

% Calculate upper triangular field
Xut = X(X<Y*d/s | X>=d); Yut = Y(X<Y*d/s | X>=d); % Upstream triangle
phiUt = pi*1i*AuR(Xup,Yup,LPa,ZPa,SQRT,spac)*D13LP.';



phi = zeros(

    end






end

% upstream(repmat(X>=Y*d/s,m))=0;
% upperTriangle(repmat(X<Y*d/s | X>=d,m))=0;
% rectangle(repmat(X<d | X>=2,m))=0;
% lowerTriangle(repmat(X>=2+Y*d/s | X<2,m))=0;
% downstream(repmat(X-2<Y*d/s,m))=0;
%









