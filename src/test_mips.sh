#!/bin/bash
set -e

iverilog -Wall -g 2012 test_mips_cpu_tb.v mips_cpu_harvard.v instruction_memory.v data_memory.v \
-s test_mips_cpu_tb \
-P test_mips_cpu_tb.ROM_INIT_FILE=\"addiu1.hex.txt\" \
-o test_mips_cpu_tb.sim
./test_mips_cpu_tb.sim