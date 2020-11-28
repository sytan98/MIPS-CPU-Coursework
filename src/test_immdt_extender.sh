#!/bin/bash
iverilog -Wall -g 2012 -s immdt_extender_tb -o immdt_extender_tb \ immdt_extender.v immdt_extender_tb.v
./immdt_extender_tb
