#!/bin/bash
set -e

iverilog -Wall -g 2012 -s control_tb -o ./module_tests_outputs/control_tb.sim \
./module_tests/control_tb.v ./mips_cpu/control.v
./module_tests_outputs/control_tb.sim