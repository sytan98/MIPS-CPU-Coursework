#!/bin/bash

set -e 

C="testbench/*.c"
for file in ${C}
do
	# printf ${file} | ./assemble
	TESTCASE=$(basename ${file} .c)
	make testbench/${TESTCASE}.mips.bin
	mv testbench/${TESTCASE}.mips.bin cases/${TESTCASE}.hex.txt
done