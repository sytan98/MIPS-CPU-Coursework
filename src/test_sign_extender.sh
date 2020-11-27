#!/bin/bash
iverilog -Wall -g 2012 -s sign_extender_tb -o sign_extender_tb \ sign_extender.v sign_extender_tb.v
./sign_extender_tb

echo "sign_extender.v functional"
