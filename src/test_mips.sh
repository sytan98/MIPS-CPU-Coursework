#!/bin/bash
set -e

iverilog -g 2012 test_mips_cpu_tb.v mips_cpu_harvard.v instruction_memory.v \
alu.v alu_ctrl.v branch_addressor.v branch_cond.v control.v data_memory.v \
immdt_extender.v mux_32bit.v mux_5bit.v jump_addressor.v reg_hi.v reg_lo.v \
register_file.v pc_adder.v pc.v target_addr_holder.v PC_address_selector.v \
-s test_mips_cpu_tb \
-P test_mips_cpu_tb.ROM_INIT_FILE=\"sw1.hex.txt\" \
-o test_mips_cpu_tb.sim
./test_mips_cpu_tb.sim
