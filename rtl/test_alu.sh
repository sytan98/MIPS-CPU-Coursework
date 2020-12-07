#!/bin/bash
iverilog -Wall -g 2012 -s alu_iterative_tb -o alu_iterative_tb.sim \
alu_tb.v alu.v
./alu_iterative_tb.sim
