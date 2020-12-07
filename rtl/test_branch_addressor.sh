#!/bin/bash
iverilog -Wall -g 2012 -s branch_addressor_tb -o branch_addressor_tb.sim \
branch_addressor.v branch_addressor_tb.v
./branch_addressor_tb.sim
