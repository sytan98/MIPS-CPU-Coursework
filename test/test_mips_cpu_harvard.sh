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
    TESTCASES="test/cases/*.asm.txt"

    # Loop over every test in cases folder
    for i in ${TESTCASES} ; do
        # Extract just the testcase name from the filename. See `man basename` for what this command does.
        TESTCASEID=$(basename ${i} .asm.txt)
        >&2 echo $TESTCASEID
        # Dispatch to the main test-case script
        ./test/test_mips_cpu_harvard_one_testcase.sh ${SRC} ${TESTCASEID}
    done
else
    >&2 echo "${INSTRUCTION_TYPE} instructions to be tested."
    
    TESTCASES="test/cases/${INSTRUCTION_TYPE}*.asm.txt"
    # Loop over every file matching the TESTCASES pattern
    for i in ${TESTCASES} ; do
        # Extract just the testcase name from the filename. See `man basename` for what this command does.
        TESTCASEID=$(basename ${i} .asm.txt)
        >&2 echo $TESTCASEID
        # Dispatch to the main test-case script
        ./test/test_mips_cpu_harvard_one_testcase.sh ${SRC} ${TESTCASEID}
    done
fi

