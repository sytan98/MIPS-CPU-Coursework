#!/bin/bash
set -e

iverilog -Wall -g 2012 -s branch_cond_tb -o ./module_tests_outputs/branch_cond_tb.sim \
./mips_cpu/branch_cond.v ./module_tests/branch_cond_tb.v
./module_tests_outputs/branch_cond_tb.sim
