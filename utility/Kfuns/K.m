function K = K(gamma,ADData,AAData)
% Evaluates the Wiener--Hopf kernel.

omega = AAData.omega;
w = AAData.w;
s = ADData.spac(1);
d = ADData.spac(2);
Sigma = AAData.Sigma;
mu = ADData.mu;

K= (mysqrt(omega*w,gamma).*sin(s*mysqrt(omega*w,gamma)) - (mu(1)-1i*gamma*mu(2)-mu(3)*gamma.^2).*(cos(s*mysqrt(omega*w,gamma)) - cos(d*gamma + Sigma))) ...
            ./(4*pi*(cos(s*mysqrt(omega*w,gamma)) - cos(d*gamma + Sigma)));

end