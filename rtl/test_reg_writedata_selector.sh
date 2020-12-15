#!/bin/bash
set -e

iverilog -Wall -g 2012 -s reg_writedata_selector_tb -o ./module_tests_outputs/reg_writedata_selector_tb.sim \
./mips_cpu/reg_writedata_selector.v ./module_tests/reg_writedata_selector_tb.v
./module_tests_outputs/reg_writedata_selector_tb.sim
