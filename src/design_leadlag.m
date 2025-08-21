%% design_leadlag.m
run params.m

% Desired phase boost ~45 deg (phi_max)
phi = 45*pi/180;
beta = (1 - sin(phi))/(1 + sin(phi));   % < 1 for LEAD
wc   = 0.05;                             % desired crossover [rad/s]

T = 1/(wc*sqrt(beta));                   % lead time constant
% Standard lead form: K * (T s + 1)/(beta*T s + 1)
% Choose K so |K * Lead(jwc) * G1(jwc)| = 1
w = wc;
Lead_mag = abs((1j*w*T + 1)/(beta*1j*w*T + 1));
G1_mag   = abs(freqresp(G1, w));

K = 1/(Lead_mag*G1_mag);                 % ≈ 1.1 with our defaults

C_LL = zpk([], [], 1) * K * (T*s + 1)/(beta*T*s + 1);

% For reference, report zero/pole/time-constants:
z_lead = -1/T;
p_lead = -1/(beta*T);
disp('Lead/lag parameters:'), K, T, beta, z_lead, p_lead
