#!/bin/bash
iverilog -Wall -g 2012 -s reg_hi_tb -o reg_hi_tb.sim \
reg_hi.v reg_hi_tb.v
iverilog -Wall -g 2012 -s reg_lo_tb -o reg_lo_tb.sim \
reg_lo.v reg_lo_tb.v
./reg_hi_tb.sim
./reg_lo_tb.sim
