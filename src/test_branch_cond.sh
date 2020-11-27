#!/bin/bash
iverilog -Wall -g 2012 -s branch_cond_tb -o branch_cond_tb \ branch_cond.v branch_cond_tb.v
./branch_cond_tb
