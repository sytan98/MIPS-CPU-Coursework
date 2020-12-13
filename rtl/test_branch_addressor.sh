#!/bin/bash
set -e

iverilog -Wall -g 2012 -s branch_addressor_tb -o ./module_tests_outputs/branch_addressor_tb.sim \
./mips_cpu/branch_addressor.v ./module_tests/branch_addressor_tb.v
./module_tests_outputs/branch_addressor_tb.sim
