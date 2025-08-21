# Boiler Drum Water Level Control (PID vs Lead/Lag)

MATLAB/Simulink project that models a simplified thermal power-plant boiler drum
and compares **PID (2-DOF)** vs **Lead/Lag** controllers for:
1) setpoint tracking, and 2) disturbance rejection (steam outflow step).

## How to run
1. Open MATLAB and `cd` into `src/`.
2. Run, in order:
   ```matlab
   run params.m
   run design_pid.m
   run design_leadlag.m
   run run_sims.m
