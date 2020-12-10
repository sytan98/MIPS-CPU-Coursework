ENTRY(entry)
SECTIONS
{
  . = 0xBFC00000;
  .text : { *(.entry_section) }
  .text : { *(.text) }
  .text : { *(.text.startup) }
  .text : { *(.rodata) }
  .text : { *(.rodata.*) }

  . = 0x00000001;
  .data : { *(.data) }
  .bss : { *(.bss) }
}