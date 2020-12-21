#!/bin/bash
set -e

iverilog -Wall -g 2012 -s memory_write_tb -o memory_write_tb.sim \
memory_write_tb.v bus_memory.v
./memory_write_tb.sim