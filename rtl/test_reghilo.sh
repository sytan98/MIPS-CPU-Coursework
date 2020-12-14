#!/bin/bash
set -e

iverilog -Wall -g 2012 -s reg_hi_tb -o ./module_tests_outputs/reg_hi_tb.sim \
./mips_cpu/reg_hi.v ./module_tests/reg_hi_tb.v
iverilog -Wall -g 2012 -s reg_lo_tb -o ./module_tests_outputs/reg_lo_tb.sim \
./mips_cpu/reg_lo.v ./module_tests/reg_lo_tb.v
./module_tests_outputs/reg_hi_tb.sim
./module_tests_outputs/reg_lo_tb.sim
