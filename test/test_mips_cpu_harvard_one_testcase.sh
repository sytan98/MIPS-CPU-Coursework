#!/bin/bash
set -eou pipefail

# Can be used to echo commands
# set -o xtrace

# Capture the first two command line parameters to specify
# the CPU SRC and the specific test-base.
# $1, $2, $2, ... represent the arguments passed to the script
SRC="$1"
TESTCASE_ID="$2"
INST=""
for (( i=0; i<${#TESTCASE_ID}; i++ )); do
    if [[ ${TESTCASE_ID:$i:1} != [[:alpha:]] ]]; then
        break
    fi
    INST="${INST}${TESTCASE_ID:$i:1}"
done
# Redirect output to stder (&2) so that it seperate from genuine outputs
# Using ${SRC} substitures in the value of the variable VARIA T
>&2 echo "Test MIPS Harvard CPU using test-case ${TESTCASE_ID}"

>&2 echo " 1 - Compiling test-bench"
# Compile a specific simulator for this SRC and testbench.
# -s specifies exactly which testbench should be top-level
# The -P command is used to modify the RAM_INIT_FILE parameter on the test-bench at compile-time
iverilog -g 2012 \
   mips_cpu_harvard_tb.v ${SRC}/*.v RAM_.v \
   -s mips_cpu_harvard_tb.v \
   -P mips_cpu_harvard_tb.RAM_INIT_FILE=\"cases/${TESTCASE_ID}.hex.txt\" \
   -o simulator/mips_cpu_harvard_tb_${TESTCASE_ID}.sim

>&2 echo "  2 - Running test-bench"
# Run the simulator, and capture all output to a file
# Use +e to disable automatic script failure if the command fails, as
# it is possible the simulation might go wrong.
set +e
simulator/mips_cpu_harvard_tb_${TESTCASE_ID}.sim > output/mips_cpu_harvard_tb_${TESTCASE_ID}.stdout
# $? returns the exit status of the last executed command, which is the simulator
RESULT=$?
set -e

# Check whether the simulator returned a failure code, and immediately quit
if [[ "${RESULT}" -ne 0 ]] ; then
   echo "  ${SRC}, ${TESTCASE_ID}, FAIL"
   exit
fi

>&2 echo "  3 - Extracting result of OUT instructions"
# This is the prefix for simulation output lines containing result of OUT instruction
PATTERN="Output at v0:"
NOTHING=""
# Use "grep" to look only for lines containing PATTERN
set +e
grep "${PATTERN}" output/mips_cpu_harvard_tb_${TESTCASE_ID}.stdout > output/mips_cpu_harvard_tb_${TESTCASE_ID}.out-lines
set -e
# Use "sed" to replace "CPU : OUT   :" with nothing
sed -e "s/${PATTERN}/${NOTHING}/g" output/mips_cpu_harvard_tb_${TESTCASE_ID}.out-lines > output/mips_cpu_harvard_tb_${TESTCASE_ID}.out

>&2 echo "  4 - Comparing output"
# Note the -w to ignore whitespace
set +e
diff -w test/reference/${TESTCASE_ID}.out output/mips_cpu_harvard_tb_${TESTCASE_ID}.out
RESULT=$?
set -e

# Based on whether differences were found, either pass or fail
if [[ "${RESULT}" -ne 0 ]] ; then
   echo "${TESTCASE_ID} ${INST} Fail"
else
   echo "${TESTCASE_ID} ${INST} Pass"
fi