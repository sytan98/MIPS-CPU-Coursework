#!/bin/bash
set -e

iverilog -Wall -g 2012 -s register_file_tb -o ./module_tests_outputs/register_file_tb.sim \
./module_tests/register_file_tb.v ./mips_cpu/register_file.v
./module_tests_outputs/register_file_tb.sim