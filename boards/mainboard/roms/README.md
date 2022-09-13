U5 and U6 are code for the 6800 CPU.

Disassembly is by [f9dasm](https://github.com/Arakula/f9dasm).

    f9dasm -info ambassador.nfo -out ambassador.asm

U60 is the character generator.
U60-V1.4_incomplete.bin is an incomplete dump of this rom. Characters from 0x20 to 0x3f are just copies of 0x00 to 0x1f.
U60-V1.4_restored.bin is a copy of U60-V1.4_incomplete.bin with the missing characters filled in with the equivalents from the printer's character ROM.
