#!/bin/bash
set -eou pipefail

g++ hex_to_bytes.cpp -o hex_to_bytes

TESTCASES="./*.hex.txt"

# Loop over every test in cases folder
for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTCASEID=$(basename ${i} .hex.txt)
    >&2 echo $TESTCASEID
    # Dispatch to the main test-case script
    ./hex_to_bytes ${i} ${TESTCASEID}
done