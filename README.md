# HDLBit-Pratice

Verilog + HDLBit-Pratice

https://hdlbits.01xz.net/wiki/Main_Page

# 

FPGA

https://medium.com/@pixelridge/the-art-of-thought-deploying-neural-networks-onto-fpgas-8e91a75ca366

"One of the primary challenges in deploying multi-layer neural networks onto FPGAs is resource allocation. FPGAs have a finite number of logic gates, and each neuron in our network requires a portion of these resources. It’s akin to assigning seats to an ever-growing audience; there’s only so much space in the concert hall. Engineers must therefore design their networks to be as resource-efficient as possible, which often involves pruning redundant connections and neurons, much like an orchestra might omit unnecessary instruments to achieve a more focused sound."

## Neural Redux

# 

https://asmbits.01xz.net/wiki/Main_Page


# CPUlator - CPU Assemble Simulator

https://cpulator.01xz.net/

#

https://www.01xz.net/wiki/Main_Page

# Verilog Files Description

## 1. Getting Started

### step_one.v
Contains a simple module that assigns a constant value of 1 to the output.

### zero.v
Defines a module with an output but no logic.

## 2. Verilog Language

### Basics

#### and_gate.v
Defines a module that performs a logical AND operation on two inputs.

#### inverter.v
Defines a module that inverts the input signal.

#### nor_gate.v
Defines a module that performs a logical NOR operation on two inputs.

#### wire.v
Defines a module that directly connects the input to the output.

#### xnor_gate.v
Defines a module that performs a logical XNOR operation on two inputs.

### Modules Hierarchy

#### module.v
Defines a module that instantiates another module named `mod_a`.

### More Verilog Features

#### adder100i.v
Defines a module that performs a 100-bit addition with carry.

#### bcdadd100.v
Defines a module that performs a 100-digit BCD addition.

#### conditional.v
Defines a module that finds the minimum of four 8-bit inputs using conditional operators.

#### popcount255.v
Defines a module that counts the number of set bits in a 255-bit input.

#### reduction.v
Defines a module that performs reduction operations (AND, OR, XOR) on a 100-bit input.

#### vector100r.v
Defines a module that reverses a 100-bit input vector.

### Procedures

#### always_block1.v
Defines a module that uses both continuous assignment and an always block to perform a logical AND operation.

#### always_block2.v
Defines a module that uses continuous assignment, combinational always block, and sequential always block to perform a logical XOR operation.

#### always_case.v
Defines a module that uses a case statement to select one of six 4-bit inputs based on a 3-bit selector.

#### always_case2.v
Defines a module that uses a case statement to determine the position of the first set bit in a 4-bit input.

#### always_casez.v
Defines a module that uses a casez statement to determine the position of the first set bit in an 8-bit input.

#### always_if.v
Defines a module that uses an if statement to select between two inputs based on two selectors.

# Brief Description of the Repository

This repository contains a collection of Verilog code examples and notes related to digital design and hardware description languages (HDL). The examples cover various aspects of Verilog, including basic gates, modules, procedures, and more advanced features. The repository is organized into different sections to help users get started with Verilog and explore its capabilities.

# Getting Started

The "Getting Started" section provides simple Verilog examples to help beginners understand the basics of the language. It includes modules that perform basic operations such as assigning constant values and defining simple logic gates.

# Verilog Language

The "Verilog Language" section covers various aspects of Verilog, including basic gates, module hierarchy, and more advanced features. It provides examples of how to define and use different types of modules, perform arithmetic operations, and implement conditional logic.

# Circuits

The "Circuits" section includes examples of combinational and sequential logic circuits implemented in Verilog. It covers topics such as arithmetic circuits, basic gates, Karnaugh maps, multiplexers, counters, finite state machines, and shift registers. Each example demonstrates the functionality of a specific type of circuit and provides a brief description of its purpose.

# GitHub Actions Workflows

This repository includes several GitHub Actions workflows for hardware verification and quality assurance:

## Synthesis Workflow

The synthesis workflow ensures that all Verilog modules are synthesizable using Yosys. The workflow is defined in the `.github/workflows/synthesis.yml` file.

## Linting Workflow

The linting workflow uses Verible to perform static code quality checks on all Verilog files. This helps catch common coding issues and ensures adherence to best practices. The workflow is defined in the `.github/workflows/lint.yml` file.

## Simulation Workflow

The simulation workflow uses Icarus Verilog to check for testbench files and verify simulation capabilities. The workflow is defined in the `.github/workflows/simulation.yml` file.

## Verification Workflow

The verification workflow uses Verilator to perform comprehensive lint checks with detailed warnings. This provides an additional layer of verification beyond basic linting. The workflow is defined in the `.github/workflows/verification.yml` file.

## Viewing Workflow Results

To view the workflow results, navigate to the "Actions" tab in your GitHub repository. You will see a list of workflow runs. Click on a specific run to view the details, including any errors or warnings that were encountered during synthesis, linting, simulation, or verification.
