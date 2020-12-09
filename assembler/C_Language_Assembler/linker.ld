ENTRY(START)		/* Symbol that "starts" the program */
SECTIONS
{
  /* Create a read-only section, e.g. for ROM */
  . = 0xBFC00000;			/* Section starts at this address*/
  .text : { *(.entry_section) } /* Include anything from these...*/
  .text : { *(.text) }		/* ... sections one after another */
  .text : { *(.text.startup) }
  .text : { *(.rodata) }
  .text : { *(.rodata.*) }

  /* Create a read-write section e.g. for a RAM */
  . = 0x10000000;			  /* Move to a new address*/
  .data : { *(.data) }			/* And lay out symbols here */
  .bss : { *(.bss) }
}
  
