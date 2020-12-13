#!/bin/bash
set -e

echo "Alu Test"
./test_alu.sh
echo "Branch Addressor Test"
./test_branch_addressor.sh
echo "PC Test"
./test_pc.sh