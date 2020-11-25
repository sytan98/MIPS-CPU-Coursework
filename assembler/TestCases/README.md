Test Cases
==========

## Initial Test Cases for:

32-bit little-endian MIPS1 Instruction Set, as defined by the MIPS ISA Specification.

### Instruction Set


|       No      |       Instruction        |       Syntax      |       Operation      |        Description     |
| :----------------: | :---------------: | :---------------: | :---------------- |  ----------------: |
|0|ADDIU|addiu $t, $s, imm|$t = $s + imm; advance_pc (4);|Add immediate unsigned (no overflow)<b> [Implement First]</b>|
|1|ADDU|addu $d, $s, $t|$d = $s + $t; advance_pc (4);|Add unsigned (no overflow)|
|2|AND|and $d, $s, $t|$d = $s & $t; advance_pc (4);|Bitwise and|
|3|ANDI|andi $t, $s, imm|$t = $s & imm; advance_pc (4);|Bitwise and immediate|
|4|BEQ|beq $s, $t, offset|if $s == $t advance_pc (offset << 2)); else advance_pc (4);|Branch on equal|
|5|BGEZ|bgez $s, offset|if $s >= 0 advance_pc (offset << 2)); else advance_pc (4);|Branch on greater than or equal to zero|
|6|BGEZAL|bgezal $s, offset|if $s >= 0 $31 = PC + 8 (or nPC + 4); advance_pc (offset << 2)); else advance_pc (4);|Branch on non-negative (>=0) and link|
|7|BGTZ|bgtz $s, offset|if $s > 0 advance_pc (offset << 2)); else advance_pc (4);|Branch on greater than zero|
|8|BLEZ|blez $s, offset|if $s <= 0 advance_pc (offset << 2)); else advance_pc (4);|Branch on less than or equal to zero|
|9|BLTZ|bltz $s, offset|if $s < 0 advance_pc (offset << 2)); else advance_pc (4);|Branch on less than zero|
|10|BLTZAL|bltzal $s, offset|if $s < 0 $31 = PC + 8 (or nPC + 4); advance_pc (offset << 2)); else advance_pc (4);|Branch on less than zero and link|
|11|BNE|bne $s, $t, offset|if $s != $t advance_pc (offset << 2)); else advance_pc (4);|Branch on not equal|
|12|DIV|div $s, $t|$LO = $s / $t; $HI = $s % $t; advance_pc (4);|Divide|
|13|DIVU|divu $s, $t|$LO = $s / $t; $HI = $s % $t; advance_pc (4);|Divide unsigned|
|14|J|j target|PC = nPC; nPC = (PC & 0xf0000000) | (target << 2);|Jump|
|15|JALR|jalr $t1, $t2|<i>discuss</i>|Jump and link register|
|16|JAL|jal target|$31 = PC + 8 (or nPC + 4); PC = nPC; nPC = (PC & 0xf0000000) | (target << 2);|Jump and link|
|17|JR|jr $s|PC = nPC; nPC = $s;|Jump register<b> [Implement First]</b>|
|18|LB|lb $t, offset($s)|$t = MEM[$s + offset]; advance_pc (4);|Load byte|
|19|LBU|lbu $t, offset($s)|$t = MEM[$s + offset]; advance_pc (4);|Load byte unsigned|
|20|LH|lh $t,off($s)|<i>discuss</i>|Load half-word|
|21|LHU|lh $t,off($s)|<i>discuss</i>|Load half-word unsigned|
|22|LUI|lui $t, imm|$t = (imm << 16); advance_pc (4);|Load upper immediate|
|23|LW|lw $t, offset($s)|$t = MEM[$s + offset]; advance_pc (4);|Load word<b> [Implement First]</b>|
|24|LWL|||Load word left|
|25|LWR|||Load word right|
|26|MTHI|||Move to HI|
|27|MTLO|||011011|Move to LO|
|28|MULT|mult $s, $t|$LO = $s * $t; advance_pc (4);|Multiply|
|29|MULTU|multu $s, $t|$LO = $s * $t; advance_pc (4);|Multiply unsigned|
|30|OR|or $d, $s, $t|$d = $s / $t; advance_pc (4);|Bitwise or|
|31|ORI|ori $t, $s, imm|$t = $s / imm; advance_pc (4);|Bitwise or immediate|
|32|SB|sb $t, offset($s)|MEM[$s + offset] = (0xff & $t); advance_pc (4);|Store byte|
|33|SH|||Store half-word|
|34|SLL|sll $d, $t, h|$d = $t << h; advance_pc (4);|Shift left logical|
|35|SLLV|sllv $d, $t, $s|$d = $t << $s; advance_pc (4);|Shift left logical variable|
|36|SLT|slt $d, $s, $t|if $s < $t $d = 1; advance_pc (4); else $d = 0; advance_pc (4);|Set on less than (signed)|
|37|SLTI|slti $t, $s, imm|if $s < imm $t = 1; advance_pc (4); else $t = 0; advance_pc (4);|Set on less than immediate (signed)|
|38|SLTIU|sltiu $t, $s, imm|if $s < imm $t = 1; advance_pc (4); else $t = 0; advance_pc (4);|Set on less than immediate unsigned|
|39|SLTU|sltu $d, $s, $t|if $s < $t $d = 1; advance_pc (4); else $d = 0; advance_pc (4);|Set on less than unsigned|
|40|SRA|sra $d, $t, h|$d = $t >> h; advance_pc (4);|Shift right arithmetic|
|41|SRAV|||Shift right arithmetic|
|42|SRL|srl $d, $t, h|$d = $t >> h; advance_pc (4);|Shift right logical|
|43|SRLV|srlv $d, $t, $s|$d = $t >> $s; advance_pc (4);|Shift right logical variable|
|44|SUBU|subu $d, $s, $t|$d = $s - $t; advance_pc (4);|Subtract unsigned|
|45|SW|sw $t, offset($s)|MEM[$s + offset] = $t; advance_pc (4);|Store word<b> [Implement First]</b>|
|46|XOR|xor $d, $s, $t|$d = $s ^ $t; advance_pc (4);|Bitwise exclusive or|
|47|XORI|xori $t, $s, imm|$t = $s ^ imm; advance_pc (4);|Bitwise exclusive or immediate|

