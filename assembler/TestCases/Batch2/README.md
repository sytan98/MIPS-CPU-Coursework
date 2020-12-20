Batch 2
=======

Registers
---------

|       Generic Name        |       Special Name        |       Conventional Use        |
|:-------------------------:|:-------------------------:|:-------------------------|
|$0|zero|Hardwired to always be 0|
|$1|at|Reserved for the assembler (do not use) |
|$2, $3|v0, v1|Return values from procedures|
|$4 - $7|a0 - a3|Arguments of procedure calls|
|$8 - $15|t0 - t7|Temporary registers (caller saved) - procedures may use these $24, $25 t8, t9 freely|
|$24, $25|t8, t9|Temporary registers (caller saved) - procedures may use these $24, $25 t8, t9 freely|
|$16 - $23|s0 - s7|Saved registers (callee saved) - a procedure which alters one of  these must save its value on the stack and restore it before returning to the caller|
|$26, $27|k0,k1|Reserved for operating system kernel (do not use)|
|$28|$gp, gp|Points to memory region containing global variables|
|$29|$sp, sp|Points to memory region containing stack|
|$30|$fp, fp|Points to memory region containing stack frame for current procedure; also known as $s8 and treated as a saved register if not needed for this purpose|
|$31|ra|Holds return address from current procedure|


# EXCEPTIONS

Instructions <b>lb, lbu, lh, lhu, lui, lw, lwl, lwr</b> require memory assignments .ref.txt files contain the mem[address] that needs to be checked.