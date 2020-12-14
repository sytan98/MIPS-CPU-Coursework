#!/bin/bash
set -e

iverilog -Wall -g 2012 -s destination_reg_selector_tb -o ./module_tests_outputs/destination_reg_selector_tb.sim \
./mips_cpu/destination_reg_selector.v ./module_tests/destination_reg_selector_tb.v
./module_tests_outputs/destination_reg_selector_tb.sim
