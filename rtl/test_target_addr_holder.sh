#!/bin/bash
set -e

iverilog -Wall -g 2012 -s target_addr_holder_tb -o ./module_tests_outputs/target_addr_holder_tb.sim \
./mips_cpu/target_addr_holder.v ./module_tests/target_addr_holder_tb.v
./module_tests_outputs/target_addr_holder_tb.sim
