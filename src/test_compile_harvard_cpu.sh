#!/bin/bash
iverilog -Wall -g 2012 -s mips_cpu_harvard -o mips_cpu_harvard.sim \
mips_cpu_harvard.v alu_ctrl.v alu.v branch_addressor.v branch_cond.v \
control.v target_addr_holder.v PC_address_selector.v jump_addressor.v mux_5bit.v \
mux_32bit.v pc.v pc_adder.v reg_hi.v reg_lo.v register_file.v immdt_extender.v