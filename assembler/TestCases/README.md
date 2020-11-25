Test Cases
==========

## Initial Test Cases for:

32-bit little-endian MIPS1 Instruction Set, as defined by the MIPS ISA Specification.

### Instruction Set


|       No      |       Instruction        |       Opcode      |       Action      |
| :----------------: | :---------------: | :---------------: | :----------------: |
|0|ADDIU|000000|Add immediate unsigned (no overflow)<b> [Implement First]</b>|
|1|ADDU|000001|Add unsigned (no overflow)|
|2|AND|000010|Bitwise and|
|3|ANDI|000011|Bitwise and immediate|
|4|BEQ|000100|Branch on equal|
|5|BGEZ|000101|Branch on greater than or equal to zero|
|6|BGEZAL|000110|Branch on non-negative (>=0) and link|
|7|BGTZ|000111|Branch on greater than zero|
|8|BLEZ|001000|Branch on less than or equal to zero|
|9|BLTZ|001001|Branch on less than zero|
|10|BLTZAL|001010|Branch on less than zero and link|
|11|BNE|001011|Branch on not equal|
|12|DIV|001100|Divide|
|13|DIVU|001101|Divide unsigned|
|14|J|001110|Jump|
|15|JALR|001111|Jump and link register|
|16|JAL|010000|Jump and link|
|17|JR|010001|Jump register<b> [Implement First]</b>|
|18|LB|010010|Load byte|
|19|LBU|010011|Load byte unsigned|
|20|LH|010100|Load half-word|
|21|LHU|010101|Load half-word unsigned|
|22|LUI|010110|Load upper immediate|
|23|LW|010111|Load word<b> [Implement First]</b>|
|24|LWL|011000|Load word left|
|25|LWR|011001|Load word right|
|26|MTHI|011010|Move to HI|
|27|MTLO|011011|Move to LO|
|28|MULT|011100|Multiply|
|29|MULTU|011101|Multiply unsigned|
|30|OR|011110|Bitwise or|
|31|ORI|011111|Bitwise or immediate|
|32|SB|100000|Store byte|
|33|SH|100001|Store half-word|
|34|SLL|100010|Shift left logical|
|35|SLLV|100011|Shift left logical variable|
|36|SLT|100100|Set on less than (signed)|
|37|SLTI|100101|Set on less than immediate (signed)|
|38|SLTIU|100110|Set on less than immediate unsigned|
|39|SLTU|100111|Set on less than unsigned|
|40|SRA|101000|Shift right arithmetic|
|41|SRAV|101001|Shift right arithmetic|
|42|SRL|101010|Shift right logical|
|43|SRLV|101011|Shift right logical variable|
|44|SUBU|101100|Subtract unsigned|
|45|SW|101101|Store word<b> [Implement First]</b>|
|46|XOR|101110|Bitwise exclusive or|
|47|XORI|101111|Bitwise exclusive or immediate|

