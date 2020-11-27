#!/bin/bash
iverilog -Wall -g 2012 -s mux32_tb -o mux32_tb \ mux_32bit.v mux32_tb.v
iverilog -Wall -g 2012 -s mux5_tb -o mux5_tb \ mux_5bit.v mux5_tb.v
./mux32_tb
./mux5_tb
