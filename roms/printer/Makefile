SH=bash
ASM=a09
DASM=f9dasm

printer.b: printer.asm
	$(ASM) -oM68 -oM00 printer.asm
	diff printer.b U2-80-C01.bin

printer.asm: printer.nfo U2-80-C01.bin
	$(DASM) -info printer.nfo -out printer.asm
