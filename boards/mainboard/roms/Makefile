SH=bash
ASM=a09
DASM=f9dasm

ambassador.b: ambassador.asm
	$(ASM) -oM68 -oM00 ambassador.asm
	cat U5-DT.bin U6-DT.bin | diff ambassador.b -

ambassador.asm: ambassador.nfo U5-DT.bin U6-DT.bin
	$(DASM) -info ambassador.nfo -out ambassador.asm
