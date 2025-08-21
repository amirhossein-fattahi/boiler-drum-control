# Boiler Drum Water Level Control
MATLAB/Simulink project comparing PID and Lead/Lag controllers

---

## Project Overview
Precise control of the boiler drum water level in thermal power plants is critical:  
- Too low → poor steam quality  
- Too high → risk of overheating equipment  

This project models the boiler drum as a simplified two-input, one-output LTI system and compares two classical controllers:

- **PID (2-DOF PI)** – guarantees zero steady-state error  
- **Lead/Lag compensator** – improves speed and phase margin, but cannot remove steady-state error  

Both controllers are tested for setpoint tracking and disturbance rejection.

---

## How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/boiler-drum-control.git
   cd boiler-drum-control/src

---

## Results
1. Setpoint Tracking

PID tracks the reference perfectly, while Lead/Lag settles with steady-state offset.


2. Disturbance Rejection

PID rejects the disturbance completely, while Lead/Lag leaves a permanent offset.


3. Frequency Response

Left: PID (robust, slower). Right: Lead/Lag (faster, high phase margin).

<p float="left"> <img src="figs/03_margin_pid.png" width="45%" /> <img src="figs/04_margin_leadlag.png" width="45%" /> </p>