#!/bin/bash
set -e

iverilog -Wall -g 2012 -s immdt_extender_tb -o ./module_tests_outputs/immdt_extender_tb.sim \
./mips_cpu/immdt_extender.v ./module_tests/immdt_extender_tb.v
./module_tests_outputs/immdt_extender_tb.sim
