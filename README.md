This project implements a cycle-accurate digital AHB-to-APB Bridge in Verilog. It serves as a communication interface between a high-performance AHB-Lite bus and low-power APB3 peripherals, handling the protocol conversion and timing requirements.

📌 Project Overview
Design Level: RTL (Register Transfer Level)

Protocol: AMBA AHB-Lite to APB3

FSM States: IDLE, SETUP, ACCESS

Verification: Functional Simulation with timing analysis

🛠️ Technologies & Tools Used
Verilog HDL: Hardware Description Language for core logic

Icarus Verilog: Open-source compiler and simulator

GTKWave: Waveform visualization and timing analysis

VS Code: Primary code editor

📂 Project Files
ahb_apb_bridge.v: Main RTL source code for the bridge logic

tb_bridge.v: Testbench file for verifying protocol timing

waveform.png: Simulation output screenshot showing signal transitions

▶️ Execution and Simulation
To verify the design on a local machine, follow these steps:

Compile the design and testbench:

Bash
iverilog -o bridge_sim ahb_apb_bridge.v tb_bridge.v
Run the simulation to generate the VCD file:

Bash
vvp bridge_sim
View the timing diagrams:

Bash
gtkwave simulation.vcd
📤 Output and Verification
Protocol Conversion: Successfully converts AHB Master signals into synchronized APB PSEL and PENABLE signals.

Verification: The testbench verifies single-write transfers with correct clock cycle delays.

Status: Functional verification complete with 0 timing violations.

Simulation Results
The waveform below confirms that PSEL is asserted during the SETUP phase and PENABLE follows in the ACCESS phase, fulfilling the AMBA APB protocol requirements.

Figure 1: Timing diagram showing HCLK, HSEL, PSEL, and PENABLE transitions.

👤 Author
Name: Kartik Murti

Project Type: Digital Logic Design / VLSI Verification
