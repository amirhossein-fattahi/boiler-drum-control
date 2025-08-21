%% run_sims.m
run params.m
run design_pid.m
run design_leadlag.m

% Closed-loop maps with negative feedback around G1 and controller C:
% y = T*r + (S*G2)*d , where T = G1*C/(1+G1*C) and S = 1/(1+G1*C)
T_PID = minreal(G1*C_PID/(1 + G1*C_PID));
S_PID = minreal(1/(1 + G1*C_PID));
D_PID = minreal(S_PID*G2);                 % disturbance -> y

T_LL  = minreal(G1*C_LL /(1 + G1*C_LL));
S_LL  = minreal(1/(1 + G1*C_LL));
D_LL  = minreal(S_LL*G2);

t = linspace(0,t_end,5000);

% --- Scenario A: setpoint step ---
[y_pid_sp, t1] = step(SP_amp*T_PID, t);
[y_ll_sp,  ~ ] = step(SP_amp*T_LL,  t);

% --- Scenario B: disturbance step (applied at t_stepD) ---
uD = (t >= t_stepD)*D_amp;                   % time signal
[y_pid_d, ~] = lsim(D_PID, uD, t);
[y_ll_d,  ~] = lsim(D_LL,  uD, t);

% overlay plots
figure; plot(t1,y_pid_sp,'-', t1,y_ll_sp,'--'); grid on
title('Setpoint tracking'); xlabel('Time [s]'); ylabel('Level'); legend('PID','Lead/Lag')

figure; plot(t,y_pid_d,'-', t,y_ll_d,'--'); grid on
title('Disturbance rejection (step at t=300 s)'); xlabel('Time [s]'); ylabel('Level'); legend('PID','Lead/Lag')

% Metrics
Sinfo_PID = stepinfo(SP_amp*T_PID);
Sinfo_LL  = stepinfo(SP_amp*T_LL);
disp('Step info (PID vs Lead/Lag):'); Sinfo_PID, Sinfo_LL

% Stability margins
figure; margin(C_PID*G1); grid on; title('Open-loop PID*G1 margins')
figure; margin(C_LL*G1 ); grid on; title('Open-loop Lead/Lag*G1 margins')
