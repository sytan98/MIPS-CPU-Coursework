#!/bin/bash
iverilog -Wall -g 2012 -s pc_tb -o pc_tb.sim \
pc.v pc_adder.v pc_tb.v
./pc_tb.sim
