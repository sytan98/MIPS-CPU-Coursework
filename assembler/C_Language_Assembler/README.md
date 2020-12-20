# Converting C Language code into MIPS Assembly language

## Requirements
-   Ubuntu: sudo apt-get install   gcc-mipsisa32r6el-linux-gnu (fom compiling to MIPS 32-bit Little Endian Assembly)

## Instructions

### Functionality
<b><u>gcc</u></b>
1.  `gcc -c src1.c -o src1.o`   :   Compile src1.c in to object file src1.o
2.  `gcc -S src1.c -o src1.o`   :   Compile src1.c in to Assembly file src1.o
3.  `gcc    src1.s -o prog`   :   Assemble src1.s and link into executable
4.  `gcc    src1.o -o prog`   :   Link src1.o into executable
5.  `gcc    src1.c -o prog`   :   Compile src1.c and link into executable

<b><u>Flags</u></b>
1.  `-O3`   : Optimise compile code. It may optimise _all_ your code anyway.
2.  `-static`   : Link statically - do not load shared code at run-time.
3.  `-Wl, -Bstatic` : Really, really link statically
4.  `-nostdlib` : Don't try to link the C run-time library.
5.  `-march=mips1`  : Force instructions t only come from MIPS1 ISA.

<b><u>Tools</u></b>
1.  objdump   : Allows you to dump the contents of an object file or executable.
2.  objcopy   : Lets you extract data from an object file or executable.

<b><u>Info</u></b>
1.  `.text` section includes the instructions to perform
2.  J-Type instructions may not work as initial address is set at 0x0 _(NOT RESET VECTOR 0xBFC00000)_


### Compiling:

    $ mipsisa32r6el-linux-gnu-gcc [file.c] -c -o [file.mips1.o]

### Assembling:

    $ mipsisa32r6el-linux-gnu-gcc [file.c] -S -o [file.mips1.s]

### To look into assembly file:

    $ less [file.mips1.s]

### Assembling with optimisation turned on - To get the code as we want to:

    $ mipsisa32r6el-linux-gnu-gcc -O3 [file.c] -S -o [file.mips1.s]

### Compiling and Linking:

    $ mipsisa32r6el-linux-gnu-gcc -O3 [file.c] -S -o [file.mips1.s] - nostdlib

_Function inslide [file.c] must be named "__start" (double underscore) to compile successfully._


## objdump & objcopy

### Disassembly of MIPS executable .text section

_Prints the assembly code of [file.mips1.o]_

    $ mipsisa32r6el-linux-gnu-objdump -d [file.mips1.o]

### Disassembly of MIPS executable USEFUL .text section 

_Prints the useful assembly code of [file.mips1.o] representing just our code._

    $ mipsisa32r6el-linux-gnu-gcc -O3 [file.c] -c -o [file.mips1.o]

    $ mipsisa32r6el-linux-gnu-objdump -d [file.mips1.o]

<i>Notice: __start has been put to address 0x00000000</i>  

Useful Info:
    
    $ mipsisa32r6el-linux-gnu-gcc -O3 [file.c] -c -g -o [file.mips1.o]

    $ mipsisa32r6el-linux-gnu-objdump -S [file.mips1.o]
adds c-code of program to the output.

### Initialising linker.ld to store starting address for ROM _(instructions)_ and RAM _(data)_.


    ENTRY(START)            /* Symbol that "starts" the program */
    SECTIONS
    {
    /* Create a read-only section, e.g. for ROM */
    . = 0xBFC00000;                       /* Section starts at this address*/
    .text : { *(.entry_section) } /* Include anything from these...*/
    .text : { *(.text) }          /* ... sections one after another */
    .text : { *(.text.startup) }
    .text : { *(.rodata) }
    .text : { *(.rodata.*) }

    /* Create a read-write section e.g. for a RAM */
    . = 0x10000000;                         /* Move to a new address*/
    .data : { *(.data) }                  /* And lay out symbols here */
    .bss : { *(.bss) }
    }
### Using _linker.ld_ to run C code:

    $ mipsisa32r6el-linux-gnu-gcc -O3 [file.c] -nostdlib -Wl,--build-id=none -T linker.ld -o [file.mips1.elf]

    $ mipsisa32r6el-linux-gnu-objdump -d [file.mips1.elf]

_The above will print the instructions starting from address 0xBFC00000 therefore J-Type instructions will be correct._


## Converting Assembly Code to binary file

    $ mipsisa32r6el-linux-gnu-objcopy -O binary --only-section=.text [file.mips1.elf] [file.mips1.bin]

    $ hexdump [file.mips1.bin]

_First command turns [.elf] file into binary and second prints the hex representations of the binary file in groups of 4 hex symbols._
