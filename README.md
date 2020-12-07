# elec50010-mips-coursework

An implementation of a Harvard MIPS CPU. 

## Folder structure:

+-- rtl
|   +-- mips_cpu_harvard.v
|   +-- alu.v
|   +-- register_file.v
|   +-- ...
+-- test
|   +-- cases
|   +-- output
|   +-- reference
|   +-- simulator
|   +-- test_mips_cpu_harvard.sh

## How to use:
To test:
run ./test/test_mips_cpu_harvard.sh [source_directory] [instruction]
The output files can be used for debugging and will be stored in the ./test/output 