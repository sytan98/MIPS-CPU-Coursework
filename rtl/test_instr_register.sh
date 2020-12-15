#!/bin/bash
set -e

iverilog -Wall -g 2012 -s instr_register_tb -o ./module_tests_outputs/instr_register_tb.sim \
./mips_cpu/instr_register.v ./module_tests/instr_register_tb.v
./module_tests_outputs/instr_register_tb.sim
