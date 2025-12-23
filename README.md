# MIPS 5-Stage Pipelined in VHDL

# Technical Description
VHDL implementation of a MIPS Processor featuring a 5-Stage Pipeline architecture (Instruction Fetch, Decode, Execute, Memory, Write Back).
This project involved the design and RTL (Register-Transfer Level) implementation of a complete MIPS32 processor. 
The architecture incorporates dedicated control units (Main Control, ALU Control) and pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB) to facilitate the parallel execution of instructions (e.g., XOR, SLLV, BNE, BGEZ).

# Objectives
The primary objective was to optimize the instruction throughput by leveraging the pipelining principle. 
This project showcases an in-depth understanding of:
## -> Processor segmentation and the role of pipeline registers.
## -> Data and control flow (Key Control Signals: RegDst, ALUSrc, MemToReg, RegWrite, etc.).
## -> Hardware description using VHDL (implementation and simulation).
## -> The provided RTL schematic offers a detailed graphical representation of the logical interconnections.

# Key Technologies
VHDL, MIPS32 Architecture, 5-Stage Pipelining, RTL Design, FPGA/Hardware Synthesis.
