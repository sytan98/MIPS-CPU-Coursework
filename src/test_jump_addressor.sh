#!/bin/bash
iverilog -Wall -g 2012 -s jump_addressor_tb -o jump_addressor_tb.sim \
jump_addressor.v jump_addressor_tb.v
./jump_addressor_tb.sim
