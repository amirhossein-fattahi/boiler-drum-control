%% params.m
% --- Boiler drum simplified LTI model (assumed defaults) ---
% Inputs:
%   u1: feedwater mass flow  (CONTROL)
%   u2: steam outflow        (DISTURBANCE)
% Output:
%   h : drum water level (normalized)

K1 = 0.018;     % feedwater -> level gain
T1 = 13.5;    % time constant [s]

K2 = -0.042;    % steam outflow -> level gain (negative effect)
T2 = 13.3;    % time constant [s]

s = tf('s');
G1 = K1/(T1*s + 1);    % control path
G2 = K2/(T2*s + 1);    % disturbance path  (already negative)

% basic simulation timings
t_end    = 1000;    % [s]
t_stepSP = 100;     % setpoint step time
t_stepD  = 300;     % disturbance step time

% setpoint and disturbance amplitudes (normalized units)
SP_amp = 1.2;       % +1 level step
D_amp  = 0.5;       % +0.5 steam outflow step
