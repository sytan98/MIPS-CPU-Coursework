#!/bin/bash
iverilog -Wall -g 2012 -s control_tb -o control_tb.sim \
control_tb.v control.v
./control_tb.sim