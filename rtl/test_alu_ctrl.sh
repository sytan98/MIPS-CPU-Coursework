#!/bin/bash
set -e

iverilog -Wall -g 2012 -s alu_ctrl_tb -o ./module_tests_outputs/alu_ctrl_tb.sim \
./module_tests/alu_ctrl_tb.v ./mips_cpu/alu_ctrl.v
./module_tests_outputs/alu_ctrl_tb.sim
