#!/bin/bash
set -e

echo "-----Alu Test"
./test_alu.sh
echo "-----MUX32 Test"
./test_mux.sh
echo "-----Branch Addressor Test"
./test_branch_addressor.sh
echo "-----Branch Cond Test"
./test_branch_cond.sh
echo "-----Immediate Extender Test"
./test_immdt_extender.sh
echo "-----Jump Addressor Test"
./test_jump_addressor.sh
echo "-----PC Test"
./test_pc.sh
echo "-----PC Adder Test"
./test_pc_adder.sh
echo "-----Reg HI and Reg LO Test"
./test_reghilo.sh
echo "-----Reg File Test"
./test_register_file.sh