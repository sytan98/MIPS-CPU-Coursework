#!/bin/bash
set -e

iverilog -Wall -g 2012 -s pc_tb -o ./module_tests_outputs/pc_tb.sim \
./mips_cpu/pc.v ./mips_cpu/pc_adder.v ./module_tests/pc_tb.v
./module_tests_outputs/pc_tb.sim