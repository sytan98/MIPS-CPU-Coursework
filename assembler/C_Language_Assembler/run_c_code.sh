#!/bin/bash

set -eo pipefail

SRC="$1" #Input will be filename without extension.

mipsisa32r6el-linux-gnu-gcc -O3 0-code/${SRC}.mips1.c -nostdlib -Wl,--build-id=none -T linker.ld -o 4-elf/${SRC}.mips1.elf

mipsisa32r6el-linux-gnu-objdump -d 4-elf/${SRC}.mips1.elf > 2-assembly/${SRC}.mips1.asm.txt

mipsisa32r6el-linux-gnu-objcopy -O binary --only-section=.text 4-elf/${SRC}.mips1.elf 3-binary/${SRC}.mips1.bin

hexdump 3-binary/${SRC}.mips1.bin > 1-hex/${SRC}.mips1.hex.txt


