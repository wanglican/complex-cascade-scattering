function [newdata,X,Y] = computeExponents(data,plotdata)

newdata=data;

s=data.spac(1); d=data.spac(2); del=data.spac(3);
sigma=data.sigma;
SQRTa=data.SQRTa;
M=data.M;

LMa = data.LMa;
LPa = data.LPa;
ZMa = data.ZMa;
ZPa = data.ZPa;
TMd = data.TMd;
TPd = data.TPd;
GM0 = data.GM0;
PM0 = data.PM0;

omega = data.omega; 
w=data.w;

X = plotdata.X;
Y = plotdata.Y;
newdata.X = X;
newdata.Y = Y;

xLM3 = bsxfun(@times,X,LMa);         newdata.xLM3 = xLM3;
xLP3 = bsxfun(@times,X,LPa);         newdata.xLP3 = xLP3;
yZM3 = bsxfun(@times,Y,ZMa);         newdata.yZM3 = yZM3;
yZP3 = bsxfun(@times,Y,ZPa);         newdata.yZP3 = yZP3;
yMinSZP3 = bsxfun(@times,Y-s,ZPa);  newdata.yMinSZP3 = yMinSZP3;
yMinSZM3 = bsxfun(@times,Y-s,ZMa);  newdata.yMinSZM3 = yMinSZM3;   

xTM3  = bsxfun(@times,X,TMd);
xTP3  = bsxfun(@times,X,TPd);

xGM0 = bsxfun(@times,X,GM0);
xPM0 = bsxfun(@times,X,PM0);

pressureFactor = -1i*exp(1i*xPM0.*M^2);
velocityFactor =     exp(1i*xPM0.*M^2);

zeta = @(zVar) mysqrt(omega*w,zVar);

A1aResP = -bsxfun(@times,ZPa.*exp(1i*s*ZPa)./(del*SQRTa.*sin(s*ZPa)),cos(yZP3).*exp(-1i*xLP3));
newdata.A1aResP.potential = A1aResP;
newdata.A1aResP.pressure = A1aResP.*(LPa-PM0).*pressureFactor;
newdata.A1aResP.hvelocity = A1aResP.*(-1i*LPa).*velocityFactor;
newdata.A1aResP.vvelocity = -bsxfun(@times,ZPa.*exp(1i*s*ZPa)./(del*SQRTa.*sin(s*ZPa)).*ZPa,-sin(yZP3).*exp(-1i*xLP3)).*velocityFactor;

A1bResP = bsxfun(@times,ZPa./(del*SQRTa.*sin(s*ZPa)),cos(yMinSZP3).*exp(-1i*xLP3));
newdata.A1bResP.potential = A1bResP;
newdata.A1bResP.pressure = A1bResP.*(LPa-PM0).*pressureFactor;
newdata.A1bResP.hvelocity = A1bResP.*(-1i*LPa).*velocityFactor;
newdata.A1bResP.vvelocity = bsxfun(@times,ZPa./(del*SQRTa.*sin(s*ZPa)).*ZPa,-sin(yMinSZP3).*exp(-1i*xLP3)).*velocityFactor;

A1aResM = -bsxfun(@times,ZMa.*exp(-1i*s*ZMa)./(del*SQRTa.*sin(s*ZMa)),cos(yZM3).*exp(-1i*xLM3));
newdata.A1aResM.potential=A1aResM;
newdata.A1aResM.pressure=A1aResM.*(LMa-PM0).*pressureFactor;
newdata.A1aResM.hvelocity=A1aResM.*(-1i*LMa).*velocityFactor;
newdata.A1aResM.vvelocity=-bsxfun(@times,ZMa.*exp(-1i*s*ZMa)./(del*SQRTa.*sin(s*ZMa)).*ZMa,-sin(yZM3).*exp(-1i*xLM3)).*velocityFactor;

A1bResM = bsxfun(@times,ZMa./(del*SQRTa.*sin(s*ZMa)),cos(yMinSZM3).*exp(-1i*xLM3));
newdata.A1bResM.potential = A1bResM;
newdata.A1bResM.pressure = A1bResM.*(LMa-PM0).*pressureFactor;
newdata.A1bResM.hvelocity = A1bResM.*(-1i*LMa).*velocityFactor;
newdata.A1bResM.vvelocity = bsxfun(@times,ZMa./(del*SQRTa.*sin(s*ZMa)).*ZMa,-sin(yMinSZM3).*exp(-1i*xLM3)).*velocityFactor;

A1bTP = bsxfun(@times,exp(1i*(d*TPd+sigma))./(cos(d*TPd+sigma)-cos(zeta(TPd).*s)),cos(zeta(TPd).*Y).*exp(-1i*xTP3));
newdata.A1bTP.potential = A1bTP;
newdata.A1bTP.pressure = A1bTP.*(TPd-PM0).*pressureFactor;
newdata.A1bTP.hvelocity = A1bTP.*(-1i*TPd).*velocityFactor;
newdata.A1bTP.vvelocity =  bsxfun(@times,exp(1i*(d*TPd+sigma))./(cos(d*TPd+sigma)-cos(zeta(TPd).*s)),-zeta(TPd).*sin(zeta(TPd).*Y).*exp(-1i*xTP3)).*velocityFactor;

