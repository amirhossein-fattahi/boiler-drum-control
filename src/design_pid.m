%% design_pid.m
run params.m

% SIMC tuning for FOPDT with zero delay (theta=0):
% Kp = T1/(K1*lambda), Ti = min(T1, 4*lambda), Kd = 0
lambda = 30;                        % closed-loop aggressiveness [s]
Kp = T1/(K1*lambda);                % -> 50/(1*30) = 1.6667
Ti = min(T1, 4*lambda);             % -> 50 s
Ki = Kp/Ti;                         % integrator gain used by MATLAB PID block
Kd = 0;                             % derivative off
N  = 10;                            % derivative filter (block parameter)

% 2-DOF setpoint weights:
beta   = 0.8;   % proportional weight on setpoint (0.6–1.0 typical)
gamma  = 0;     % derivative weight on setpoint (keep 0)

C_PID = pid(Kp, Ki, Kd);
disp('PID (PI) gains:'), Kp, Ki, Kd
