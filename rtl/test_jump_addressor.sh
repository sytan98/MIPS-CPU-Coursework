#!/bin/bash
set -e

iverilog -Wall -g 2012 -s jump_addressor_tb -o ./module_tests_outputs/jump_addressor_tb.sim \
./mips_cpu/jump_addressor.v ./module_tests/jump_addressor_tb.v
./module_tests_outputs/jump_addressor_tb.sim
