#!/bin/bash

set -eo pipefail

SRC="$1" #Input will be filename without extension.

mipsel-linux-gnu-gcc -O3 0-code/${SRC}.mips1.c -nostdlib -Wl,--build-id=none -T linker.ld -o 5-elf/${SRC}.mips1.elf

mipsel-linux-gnu-objdump -d -M no-aliases --file-start-context 5-elf/${SRC}.mips1.elf > 3-assembly/${SRC}.mips1.asm.txt

mipsel-linux-gnu-objcopy -O binary --only-section=.text 5-elf/${SRC}.mips1.elf 4-binary/${SRC}.mips1.bin

hexdump 4-binary/${SRC}.mips1.bin > 2-memory/${SRC}.mips1.mem.txt

g++ unwrap.cpp -o unwrap

./unwrap < 2-memory/${SRC}.mips1.mem.txt > 1-hex/${SRC}.mips1.hex.txt
