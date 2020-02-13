function [newADData,newAAData] = prepareData(ADData,AAData)

newADData = ADData;
newAAData = AAData;

M = ADData.M;
Udim = M*ADData.c0;
Wdim = ADData.Wdim;
Beta = sqrt(1-M^2);
newADData.Beta = Beta;
chordDim = ADData.chordDim;
semiChordDim = chordDim/2;
omegaDim = AAData.omegaDim;
omega = AAData.omega;
kx = AAData.kx;
kxDim = AAData.kxDim;
kyDim = AAData.kyDim;
kzDim = AAData.kzDim;

s = ADData.spacDim(1)*Beta/semiChordDim; % Update space with PG transformation and non-dim
d = ADData.spacDim(2)/semiChordDim;

newADData.spac(1) = s;
newADData.spac(2) = d;

newADData.spac(3) = sqrt(d^2+s^2); % Do PG transformation
newADData.chie = atan(d/s); % Do PG transformation


if isempty(omega)
    omega = semiChordDim/Udim*(omegaDim - Wdim*kzDim);
elseif isempty(omegaDim)
    omegaDim = omega*Udim/semiChordDim + Wdim*kzDim;
else
    error('Cannot set both the dimensional and reduced frequency simultaneuously.');
end

% Give the frequency a small imaginary part
omega = omega*(1+1e-5i);

if strcmp(kxDim,'gust') || strcmp(kx,'gust')
    kx = omega;
    kxDim = (kx - M^2*omega)/Beta^2/semiChordDim;
    newAAData.kxDim = kxDim;
elseif isempty(kxDim)
    kxDim = (kx - M^2*omega)/Beta^2/semiChordDim;
else
    kx = kxDim*Beta^2*semiChordDim + M^2*omega;
    omega = kx*(1+1e-5i); % Give the frequency a small imaginary part
end


ky = kyDim*semiChordDim/omega/Beta;
kz = kzDim*semiChordDim/omega;

if isempty(AAData.kyDim)
    sigmao = AAData.sigmao;
    sigma= d*omega*(M/Beta)^2 + sigmao;
    ky =  (sigma - kx/Beta^2*d)/(omega*s);
elseif isempty(AAData.sigmao)
    ky = AAData.kn;
    sigma = kx/Beta^2*d + omega*ky*s;
    sigmao= sigma - d*omega*(M/Beta)^2;
end    

newAAData.sigma = sigma;
newAAData.sigmao = sigmao;
newAAData.omega = omega;
newAAData.omegaDim = omegaDim;
newAAData.kxDim = kxDim;
newAAData.kx = kx;
newAAData.ky = ky;
newAAData.kz = kz;

newAAData.Amp = [0,1i*omega*ky,0];

w=mysqrt(M/Beta^2,kz/Beta); % Need to spanwise flow terms.
newAAData.w=w;

C = ADData.C;

switch ADData.case
    case 1
    
        mu = C*[1,0,0];
   
    case 2
    
        mu0 = 1i*omega/Beta^2;
        mu1 = -1;
        mu = C*[mu0,mu1,0];
    
    case 3
    
        % Need to complete    
        mu0 = -2*omega;
        mu1 = -2i*M^2*omega; 
        mu2 = 1;
        mu = C*[mu0,mu1,mu2];
    
end

newADData.mu = mu;

end