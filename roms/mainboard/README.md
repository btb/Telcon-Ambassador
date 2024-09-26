# Mainboard ROMs

## U5 and U6

Code for the 6800 CPU

Disassembly done with the help of [f9dasm](https://github.com/Arakula/f9dasm).

    f9dasm -info ambassador.nfo -out ambassador.asm

You should be able to create an identical binary from this disassembly using [A09](https://github.com/Arakula/A09).

    a09 -oM68 -oM00 ambassador.asm

## U60

Character generator.

U60-V1.4_incomplete.bin is an incomplete dump of this ROM. Characters from 0x20 to 0x3f are just copies of 0x00 to 0x1f.

U60-V1.4_restored.bin is a copy of U60-V1.4_incomplete.bin with the missing characters filled in with the equivalents from the printer's character ROM.
