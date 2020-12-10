#!/bin/bash

set -e


Test="0-code/*mips1.c"

for i in ${Test}
do

testcase=$(basename ${i})
testcase1=$(basename ${testcase} .mips1.c)
echo ${testcase1}
bash run_c_code.sh ${testcase1}
done
