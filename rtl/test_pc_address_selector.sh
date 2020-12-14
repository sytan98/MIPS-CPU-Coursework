#!/bin/bash
set -e

iverilog -Wall -g 2012 -s pc_address_selector_tb -o ./module_tests_outputs/pc_address_selector_tb.sim \
./mips_cpu/pc_address_selector.v ./module_tests/pc_address_selector_tb.v
./module_tests_outputs/pc_address_selector_tb.sim
