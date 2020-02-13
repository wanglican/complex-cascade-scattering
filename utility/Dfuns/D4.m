function [D4]=D4(data,data2)

C=data2.C;
KMG=data.KMG;
gminPM0=data.gminPM0;
KMTM=data.KMTM;

gminTM=data.gminTM;

D4terms=bsxfun(@rdivide,C.*KMTM,gminTM).*exp(2i*gminTM);
D4=-sum(D4terms,3)./(1i*KMG.*gminPM0);

end