#!/bin/bash
set -e

iverilog -Wall -g 2012 -s writedata_selector_tb -o ./module_tests_outputs/writedata_selector_tb.sim \
./mips_cpu/writedata_selector.v ./module_tests/writedata_selector_tb.v
./module_tests_outputs/writedata_selector_tb.sim
