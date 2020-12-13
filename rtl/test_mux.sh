#!/bin/bash
set -e

iverilog -Wall -g 2012 -s mux32_tb -o ./module_tests_outputs/mux32_tb.sim \
./mips_cpu/mux_32bit.v ./module_tests/mux32_tb.v
./module_tests_outputs/mux32_tb.sim
