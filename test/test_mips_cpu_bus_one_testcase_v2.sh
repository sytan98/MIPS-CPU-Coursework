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
>&2 echo "Test MIPS Bus CPU using test-case ${TESTCASE_ID}"

>&2 echo "  1 - Compiling test-bench"
# Compile a specific simulator for this SRC and testbench.
# -s specifies exactly which testbench should be top-level
# The -P command is used to modify the RAM_INIT_FILE parameter on the test-bench at compile-time

srcfilestocompile=""
srcfiles1="${SRC}/mips_cpu/*.v"
if ls ${srcfiles1} 1> /dev/null 2>&1; then
    for i in ${srcfiles1} ; do
        # Extract just the testcase name from the filename. See `man basename` for what this command does.
        srcfilestocompile="$srcfilestocompile $i"
    done
fi
srcfiles2="${SRC}/mips_cpu_*.v"
if ls ${srcfiles2} 1> /dev/null 2>&1; then
    for i in ${srcfiles2} ; do
        # Extract just the testcase name from the filename. See `man basename` for what this command does.
        srcfilestocompile="$srcfilestocompile $i"
    done
fi

>&2 echo $srcfilestocompile

iverilog -g 2012 \
./test/mips_cpu_bus_tb_random.v ./test/bus_memory.v \
$srcfilestocompile \
-s mips_cpu_bus_tb_random \
-P mips_cpu_bus_tb_random.ROM_INIT_FILE=\"./test/cases/${TESTCASE_ID}.bytes.txt\" \
-o ./test/simulator/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.sim

iverilog -g 2012 \
./test/mips_cpu_bus_tb_constant.v ./test/bus_memory.v \
$srcfilestocompile \
-s mips_cpu_bus_tb_constant \
-P mips_cpu_bus_tb_constant.NUM_STALLS=0 \
-P mips_cpu_bus_tb_constant.ROM_INIT_FILE=\"./test/cases/${TESTCASE_ID}.bytes.txt\" \
-o ./test/simulator/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.sim

iverilog -g 2012 \
./test/mips_cpu_bus_tb_constant.v ./test/bus_memory.v \
$srcfilestocompile \
-s mips_cpu_bus_tb_constant \
-P mips_cpu_bus_tb_constant.NUM_STALLS=3 \
-P mips_cpu_bus_tb_constant.ROM_INIT_FILE=\"./test/cases/${TESTCASE_ID}.bytes.txt\" \
-o ./test/simulator/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.sim

>&2 echo "  2 - Running test-bench"
# Run the simulator, and capture all output to a file
# Use +e to disable automatic script failure if the command fails, as
# it is possible the simulation might go wrong.
set +e
./test/simulator/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.sim > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.stdout
# $? returns the exit status of the last executed command, which is the simulator
RESULT1=$?
./test/simulator/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.sim > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.stdout
# $? returns the exit status of the last executed command, which is the simulator
RESULT2=$?
./test/simulator/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.sim > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.stdout
# $? returns the exit status of the last executed command, which is the simulator
RESULT3=$?
set -e

# Check whether the simulator returned a failure code, and immediately quit
if [[ "${RESULT1}" -ne 0 ||  "${RESULT2}" -ne 0 ]] || [[ "${RESULT3}" -ne 0 ]] ; then
    echo "${TESTCASE_ID} ${INST} Fail   # CPU Failed to Simulate"
    exit
fi
# Save a copy of testcase waveform
cp mips_cpu_bus_tb_random.vcd ./test/waveforms/mips_cpu_bus_tb_${TESTCASE_ID}_random.vcd
cp mips_cpu_bus_tb_constant.vcd ./test/waveforms/mips_cpu_bus_tb_${TESTCASE_ID}_constant.vcd

>&2 echo "  3 - Extracting result of OUT instructions"
# This is the prefix for simulation output lines containing result of OUT instruction
PATTERN="Output at v0:"
NOTHING=""
# Use "grep" to look only for lines containing PATTERN
set +e
grep "${PATTERN}" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.stdout > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.out-lines
grep "${PATTERN}" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.stdout > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.out-lines
grep "${PATTERN}" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.stdout > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.out-lines
set -e
# Use "sed" to replace "CPU : OUT   :" with nothing
sed -e "s/${PATTERN}/${NOTHING}/g" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.out-lines > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.out
sed -e "s/${PATTERN}/${NOTHING}/g" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.out-lines > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.out
sed -e "s/${PATTERN}/${NOTHING}/g" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.out-lines > ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.out

>&2 echo "  4 - Comparing output"
# Note the -w to ignore whitespace
set +e
diff -w -B -i ./test/reference/${TESTCASE_ID}.ref.txt ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.out &>/dev/null
RESULT1=$?
diff -w -B -i ./test/reference/${TESTCASE_ID}.ref.txt ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.out &>/dev/null
RESULT2=$?
diff -w -B -i ./test/reference/${TESTCASE_ID}.ref.txt ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.out &>/dev/null
RESULT3=$?
set -e

# Based on whether differences were found, either pass or fail
if [[ "${RESULT1}" -ne 0 ]]  ; then
    EXPECTED_V0=`grep -E "*" ./test/reference/${TESTCASE_ID}.ref.txt`
    RECEIVED_V0=`grep -E "*" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_random_wait.out`
    echo "${TESTCASE_ID} ${INST} Fail   # Expected v0:${EXPECTED_V0} But got:${RECEIVED_V0} during random waitrequests"
elif [[ "${RESULT2}" -ne 0 ]] ; then
    EXPECTED_V0=`grep -E "*" ./test/reference/${TESTCASE_ID}.ref.txt`
    RECEIVED_V0=`grep -E "*" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_wait.out`
    echo "${TESTCASE_ID} ${INST} Fail   # Expected v0:${EXPECTED_V0} But got:${RECEIVED_V0} during constant waitrequests of 3"
elif [[ "${RESULT3}" -ne 0 ]] ; then
    EXPECTED_V0=`grep -E "*" ./test/reference/${TESTCASE_ID}.ref.txt`
    RECEIVED_V0=`grep -E "*" ./test/output/mips_cpu_bus_tb_${TESTCASE_ID}_constant_zero.out`
    echo "${TESTCASE_ID} ${INST} Fail   # Expected v0:${EXPECTED_V0} But got:${RECEIVED_V0} during zero waitrequest"
else
    set +e
    COMMENT=`grep "${TESTCASE_ID}" ./test/comments.txt | cut -d ":" -f 2-`
    COMMENT_RESULT=$?
    set -e
    if [[ "${COMMENT_RESULT}" -ne 0 ]] ; then
        echo "${TESTCASE_ID} ${INST} Pass"
    else
        echo "${TESTCASE_ID} ${INST} Pass   # ${COMMENT}"
    fi
fi