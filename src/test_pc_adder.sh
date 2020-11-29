#!/bin/bash
iverilog -Wall -g 2012 -s pc_adder_tb -o pc_adder_tb.sim \
pc_adder.v pc_adder_tb.v
./pc_adder_tb.sim
