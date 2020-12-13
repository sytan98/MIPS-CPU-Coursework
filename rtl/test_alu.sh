#!/bin/bash
set -e

iverilog -Wall -g 2012 -s alu_iterative_tb -o ./module_tests_outputs/alu_iterative_tb.sim \
./module_tests/alu_tb.v ./mips_cpu/alu.v
./module_tests_outputs/alu_iterative_tb.sim
