#!/bin/bash
set -e

echo "-----Alu CTRL Test"
./test_alu_ctrl.sh
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
echo "-----PC Address Selector Test"
./test_pc_address_selector.sh
echo "-----Reg HI and Reg LO Test"
./test_reghilo.sh
echo "-----Reg File Test"
./test_register_file.sh
echo "-----Destination Register Selector Test"
./test_destination_reg_selector.sh
echo "-----Writedata Selector Test"
./test_writedata_selector.sh
echo "-----Register Writedata Selector Test"
./test_reg_writedata_selector.sh
echo "-----Target Address Holder Test"
./test_target_addr_holder.sh
echo "-----Instruction Register Test"
./test_instr_register.sh
echo "-----Data Register Test"
./test_data_register.sh
