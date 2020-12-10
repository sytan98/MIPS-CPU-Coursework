#!/bin/bash

set -e 

C="testbench/*.c"
for file in ${C}
do
	# printf ${file} | ./assemble
	TESTCASE=$(basename ${file} .c)
	make ${TESTCASE}.mips.bin
	mv ${TESTCASE}.mips.bin ../cases/
done