clc, clearvars, close all;

meanV = 77.78;
sigmaV = 0.71;
meanI = 1.21;
sigmaI = 0.071;
meanf = 0.283;
sigmaf = 0.017;
V = meanV;
I = meanI;
f = meanf;

% Question (a)
sigmaP = sqrt((I * cos(f) * sigmaV)^2 + (V * cos(f) * sigmaI)^2 + (-V * I * sin(f) * sigmaf)^2);

% Question (b)
M = 1000;
mu = [meanV, meanI, meanf];
C = [sigmaV^2, 0, 0; 0, sigmaI^2, 0; 0, 0, sigmaf^2];
R = mvnrnd(mu, C, M);
V = R(:,1);
I = R(:,2);
f = R(:,3);
P = V .* I .* cos(f);
stdP = std(P);
fprintf('(b) Expected SD of P: %.4f,  Observed SD of P: %.4f\n', sigmaP, stdP);

% Question (c)
rhoVf = 0.5;
V = meanV;
I = meanI;
f = meanf;
covVf = rhoVf * sigmaV * sigmaf;
sigmaP = sqrt((I * cos(f) * sigmaV)^2 + (V * cos(f) * sigmaI)^2 + ...
    (-V * I * sin(f) * sigmaf)^2 + 2 * (-V * I * sin(f)) * (I * cos(f)) * covVf);
C = [sigmaV^2, 0, covVf; 0, sigmaI^2, 0; covVf, 0, sigmaf^2];
R = mvnrnd(mu, C, M);
V = R(:,1);
I = R(:,2);
f = R(:,3);
P = V .* I .* cos(f);
stdP = std(P);
fprintf('(c) Expected SD of P: %.4f,  Observed SD of P: %.4f\n', sigmaP, stdP);
