#!/bin/bash
set -e

iverilog -Wall -g 2012 -s data_register_tb -o ./module_tests_outputs/data_register_tb.sim \
./mips_cpu/data_register.v ./module_tests/data_register_tb.v
./module_tests_outputs/data_register_tb.sim
