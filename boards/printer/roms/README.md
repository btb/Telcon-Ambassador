Note: U2 on this board was an MM2758Q-A, which is essentially a 2716 EPROM 
with a faulty upper half. However this chip has content stored in both halves. 
So far I haven't seen any signs of corruption in the lower half (character 
data) or upper half (M6802 code).

Disassembly is by [f9dasm](https://github.com/Arakula/f9dasm).

    f9dasm -info printer.nfo -out printer.asm

You should be able to create an identical binary from this disassembly using [A09](https://github.com/Arakula/A09).

    a09 -oM68 -oM00 printer.asm
