# ALU 8051 Verification using UVM

## Overview
This repository contains the verification environment for the Arithmetic Logic Unit (ALU) of the 8051 microcontroller using Universal Verification Methodology (UVM). The project aims to rigorously verify the functionality and correctness of the ALU design through extensive simulation and testing.

## Design: ALU 8051
The ALU 8051 is a crucial component of the 8051 microcontroller, responsible for executing arithmetic, logic, and data manipulation operations. It performs a wide range of operations, including addition, subtraction, multiplication, division, logical AND/OR/XOR, shifting, incrementing, decrementing, comparison, and rotating. The ALU design adheres to the specifications of the 8051 microcontroller architecture, ensuring compatibility and reliability in embedded systems applications.

## UVM Verification Environment
The verification of the ALU 8051 design is conducted using the Universal Verification Methodology (UVM), a standardized methodology for verifying digital designs. The UVM environment encompasses a single active agent architecture, featuring components such as a monitor, driver, sequencer, scoreboard, and coverage collector. The scoreboard employs a First-In-First-Out (FIFO) queue to sample signals from the monitor, facilitating efficient comparison and error detection. Various testing strategies are employed, including randomized test cases, direct test cases, and corner cases, to ensure comprehensive verification coverage.

## Assertion
Multiple assertions were made to ensure the design correctability 

## Functional Coverage 
100 % Functional coverage is reached through the tested coverpins
