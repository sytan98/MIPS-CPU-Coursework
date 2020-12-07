#!/bin/bash
# -o pipefail means cause a pipeline to return the exit status of the last command in the pipe that returned a non zero return value
# -u means nounset which attempt to use undefined variable outputs error message and force an exit
# -e means abort script at first error
set -eo pipefail

# First parameter to script determines the source folder location
SRC="$1"
INSTRUCTION_TYPE="$2"
# Second parameter to script determines instruction. If no instruction given, run all test cases.
# -z checks if variable is empty
if [ -z INSTRUCTION_TYPE ]
then
    >&2 echo "Instruction not given, running all instructions."
    TESTCASES="test/cases/*.hex.txt"
    passesnum=0
    totalcount=0
    # Loop over every test in cases folder
    for i in ${TESTCASES} ; do
        # Extract just the testcase name from the filename. See `man basename` for what this command does.
        TESTCASEID=$(basename ${i} .hex.txt)
        # >&2 echo $TESTCASEID
        # Dispatch to the main test-case script
        var=`./test/test_mips_cpu_harvard_one_testcase.sh ${SRC} ${TESTCASEID}`
        B=$(echo $var | cut -d " " -f 3-4)
        Pass='Pass'
        echo "$var"
        Pass='Pass'
        if [[ "$B" == "$Pass" ]]; then
            passesnum=`expr $passesnum + 1`
        fi
        totalcount=`expr $totalcount + 1`
    done
else
    >&2 echo "${INSTRUCTION_TYPE} instructions to be tested."
    
    TESTCASES="./test/cases/${INSTRUCTION_TYPE}_*.hex.txt"
    # Loop over every file matching the TESTCASES pattern
    passesnum=0
    totalcount=0
    for i in ${TESTCASES} ; do
        # Extract just the testcase name from the filename. See `man basename` for what this command does.
        TESTCASEID=$(basename ${i} .hex.txt)
        # >&2 echo $TESTCASEID
        # Dispatch to the main test-case script
        var=`./test/test_mips_cpu_harvard_one_testcase.sh ${SRC} ${TESTCASEID}`
        echo "$var"
        B=$(echo $var | cut -d " " -f 3-4)
        Pass='Pass'
        if [[ "$B" == "$Pass" ]]; then
            passesnum=`expr $passesnum + 1`
        fi
        totalcount=`expr $totalcount + 1`
    done
    >&2 echo "Number of Passes = $passesnum out of $totalcount"

fi