A1aTP = -bsxfun(@times,1./(cos(d*TPd+sigma)-cos(zeta(TPd).*s)),cos(zeta(TPd).*(Y-s)).*exp(-1i*xTP3));
newdata.A1aTP.potential = A1aTP;
newdata.A1aTP.pressure = A1aTP.*(TPd-PM0).*pressureFactor;
newdata.A1aTP.hvelocity = A1aTP.*(-1i*TPd).*velocityFactor;
newdata.A1aTP.vvelocity =  -bsxfun(@times,1./(cos(d*TPd+sigma)-cos(zeta(TPd).*s)),-zeta(TPd).*sin(zeta(TPd).*(Y-s)).*exp(-1i*xTP3)).*velocityFactor;

A1bTM = bsxfun(@times,exp(1i*(d*TMd+sigma))./(cos(d*TMd+sigma)-cos(zeta(TMd).*s)),cos(zeta(TMd).*Y).*exp(-1i*xTM3));
newdata.A1bTM.potential = A1bTM;
newdata.A1bTM.pressure = A1bTM.*(TMd-PM0).*pressureFactor;
newdata.A1bTM.hvelocity = A1bTM.*(-1i*TMd).*velocityFactor;
newdata.A1bTM.vvelocity = bsxfun(@times,exp(1i*(d*TMd+sigma))./(cos(d*TMd+sigma)-cos(zeta(TMd).*s)),-zeta(TMd).*sin(zeta(TMd).*Y).*exp(-1i*xTM3)).*velocityFactor;

A1aTM = -bsxfun(@times,1./(cos(d*TMd+sigma)-cos(zeta(TMd).*s)),cos(zeta(TMd).*(Y-s)).*exp(-1i*xTM3));
newdata.A1aTM.potential = A1aTM;
newdata.A1aTM.pressure = A1aTM.*(TMd-PM0).*pressureFactor;
newdata.A1aTM.hvelocity = A1aTM.*(-1i*TMd).*velocityFactor;
newdata.A1aTM.vvelocity = -bsxfun(@times,1./(cos(d*TMd+sigma)-cos(zeta(TMd).*s)),-zeta(TMd).*sin(zeta(TMd).*(Y-s)).*exp(-1i*xTM3)).*velocityFactor;

zetaGM0=mysqrt(omega.*w,GM0);
psiZetaGM0=bsxfun(@times,Y,zetaGM0);
psiMinSZetaGM0=bsxfun(@times,Y-s,zetaGM0);

A1bGM0 = bsxfun(@times,exp(1i*(d*GM0+sigma))./(cos(d*GM0+sigma)-cos(s*zetaGM0)),cos(psiZetaGM0).*exp(-1i*xGM0));
newdata.A1bGM0.potential = A1bGM0;
newdata.A1bGM0.pressure = A1bGM0.*(GM0-PM0).*pressureFactor;
newdata.A1bGM0.hvelocity = A1bGM0.*(-1i*GM0).*velocityFactor;
newdata.A1bGM0.vvelocity = bsxfun(@times,exp(1i*(d*GM0+sigma))./(cos(d*GM0+sigma)-cos(s*zetaGM0)).*zetaGM0,-sin(psiZetaGM0).*exp(-1i*xGM0)).*velocityFactor;
 
A1aGM0 = bsxfun(@times,1./(-cos(d*GM0+sigma)+cos(s*zetaGM0)),cos(psiMinSZetaGM0).*exp(-1i*xGM0));
newdata.A1aGM0.potential = A1aGM0;
newdata.A1aGM0.pressure = A1aGM0.*(GM0-PM0).*pressureFactor;
newdata.A1aGM0.hvelocity = A1aGM0.*(-1i*GM0).*velocityFactor;
newdata.A1aGM0.vvelocity = bsxfun(@times,-1./(cos(d*GM0+sigma)-cos(s*zetaGM0)).*zetaGM0,-sin(psiMinSZetaGM0).*exp(-1i*xGM0)).*velocityFactor;

zetaPM0=mysqrt(omega.*w,PM0);
yZetaPM0=bsxfun(@times,Y,zetaPM0);
yMinSZetaPM0=bsxfun(@times,Y-s,zetaPM0);
 
A1bPM0 = bsxfun(@times,exp(1i*(d*PM0+sigma))./(cos(d*PM0+sigma)-cos(s*zetaPM0)),cos(yZetaPM0).*exp(-1i*xPM0));
newdata.A1bPM0.potential = A1bPM0;
newdata.A1bPM0.pressure = 0;
newdata.A1bPM0.hvelocity = A1bPM0.*(-1i*PM0).*velocityFactor;
newdata.A1bPM0.vvelocity = bsxfun(@times,exp(1i*(d*PM0+sigma))./(cos(d*PM0+sigma)-cos(s*zetaPM0)).*zetaPM0,-sin(yZetaPM0).*exp(-1i*xPM0)).*velocityFactor;
 
A1aPM0 = bsxfun(@times,1./(-cos(d*PM0+sigma)+cos(s*zetaPM0)),cos(yMinSZetaPM0).*exp(-1i*xPM0));
newdata.A1aPM0.potential = A1aPM0;
newdata.A1aPM0.pressure = 0;
newdata.A1aPM0.hvelocity = A1aPM0.*(-1i*PM0).*velocityFactor;
newdata.A1aPM0.vvelocity = bsxfun(@times,-1./(cos(d*PM0+sigma)-cos(s*zetaPM0)).*zetaPM0,-sin(yMinSZetaPM0).*exp(-1i*xPM0)).*velocityFactor;

end
