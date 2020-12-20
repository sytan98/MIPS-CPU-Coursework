#!/bin/bash

set -eou pipefail


TEST="$1"

echo "${TEST}.asm.txt" >> ${TEST}.in.txt

./assembler < ${TEST}.in.txt

mv Output.txt ${TEST}.out.txt

rm -r ${TEST}.in.txt