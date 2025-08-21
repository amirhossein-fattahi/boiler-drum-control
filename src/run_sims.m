%% run_sims.m  (robust figure saving)
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

% ---------- PLOTS (capture handles) ----------
h1 = figure('Name','SetpointTracking');
plot(t1,y_pid_sp,'-', t1,y_ll_sp,'--'); grid on
title('Setpoint tracking'); xlabel('Time [s]'); ylabel('Level'); legend('PID','Lead/Lag','Location','best')

h2 = figure('Name','DisturbanceRejection');
plot(t,y_pid_d,'-', t,y_ll_d,'--'); grid on
title(sprintf('Disturbance rejection (step at t=%g s)', t_stepD));
xlabel('Time [s]'); ylabel('Level'); legend('PID','Lead/Lag','Location','best')

% Metrics (printed to console)
Sinfo_PID = stepinfo(SP_amp*T_PID);
Sinfo_LL  = stepinfo(SP_amp*T_LL);
disp('Step info (PID vs Lead/Lag):'); Sinfo_PID, Sinfo_LL

% Stability margins
h3 = figure('Name','OpenLoopMargins_PID');
margin(C_PID*G1); grid on; title('Open-loop PID*G1 margins')

h4 = figure('Name','OpenLoopMargins_LeadLag');
margin(C_LL*G1 ); grid on; title('Open-loop Lead/Lag*G1 margins')

% ---------- SAVE PLOTS (robust paths) ----------
% Resolve repo root: .../boiler-drum-control/src -> repoRoot
thisFile = mfilename('fullpath');
if isempty(thisFile)
    curDir  = pwd;                % if running line-by-line
else
    curDir  = fileparts(thisFile);
end
repoRoot = fileparts(curDir);     % go up from src/
figsDir  = fullfile(repoRoot,'figs');
if ~exist(figsDir,'dir'); mkdir(figsDir); end

saveFig = @(h, name) ...
    (exist('exportgraphics','file') == 2) * exportgraphics(h, fullfile(figsDir, name), 'Resolution', 200) + ...
    (exist('exportgraphics','file') ~= 2) * print(h, fullfile(figsDir, erase(name,'.png')), '-dpng','-r200'); %#ok<NASGU>

% Save using handles (names match README)
exportName = @(s) [s '.png'];
saveFig(h1, exportName('01_setpoint_tracking'));
saveFig(h2, exportName('02_disturbance_rejection'));
saveFig(h3, exportName('03_margin_pid'));
saveFig(h4, exportName('04_margin_leadlag'));

disp(['Saved figures to: ' figsDir])
