#!/bin/bash
set -e

iverilog -Wall -g 2012 -s register_file_tb -o register_file_tb.sim \
register_file_tb.v register_file.v
./register_file_tb.sim